from sqlalchemy.orm import Session
from models import UserData

def save_user_data(db: Session, data: dict):
    record = UserData(name=data["name"], age=data["age"], city=data["city"])
    db.add(record)
    db.commit()
    db.refresh(record)
    return record
