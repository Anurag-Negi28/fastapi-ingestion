#!/bin/bash

echo "🧼 Cleaning previous JMeter and SonarQube outputs..."
rm -rf results.jtl jmeter.log jmeter-html-report

echo "🚀 Starting all services with Docker Compose..."
docker compose -f docker-compose.yml -f docker-compose.sonar.yml up -d

echo "⏳ Waiting for services to be ready..."
echo "🟡 Waiting 60 seconds for databases to initialize..."
sleep 60

echo "🔄 Waiting 30 more seconds for FastAPI app to connect to database..."
sleep 30

# Check SonarQube accessibility
echo "🔍 Checking SonarQube accessibility..."
if curl -s "http://localhost:9000" > /dev/null 2>&1; then
    echo "✅ SonarQube is accessible!"
else
    echo "⚠️  SonarQube might not be fully ready, but continuing..."
    echo "📍 You can check SonarQube manually at http://localhost:9000"
fi

# Check FastAPI app accessibility
echo "🔍 Checking FastAPI app accessibility..."
if curl -s "http://localhost:8000" > /dev/null 2>&1; then
    echo "✅ FastAPI app is accessible!"
    echo "🔍 Testing FastAPI health endpoint..."
    curl -s "http://localhost:8000/docs" > /dev/null && echo "✅ FastAPI docs accessible" || echo "⚠️  FastAPI docs not accessible"
else
    echo "⚠️  FastAPI app is not accessible, checking logs..."
    echo "📋 FastAPI Container Logs:"
    docker logs fastapi_app --tail 10
fi

echo "🧪 Running JMeter load test..."
jmeter -n -t tests/test.jmx -l results.jtl -j jmeter.log

# Generate HTML report if JMeter supports it
if jmeter --help | grep -q "\-e"; then
    echo "📈 Generating HTML report..."
    jmeter -g results.jtl -o jmeter-html-report
    echo "📊 HTML report generated at jmeter-html-report/index.html"
else
    echo "📋 HTML report generation not supported in this JMeter version"
    echo "📊 View results in results.jtl"
fi

# Check JMeter results
echo "📊 JMeter Test Summary:"
if [ -f results.jtl ]; then
    TOTAL_REQUESTS=$(tail -n +2 results.jtl | wc -l)
    ERRORS=$(tail -n +2 results.jtl | awk -F',' '$8=="false" {count++} END {print count+0}')
    SUCCESS_RATE=$(echo "scale=2; ($TOTAL_REQUESTS - $ERRORS) * 100 / $TOTAL_REQUESTS" | bc 2>/dev/null || echo "N/A")
    echo "   • Total Requests: $TOTAL_REQUESTS"
    echo "   • Errors: $ERRORS"
    echo "   • Success Rate: $SUCCESS_RATE%"
else
    echo "   • No results file found"
fi

echo "🧹 Removing previous SonarScanner container if it exists..."
docker rm -f sonar_scanner > /dev/null 2>&1 || true

echo "🔍 Running SonarScanner analysis..."
echo "⚠️  Note: SonarScanner may need initial setup in SonarQube web interface"
docker compose -f docker-compose.yml -f docker-compose.sonar.yml run --rm sonar_scanner || echo "⚠️  SonarScanner failed - may need manual setup"

echo ""
echo "✅ Analysis complete!"
echo ""
echo "📊 Results Summary:"
echo "   • JMeter Results: results.jtl"
echo "   • JMeter Log: jmeter.log"
echo "   • HTML Report: jmeter-html-report/index.html"
echo "   • SonarQube UI: http://localhost:9000 (admin/admin)"
echo "   • FastAPI App: http://localhost:8000"
echo "   • FastAPI Docs: http://localhost:8000/docs"
