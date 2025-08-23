from fastapi import HTTPException, Request, status
from fastapi.responses import JSONResponse
from fastapi.exceptions import RequestValidationError
from loguru import logger
from typing import Any

class CustomHTTPException(HTTPException):
    """커스텀 HTTP 예외"""
    def __init__(self, status_code: int, detail: Any = None, headers: dict = None):
        super().__init__(status_code=status_code, detail=detail, headers=headers)

class DatabaseException(Exception):
    """데이터베이스 관련 예외"""
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)

class AuthenticationException(Exception):
    """인증 관련 예외"""
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)

class PermissionException(Exception):
    """권한 관련 예외"""
    def __init__(self, message: str):
        self.message = message
        super().__init__(self.message)

class ValidationException(Exception):
    """검증 관련 예외"""
    def __init__(self, message: str, field: str = None):
        self.message = message
        self.field = field
        super().__init__(self.message)

# 예외 처리기들
async def http_exception_handler(request: Request, exc: CustomHTTPException):
    """HTTP 예외 처리기"""
    logger.error(f"HTTP Exception: {exc.status_code} - {exc.detail}")
    return JSONResponse(
        status_code=exc.status_code,
        content={
            "error": "HTTP Error",
            "message": exc.detail,
            "status_code": exc.status_code
        }
    )

async def validation_exception_handler(request: Request, exc: RequestValidationError):
    """검증 예외 처리기"""
    logger.error(f"Validation Error: {exc.errors()}")
    return JSONResponse(
        status_code=status.HTTP_422_UNPROCESSABLE_ENTITY,
        content={
            "error": "Validation Error",
            "message": "입력 데이터가 올바르지 않습니다.",
            "details": exc.errors()
        }
    )

async def database_exception_handler(request: Request, exc: DatabaseException):
    """데이터베이스 예외 처리기"""
    logger.error(f"Database Error: {exc.message}")
    return JSONResponse(
        status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
        content={
            "error": "Database Error",
            "message": "데이터베이스 오류가 발생했습니다."
        }
    )

async def authentication_exception_handler(request: Request, exc: AuthenticationException):
    """인증 예외 처리기"""
    logger.warning(f"Authentication Error: {exc.message}")
    return JSONResponse(
        status_code=status.HTTP_401_UNAUTHORIZED,
        content={
            "error": "Authentication Error",
            "message": exc.message
        }
    )

async def permission_exception_handler(request: Request, exc: PermissionException):
    """권한 예외 처리기"""
    logger.warning(f"Permission Error: {exc.message}")
    return JSONResponse(
        status_code=status.HTTP_403_FORBIDDEN,
        content={
            "error": "Permission Error",
            "message": exc.message
        }
    )