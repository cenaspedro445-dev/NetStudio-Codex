# NetStudio Codex

🤖 AI-powered code generation with Ollama and Qwen

## Quick Start

### Prerequisites

- Python 3.10+
- Node.js 18+
- npm 8+
- [Ollama](https://ollama.ai)

### Installation (Linux/macOS)

```bash
# 1. Clone repository
git clone https://github.com/yourusername/NetStudio-Codex.git
cd NetStudio-Codex

# 2. Run install script
chmod +x scripts/install.sh
./scripts/install.sh

# 3. Pull Qwen model in Ollama
ollama pull qwen2.5-coder

# 4. Start services
./scripts/start.sh
```

### Installation (Windows)

```cmd
REM 1. Clone repository
git clone https://github.com/yourusername/NetStudio-Codex.git
cd NetStudio-Codex

REM 2. Run install script
scripts\install.bat

REM 3. Pull Qwen model in Ollama
ollama pull qwen2.5-coder

REM 4. Start services
scripts\start.bat
```

### Installation (Docker)

```bash
# 1. Make sure Ollama is running locally
ollama serve

# 2. In another terminal, pull model
ollama pull qwen2.5-coder

# 3. Start with Docker Compose
docker-compose up
```

## Usage

1. Open http://localhost:5173 in your browser
2. Enter your code prompt
3. Click "Generate"
4. Wait for AI response (streaming)

## API Endpoints

- `GET /` - API info
- `GET /health` - Health check
- `GET /models` - List available models
- `POST /generate` - Generate code (streaming)

## Configuration

Edit `.env` to configure:

```env
# Backend
BACKEND_HOST=0.0.0.0
BACKEND_PORT=8000

# Frontend
VITE_API_URL=http://localhost:8000

# Ollama
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=qwen2.5-coder

# Database
DATABASE_URL=sqlite:///./data/app.db
```

## Development

### Backend

```bash
cd backend
pip install -r requirements.txt
python -m uvicorn main:app --reload
```

API docs: http://localhost:8000/docs

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## Troubleshooting

### Ollama not connecting

```bash
# Make sure Ollama is running
ollama serve

# In another terminal
ollama pull qwen2.5-coder
```

### Port already in use

```bash
# Kill process on port 8000 (backend)
lsof -ti:8000 | xargs kill -9

# Kill process on port 5173 (frontend)
lsof -ti:5173 | xargs kill -9
```

### Dependencies issues

```bash
# Reinstall everything
rm -rf venv
rm -rf frontend/node_modules
./scripts/install.sh
```

## Architecture

- **Backend**: FastAPI + Python
- **Frontend**: React + Vite + JavaScript
- **AI**: Ollama + Qwen models
- **Database**: SQLite
- **Deployment**: Docker + Docker Compose

## Project Structure

```
.
├── backend/              # FastAPI application
│   ├── main.py          # Application entry point
│   ├── config.py        # Configuration
│   ├── database.py      # Database setup
│   ├── schemas.py       # Pydantic models
│   └── requirements.txt  # Python dependencies
├── frontend/             # React application
│   ├── src/
│   │   ├── App.jsx
│   │   ├── components/
│   │   └── styles/
│   ├── package.json
│   └── vite.config.js
├── scripts/              # Setup scripts
│   ├── install.sh
│   ├── install.bat
│   ├── start.sh
│   └── start.bat
├── docker-compose.yml    # Docker orchestration
├── Dockerfile.backend
├── Dockerfile.frontend
├── .env.example          # Environment variables
└── README.md
```

## License

MIT
