#!/bin/bash

echo "🛑 Stopping NetStudio Codex services..."

# Kill processes on ports
kill $(lsof -t -i :8000) 2>/dev/null || true
kill $(lsof -t -i :5173) 2>/dev/null || true

echo "✅ Services stopped"
