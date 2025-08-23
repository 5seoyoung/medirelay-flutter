from pydantic import BaseModel, EmailStr
from typing import Optional
from app.schemas.user import UserResponse

class Token(BaseModel):
    """토큰 응답 모델"""
    access_token: str
    refresh_token: str
    token_type: str
    expires_in: int
    user: UserResponse

class TokenData(BaseModel):
    """토큰 데이터 모델"""
    email: Optional[str] = None
    user_id: Optional[int] = None

class UserLogin(BaseModel):
    """사용자 로그인 요청"""
    email: EmailStr
    password: str

class UserRegister(BaseModel):
    """사용자 회원가입 요청"""
    email: EmailStr
    password: str
    name: str
    role: str = "nurse"
    department: Optional[str] = None
    ward_id: Optional[int] = None
    phone: Optional[str] = None
    employee_id: Optional[str] = None
    position: Optional[str] = None
    hospital_id: Optional[int] = None

class PasswordChange(BaseModel):
    """비밀번호 변경 요청"""
    current_password: str
    new_password: str

class PasswordReset(BaseModel):
    """비밀번호 재설정 요청"""
    email: EmailStr

class RefreshTokenRequest(BaseModel):
    """토큰 갱신 요청"""
    refresh_token: str