from pydantic import BaseModel, EmailStr
from typing import Optional
from datetime import datetime

class UserBase(BaseModel):
    """사용자 기본 모델"""
    email: EmailStr
    name: str
    phone: Optional[str] = None
    department: Optional[str] = None
    position: Optional[str] = None

class UserCreate(UserBase):
    """사용자 생성 모델"""
    password: str
    role: str = "nurse"
    ward_id: Optional[int] = None
    employee_id: Optional[str] = None
    hospital_id: Optional[int] = None

class UserUpdate(BaseModel):
    """사용자 수정 모델"""
    name: Optional[str] = None
    phone: Optional[str] = None
    department: Optional[str] = None
    position: Optional[str] = None
    ward_id: Optional[int] = None

class UserResponse(UserBase):
    """사용자 응답 모델"""
    id: int
    role: str
    employee_id: Optional[str] = None
    ward_id: Optional[int] = None
    hospital_id: Optional[int] = None
    is_active: bool
    is_verified: bool
    last_login: Optional[datetime] = None
    created_at: Optional[datetime] = None
    
    class Config:
        from_attributes = True

class UserSummary(BaseModel):
    """사용자 요약 모델 (목록용)"""
    id: int
    name: str
    email: EmailStr
    role: str
    department: Optional[str] = None
    position: Optional[str] = None
    is_active: bool
    
    class Config:
        from_attributes = True