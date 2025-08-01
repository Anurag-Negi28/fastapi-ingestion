# FastAPI Data Ingestion & Performance Analysis Pipeline

A comprehensive FastAPI-based data ingestion service with automated performance testing and code quality analysis. This project demonstrates a complete DevOps pipeline including containerized deployment, load testing with JMeter, and code quality analysis with SonarQube.

## 🚀 Features

- **FastAPI Web Service**: High-performance REST API for data ingestion
- **PostgreSQL Integration**: Persistent data storage with SQLAlchemy ORM
- **Automated Load Testing**: JMeter-based performance testing with 100 concurrent users
- **Code Quality Analysis**: SonarQube integration for code quality metrics
- **Docker Containerization**: Complete containerized environment
- **Automated Pipeline**: One-script execution for complete analysis
- **HTML Reporting**: Comprehensive test result visualization

## 🏗️ Architecture

![FastAPI Data Ingestion Architecture](assets/Fast%20API%20Data%20Ingestion.webp)

## 📋 Prerequisites

- **Docker**: Latest version with Docker Compose
- **JMeter**: Version 5.6+ for load testing
- **Git**: For version control
- **Bash**: For running analysis scripts (Linux/macOS/WSL)

### Installation Commands

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install docker.io docker-compose-plugin

# Download JMeter
wget https://downloads.apache.org/jmeter/binaries/apache-jmeter-5.6.3.tgz
tar -xzf apache-jmeter-5.6.3.tgz
sudo mv apache-jmeter-5.6.3 /opt/jmeter
echo 'export PATH=$PATH:/opt/jmeter/bin' >> ~/.bashrc
source ~/.bashrc
```

## 🛠️ Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/Anurag-Negi28/fastapi-ingestion.git
cd fastapi-ingestion
```

### 2. Environment Setup

The project uses environment variables defined in `.env`:

```bash
# Database Configuration
POSTGRES_USER=postgres
POSTGRES_PASSWORD=yourpassword
POSTGRES_DB=ingestion_db

# SonarQube Configuration
SONAR_PROJECT_KEY=fastapi-ingestion
SONAR_HOST_URL=http://sonarqube:9000
SONAR_LOGIN=your_sonar_token
```

### 3. Run Complete Analysis

```bash
./run_analysis.sh
```

This single command will:

- 🧼 Clean previous results
- 🚀 Start all Docker services
- ⏳ Wait for services initialization
- 🔍 Perform health checks
- 🧪 Execute JMeter load testing (100 concurrent users)
- 📊 Generate HTML performance reports
- 🔍 Run SonarQube code quality analysis

## 📁 Project Structure

```
fastapi-ingestion/
├── app/                          # FastAPI application
│   ├── __init__.py
│   ├── main.py                   # FastAPI app entry point
│   ├── models.py                 # SQLAlchemy models
│   ├── database.py               # Database configuration
│   ├── crud.py                   # Database operations
│   ├── Dockerfile                # App container definition
│   └── requirements.txt          # Python dependencies
├── tests/
│   └── test.jmx                  # JMeter test configuration
├── docker-compose.yml            # Main services (FastAPI + PostgreSQL)
├── docker-compose.sonar.yml      # SonarQube services
├── sonar-project.properties      # SonarQube configuration
├── run_analysis.sh               # Main analysis script
├── .env                          # Environment variables
├── .gitignore                    # Git ignore rules
└── README.md                     # This file
```

## 🧪 Testing Configuration

### JMeter Load Testing

- **Concurrent Users**: 100 threads
- **Ramp-up Time**: 30 seconds
- **Loops per User**: 10 iterations
- **Total Requests**: 1,000
- **Target Endpoint**: `POST /ingest`

### Test Data Format

```json
{
  "name": "test_user",
  "age": 25,
  "city": "Delhi"
}
```

## 📊 API Endpoints

### POST /ingest

Ingests user data into the PostgreSQL database.

**Request Body:**

```json
{
  "name": "string",
  "age": "integer",
  "city": "string"
}
```

**Response:**

```json
{
  "message": "Data ingested successfully",
  "id": 1
}
```

### GET /docs

FastAPI interactive documentation (Swagger UI)

### GET /redoc

Alternative API documentation

## 🐳 Docker Services

### Main Application Stack

- **FastAPI App**: `localhost:8000`
- **PostgreSQL**: `localhost:5432`

### Analysis Stack

- **SonarQube**: `localhost:9000`
- **SonarQube Database**: Internal PostgreSQL instance

## 📈 Results & Reports

After running `./run_analysis.sh`, access results at:

### Performance Testing

- **HTML Report**: `jmeter-html-report/index.html`
- **Raw Results**: `results.jtl`
- **JMeter Logs**: `jmeter.log`

### Code Quality

- **SonarQube Dashboard**: `http://localhost:9000`
- **Project**: `fastapi-ingestion`

### Application Access

- **FastAPI App**: `http://localhost:8000`
- **API Documentation**: `http://localhost:8000/docs`

## 🔧 Manual Operations

### Build FastAPI Image

```bash
docker-compose build web
```

### Start Services Individually

```bash
# Start main application
docker-compose up -d

# Start analysis services
docker-compose -f docker-compose.sonar.yml up -d
```

### Run JMeter Tests Only

```bash
jmeter -n -t tests/test.jmx -l results.jtl -j jmeter.log
jmeter -g results.jtl -o jmeter-html-report
```

### SonarQube Setup

1. Access `http://localhost:9000`
2. Login: `admin` / `admin`
3. Change default password
4. Generate user token
5. Update `.env` with token

## 🔍 Troubleshooting

### Common Issues

**Docker Permission Denied**

```bash
sudo usermod -aG docker $USER
newgrp docker
```

**JMeter Command Not Found**

```bash
export PATH=$PATH:/opt/jmeter/bin
```

**SonarQube Authentication Error**

- Access SonarQube web interface
- Change default password
- Generate and configure user token

**Database Connection Issues**

- Verify PostgreSQL container is running
- Check database credentials in `.env`
- Ensure proper wait times in script

### Log Analysis

```bash
# FastAPI logs
docker logs fastapi_app

# Database logs
docker logs pgdb

# SonarQube logs
docker logs sonarqube
```

## 🚀 Performance Benchmarks

Expected performance metrics:

- **Response Time**: < 100ms (95th percentile)
- **Throughput**: > 500 requests/second
- **Error Rate**: < 1%
- **Database Connections**: Efficient connection pooling

## 🔒 Security Considerations

- Environment variables for sensitive data
- Database password protection
- Container network isolation
- SonarQube token-based authentication

## 👥 Authors

- **Anurag Negi** - _Initial work_ - [Anurag-Negi28](https://github.com/Anurag-Negi28)

## 🙏 Acknowledgments

- FastAPI framework for high-performance API development
- Apache JMeter for comprehensive load testing
- SonarQube for code quality analysis
- PostgreSQL for reliable data persistence
- Docker for containerization simplicity

---

🌟 **Star this repo** if you find it helpful!
