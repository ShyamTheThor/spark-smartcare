#!/bin/bash
# SmartCare SIH26133 - macOS / Linux Launcher
echo "====================================================================="
echo "  SmartCare (SIH26133) - Smart Hospital Queue Management System"
echo "  SIH 2026 | Full-Stack Local Dev Launcher"
echo "====================================================================="

# Kill any existing processes on our ports
echo "[PRE-CHECK] Freeing ports 8000, 5173, 5174, 5175..."
for port in 8000 5173 5174 5175; do
  pids=$(lsof -ti :$port 2>/dev/null)
  if [ -n "$pids" ]; then
    echo "  Killing processes on port $port: $pids"
    kill -9 $pids 2>/dev/null
  fi
done

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "[1/4] Starting FastAPI Backend on port 8000..."
(cd "$DIR/backend" && python -m uvicorn main:app --host 0.0.0.0 --port 8000 --reload) &

sleep 2

echo "[2/4] Starting Patient Portal on port 5173..."
(cd "$DIR/patient-portal" && npm run dev -- --port 5173 --host) &

sleep 1

echo "[3/4] Starting Admin / Doctor Portal on port 5174..."
(cd "$DIR/admin-portal" && npm run dev -- --port 5174 --host) &

sleep 1

echo "[4/4] Starting Govt Observer Portal on port 5175..."
(cd "$DIR/govt-portal" && npm run dev -- --port 5175 --host) &

echo ""
echo "====================================================================="
echo " All 4 services launched! Open these in your browser:"
echo ""
echo "   Backend API + Swagger : http://localhost:8000/docs"
echo "   Patient Portal        : http://localhost:5173"
echo "   Admin / Doctor Panel  : http://localhost:5174"
echo "   Govt Observer Portal  : http://localhost:5175"
echo "====================================================================="

wait
