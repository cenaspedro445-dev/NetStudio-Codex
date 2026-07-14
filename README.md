# NetStudio Codex

🤖 **AI-powered code generation with Ollama and Qwen**

NetStudio Codex é uma aplicação web que permite gerar código usando modelos de IA (Qwen) rodando localmente via Ollama. Construído com FastAPI + React e pronto para Docker.

## ⚡ Quick Start (2 minutos)

### Pré-requisitos

- Python 3.10+
- Node.js 18+
- [Ollama](https://ollama.ai) (gratuito)

### Linux/macOS

```bash
# 1. Clone o repositório
git clone https://github.com/cenaspedro445-dev/NetStudio-Codex.git
cd NetStudio-Codex

# 2. Execute o setup
chmod +x scripts/install.sh
./scripts/install.sh

# 3. Puxe o modelo Qwen
ollama pull qwen2.5-coder

# 4. Inicie a aplicação
./scripts/start.sh
```

Abra http://localhost:5173 no seu navegador.

### Windows

```cmd
REM 1. Clone
git clone https://github.com/cenaspedro445-dev/NetStudio-Codex.git
cd NetStudio-Codex

REM 2. Setup
scripts\install.bat

REM 3. Puxe modelo
ollama pull qwen2.5-coder

REM 4. Inicie
scripts\start.bat
```

### Docker

```bash
# 1. Ollama deve estar rodando
ollama serve

# 2. Em outro terminal
ollama pull qwen2.5-coder

# 3. Docker Compose
docker-compose up
```

Abra http://localhost:5173

## 🎯 Uso

1. **Escreva um prompt** - Digite o que deseja gerar
2. **Selecione modelo** - Escolha entre modelos disponíveis
3. **Gere código** - Clique em "Generate"
4. **Veja streaming** - Código aparece em tempo real

## 📡 API

| Endpoint | Método | Descrição |
|----------|--------|-------------|
| `/` | GET | Info da API |
| `/health` | GET | Status (Backend + Ollama + Modelos) |
| `/models` | GET | Lista modelos disponíveis |
| `/generate` | POST | Gera código (streaming) |

**Request POST `/generate`:**

```json
{
  "prompt": "Write a function to reverse a string in Python",
  "model": "qwen2.5-coder"
}
```

## 🏗️ Arquitetura

### Backend (FastAPI)

- Health check com status de Ollama
- Auto-detecção de modelos (qwen3 > qwen2.5-coder > fallback)
- Streaming de respostas
- SQLite database
- CORS habilitado

### Frontend (React + Vite)

- Interface moderna e responsiva
- Seleção de modelos
- Streaming em tempo real
- Status de conexão
- Tratamento de erros

## ⚙️ Configuração

Edite `.env` para customizar:

```env
# Backend
BACKEND_HOST=0.0.0.0
BACKEND_PORT=8000

# Frontend
VITE_API_URL=http://localhost:8000

# Ollama
OLLAMA_HOST=http://localhost:11434
OLLAMA_MODEL=qwen2.5-coder
OLLAMA_TIMEOUT=300

# Database
DATABASE_URL=sqlite:///./data/app.db
```

## 🔍 Troubleshooting

### Ollama não conecta

```bash
# Verifique status
curl http://localhost:11434/api/tags

# Inicie Ollama
ollama serve
```

### Porta em uso

```bash
# Linux/macOS
lsof -ti:8000 | xargs kill -9
lsof -ti:5173 | xargs kill -9
```

### Reinstale dependências

```bash
rm -rf venv frontend/node_modules
./scripts/install.sh
```

## 🛠️ Desenvolvimento

### Backend

```bash
cd backend
pip install -r requirements.txt
python -m uvicorn main:app --reload
```

Docs interativas: http://localhost:8000/docs

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## 📚 Projeto

```
.
├── backend/
│   ├── main.py
│   ├── config.py
│   ├── database.py
│   ├── schemas.py
│   ├── services/
│   │   └── ollama.py
│   └── requirements.txt
├── frontend/
│   ├── src/
│   │   ├── App.jsx
│   │   ├── components/
│   │   └── styles/
│   ├── package.json
│   └── vite.config.js
├── scripts/
│   ├── install.sh
│   ├── install.bat
│   ├── start.sh
│   └── start.bat
├── docker-compose.yml
├── Dockerfile.backend
├── Dockerfile.frontend
└── .env.example
```

## 📦 Requisitos

**Backend:**
- fastapi 0.104.1
- uvicorn 0.24.0
- httpx 0.25.1
- sqlalchemy 2.0.23
- pydantic 2.5.0

**Frontend:**
- react 18.2.0
- vite 5.0.0
- axios 1.6.0

**Sistema:**
- Python 3.10+
- Node.js 18+
- Docker (opcional)
- Ollama (gratuito)

## 📄 Licença

MIT

## 🤝 Contribuições

Contribuições são bem-vindas! Abra uma issue ou PR.

## 📞 Suporte

- GitHub Issues: [Reporte bugs](https://github.com/cenaspedro445-dev/NetStudio-Codex/issues)
- Documentação: Veja a seção de Troubleshooting acima
- Ollama: https://ollama.ai

---

**v0.1.0** - Entrega Inicial MVP
