from loguru import logger
import sys
import os
from app.core.config import settings

def setup_logging():
    """로깅 설정 초기화"""
    # 기존 핸들러 제거
    logger.remove()
    
    # 로그 디렉토리 생성
    log_dir = os.path.dirname(settings.LOG_FILE)
    if log_dir and not os.path.exists(log_dir):
        os.makedirs(log_dir, exist_ok=True)
    
    # 콘솔 로깅 (개발 환경)
    if settings.DEBUG:
        logger.add(
            sys.stdout,
            level=settings.LOG_LEVEL,
            format="<green>{time:YYYY-MM-DD HH:mm:ss}</green> | <level>{level: <8}</level> | <cyan>{name}</cyan>:<cyan>{function}</cyan>:<cyan>{line}</cyan> - <level>{message}</level>",
            colorize=True
        )
    
    # 파일 로깅
    logger.add(
        settings.LOG_FILE,
        rotation=settings.LOG_ROTATION,
        retention=settings.LOG_RETENTION,
        level=settings.LOG_LEVEL,
        format="{time:YYYY-MM-DD HH:mm:ss} | {level: <8} | {name}:{function}:{line} - {message}",
        compression="zip"
    )
    
    logger.info("🔧 Logging system initialized")
    logger.info(f"📝 Log level: {settings.LOG_LEVEL}")
    logger.info(f"📁 Log file: {settings.LOG_FILE}")
    
    return logger