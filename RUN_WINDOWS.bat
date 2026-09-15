@echo off
if not exist .env copy .env.example .env
if not exist data mkdir data
python -m uvicorn app.main:app --host 0.0.0.0 --port 8080
