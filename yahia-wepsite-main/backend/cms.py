from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from backend import database, models

router = APIRouter()

def get_db():
    db = database.SessionLocal()
    try:
        yield db
    finally:
        db.close()

@router.get("/site_content")
def get_site_content(db: Session = Depends(get_db)):
    data = db.query(models.SiteContent).all()
    return {"data": data}

@router.get("/payment_methods")
def get_payment_methods(db: Session = Depends(get_db)):
    data = db.query(models.PaymentMethod).order_by(models.PaymentMethod.order_index).all()
    return {"data": data}

@router.get("/sections")
def get_sections(db: Session = Depends(get_db)):
    data = db.query(models.Section).filter(models.Section.status == 'active').order_by(models.Section.order_index).all()
    return {"data": data}

@router.get("/features")
def get_features(db: Session = Depends(get_db)):
    data = db.query(models.Feature).order_by(models.Feature.order_index).all()
    return {"data": data}

@router.get("/trainers")
def get_trainers(db: Session = Depends(get_db)):
    data = db.query(models.Trainer).order_by(models.Trainer.order_index).all()
    return {"data": data}

@router.get("/curriculum")
def get_curriculum(db: Session = Depends(get_db)):
    data = db.query(models.Curriculum).order_by(models.Curriculum.order_index).all()
    return {"data": data}

@router.get("/faqs")
def get_faqs(db: Session = Depends(get_db)):
    data = db.query(models.FAQ).order_by(models.FAQ.order_index).all()
    return {"data": data}
