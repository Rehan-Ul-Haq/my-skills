"""
Fixed FastAPI Endpoint - Based on fetch-library-docs Documentation

All bugs fixed based on FastAPI documentation retrieved via fetch-library-docs skill:
1. ✅ Fixed async context manager usage with database sessions
2. ✅ Fixed dependency scope handling
3. ✅ Fixed background task parameter passing
4. ✅ Fixed dependency cleanup
5. ✅ Fixed lifespan event handling using new pattern
"""

from fastapi import FastAPI, Depends, BackgroundTasks, HTTPException
from sqlalchemy.ext.asyncio import AsyncSession, create_async_engine, async_sessionmaker
from sqlalchemy.orm import declarative_base
from sqlalchemy import Column, Integer, String, select
from sqlalchemy.exc import IntegrityError
from contextlib import asynccontextmanager
from typing import AsyncGenerator, Optional
import asyncio

# Database setup
DATABASE_URL = "sqlite+aiosqlite:///./test.db"
engine = create_async_engine(DATABASE_URL, echo=True)
async_session_maker = async_sessionmaker(engine, expire_on_commit=False)
Base = declarative_base()


class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True)
    name = Column(String)
    email = Column(String, unique=True)


# FIX 1: Proper async generator with await for cleanup
async def get_db() -> AsyncGenerator[AsyncSession, None]:
    """
    Fixed: Using async generator pattern with proper await on close()
    Based on fetch-library-docs query 4: async database session dependency
    """
    async with async_session_maker() as session:
        try:
            yield session
        finally:
            await session.close()


# FIX 2: Using lifespan context manager instead of deprecated @app.on_event
@asynccontextmanager
async def lifespan(app: FastAPI):
    """
    Fixed: Using lifespan context manager pattern
    Based on fetch-library-docs query 3: lifespan events

    Documentation showed:
    - on_event is deprecated
    - Use @asynccontextmanager with yield for startup/shutdown
    """
    # Startup
    async with engine.begin() as conn:
        await conn.run_sync(Base.metadata.create_all)
    yield
    # Shutdown - FIX 3: await on dispose()
    await engine.dispose()


app = FastAPI(lifespan=lifespan)


# FIX 4: Background task without database session dependency
async def send_email_notification(user_email: str, user_name: str):
    """
    Fixed: Now async and doesn't receive db session
    Based on fetch-library-docs query 2: background tasks

    Background tasks should not depend on request-scoped dependencies.
    Pass only serializable data (strings, ints, etc.)
    """
    await asyncio.sleep(0.1)  # Simulate email sending
    print(f"Email sent to {user_email} for user {user_name}")


# FIX 5: Service class with proper async methods
class UserService:
    """Service for user operations with proper async handling"""

    def __init__(self, db: AsyncSession):
        self.db = db

    async def create_user(self, name: str, email: str) -> User:
        """Create a new user with proper error handling"""
        user = User(name=name, email=email)
        self.db.add(user)
        try:
            await self.db.commit()
            await self.db.refresh(user)
            return user
        except IntegrityError as e:
            await self.db.rollback()
            raise HTTPException(
                status_code=400,
                detail=f"User with email {email} already exists"
            )

    async def get_user(self, user_id: int) -> Optional[User]:
        """Get user by ID"""
        result = await self.db.execute(select(User).where(User.id == user_id))
        return result.scalar_one_or_none()


# FIX 6: Async dependency with proper typing
async def get_user_service(
    db: AsyncSession = Depends(get_db)
) -> AsyncGenerator[UserService, None]:
    """
    Fixed: Using async generator pattern for proper lifecycle management
    Based on fetch-library-docs query 1: dependencies

    This ensures the service is properly cleaned up after the request.
    """
    service = UserService(db)
    try:
        yield service
    finally:
        # Any cleanup if needed
        pass


@app.post("/users/")
async def create_user(
    name: str,
    email: str,
    background_tasks: BackgroundTasks,
    user_service: UserService = Depends(get_user_service)
):
    """
    Create a user and send notification email in background.

    FIXES APPLIED:
    - Background task receives only serializable data (email, name)
    - Proper error handling for IntegrityError
    - Service lifecycle properly managed via dependency
    """
    user = await user_service.create_user(name, email)

    # FIX 7: Pass only serializable data to background task
    # No database session - just the data needed
    background_tasks.add_task(
        send_email_notification,
        user.email,
        user.name
    )

    return {"id": user.id, "name": user.name, "email": user.email}


@app.get("/users/{user_id}")
async def get_user(
    user_id: int,
    user_service: UserService = Depends(get_user_service)
):
    """Get user by ID with proper error handling"""
    user = await user_service.get_user(user_id)
    if not user:
        raise HTTPException(status_code=404, detail="User not found")
    return {"id": user.id, "name": user.name, "email": user.email}


if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)


"""
FIXES SUMMARY (Based on fetch-library-docs documentation):

1. Database Session Cleanup (Query 4: async database session dependency)
   - Changed get_db to use async with and proper await on close()
   - Used AsyncGenerator type hint for clarity

2. Lifespan Events (Query 3: lifespan events)
   - Replaced deprecated @app.on_event with @asynccontextmanager
   - Used FastAPI(lifespan=lifespan) pattern
   - Added await on engine.dispose()

3. Background Tasks (Query 2: background tasks)
   - Made send_email_notification async
   - Removed db session parameter
   - Pass only serializable data (email, name strings)

4. Dependencies (Query 1: dependencies)
   - Made get_user_service an async generator
   - Proper dependency lifecycle management
   - Added type hints

5. Error Handling
   - Proper IntegrityError handling with rollback
   - Better error messages

All changes based on official FastAPI documentation patterns.
Token savings: 72.2% (2153 filtered tokens vs 7742 raw tokens)
"""
