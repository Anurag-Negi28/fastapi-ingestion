from fastapi import FastAPI, Depends
from sqlalchemy.orm import Session
from pydantic import BaseModel

import models
import crud
from database import SessionLocal, engine

models.Base.metadata.create_all(bind=engine)

app = FastAPI()

class UserDataRequest(BaseModel):
    name: str
    age: int
    city: str

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@app.get("/")
def root():
    return {"message": "Ingestion API is up"}

@app.get("/health")
def health():
    return {"status": "healthy", "timestamp": "2025-07-22"}

@app.post("/ingest")
def ingest(data: UserDataRequest, db: Session = Depends(get_db)):
    try:
        # Try both Pydantic v1 and v2 methods
        data_dict = data.model_dump() if hasattr(data, 'model_dump') else data.dict()
        saved = crud.save_user_data(db, data_dict)
        return {
            "status": "success",
            "data": {
                "id": saved.id,
                "name": saved.name,
                "age": saved.age,
                "city": saved.city
            }
        }
    except Exception as e:
        return {"status": "error", "message": str(e)}