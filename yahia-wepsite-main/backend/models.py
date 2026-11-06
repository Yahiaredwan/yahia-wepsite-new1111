from sqlalchemy import Column, Integer, String, Boolean, Text
from backend.database import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    email = Column(String, unique=True, index=True)
    hashed_password = Column(String)
    is_admin = Column(Boolean, default=False)

class SiteContent(Base):
    __tablename__ = "site_content"
    id = Column(String, primary_key=True, index=True) # e.g. 'hero_title'
    content = Column(Text)

class PaymentMethod(Base):
    __tablename__ = "payment_methods"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    number = Column(String)
    order_index = Column(Integer, default=0)

class Section(Base):
    __tablename__ = "sections"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    schedule = Column(String, nullable=True)
    status = Column(String, default='active')
    order_index = Column(Integer, default=0)

class Feature(Base):
    __tablename__ = "features"
    id = Column(Integer, primary_key=True, index=True)
    icon = Column(String)
    title = Column(String)
    description = Column(Text)
    order_index = Column(Integer, default=0)

class Trainer(Base):
    __tablename__ = "trainers"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String)
    description = Column(Text)
    image_path = Column(String, nullable=True)
    order_index = Column(Integer, default=0)

class Curriculum(Base):
    __tablename__ = "curriculum"
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String)
    content = Column(Text)
    order_index = Column(Integer, default=0)

class FAQ(Base):
    __tablename__ = "faqs"
    id = Column(Integer, primary_key=True, index=True)
    question = Column(String)
    answer = Column(Text)
    order_index = Column(Integer, default=0)
