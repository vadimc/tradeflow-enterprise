#!/usr/bin/env sh
set -eu
[ -f .env ] || cp .env.example .env
mkdir -p data
python -m uvicorn app.main:app --host 0.0.0.0 --port 8080
