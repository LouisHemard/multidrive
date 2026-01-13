from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from sqlalchemy import create_engine, Column, Integer, String, ForeignKey
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker, Session, relationship
from pydantic import BaseModel
from typing import List
from contextlib import asynccontextmanager
import os

DATABASE_URL = os.getenv("DATABASE_URL", "postgresql://postgres:postgres@localhost:5432/vehicledb")

engine = create_engine(DATABASE_URL, pool_pre_ping=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)
Base = declarative_base()

# Database Models
class Garage(Base):
    __tablename__ = "garages"
    id = Column(Integer, primary_key=True, index=True)
    name = Column(String, index=True)
    address = Column(String)
    vehicles = relationship("Vehicle", back_populates="garage")

class Vehicle(Base):
    __tablename__ = "vehicles"
    id = Column(Integer, primary_key=True, index=True)
    brand = Column(String)
    model = Column(String)
    year = Column(Integer)
    license_plate = Column(String, unique=True, index=True)
    garage_id = Column(Integer, ForeignKey("garages.id"))
    garage = relationship("Garage", back_populates="vehicles")

def init_db():
    Base.metadata.create_all(bind=engine)
    
@asynccontextmanager
async def lifespan(app: FastAPI):
    # Startup
    init_db()
    # Seed initial data
    db = SessionLocal()
    try:
        if db.query(Garage).count() == 0:
            garages = [
                Garage(name="Garage Central", address="123 Rue Principale"),
                Garage(name="Garage Auto", address="456 Avenue Auto"),
            ]
            db.add_all(garages)
            db.commit()
            print("✅ Initial data seeded successfully")
    except Exception as e:
        print(f"⚠️ Error seeding data: {e}")
    finally:
        db.close()
    
    yield
    
    # Shutdown (nothing to do for now)

app = FastAPI(title="MultiDrive API", lifespan=lifespan)

# CORS
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Pydantic Models
class GarageCreate(BaseModel):
    name: str
    address: str

class GarageResponse(BaseModel):
    id: int
    name: str
    address: str

    class Config:
        from_attributes = True

class VehicleCreate(BaseModel):
    brand: str
    model: str
    year: int
    license_plate: str
    garage_id: int

class VehicleResponse(BaseModel):
    id: int
    brand: str
    model: str
    year: int
    license_plate: str
    garage_id: int

    class Config:
        from_attributes = True

# Database Dependency
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Routes
@app.get("/")
def read_root():
    return {"message": "MultiDrive API"}

@app.get("/garages", response_model=List[GarageResponse])
def get_garages(db: Session = Depends(get_db)):
    return db.query(Garage).all()

@app.post("/garages", response_model=GarageResponse)
def create_garage(garage: GarageCreate, db: Session = Depends(get_db)):
    db_garage = Garage(**garage.dict())
    db.add(db_garage)
    db.commit()
    db.refresh(db_garage)
    return db_garage

@app.get("/garages/{garage_id}", response_model=GarageResponse)
def get_garage(garage_id: int, db: Session = Depends(get_db)):
    garage = db.query(Garage).filter(Garage.id == garage_id).first()
    if not garage:
        raise HTTPException(status_code=404, detail="Garage not found")
    return garage

@app.get("/vehicles", response_model=List[VehicleResponse])
def get_vehicles(db: Session = Depends(get_db)):
    return db.query(Vehicle).all()

@app.post("/vehicles", response_model=VehicleResponse)
def create_vehicle(vehicle: VehicleCreate, db: Session = Depends(get_db)):
    # Check if garage exists
    garage = db.query(Garage).filter(Garage.id == vehicle.garage_id).first()
    if not garage:
        raise HTTPException(status_code=404, detail="Garage not found")
    
    db_vehicle = Vehicle(**vehicle.dict())
    db.add(db_vehicle)
    db.commit()
    db.refresh(db_vehicle)
    return db_vehicle

@app.delete("/vehicles/{vehicle_id}")
def delete_vehicle(vehicle_id: int, db: Session = Depends(get_db)):
    vehicle = db.query(Vehicle).filter(Vehicle.id == vehicle_id).first()
    if not vehicle:
        raise HTTPException(status_code=404, detail="Vehicle not found")
    db.delete(vehicle)
    db.commit()
    return {"message": "Vehicle deleted"}

@app.get("/garages/{garage_id}/vehicles", response_model=List[VehicleResponse])
def get_garage_vehicles(garage_id: int, db: Session = Depends(get_db)):
    garage = db.query(Garage).filter(Garage.id == garage_id).first()
    if not garage:
        raise HTTPException(status_code=404, detail="Garage not found")
    return garage.vehicles

