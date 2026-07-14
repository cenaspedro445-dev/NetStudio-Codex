# Release v0.1.0 - MVP

## 🎉 Entrega Inicial

NetStudio Codex MVP é um projeto de código aberto que oferece geração de código com IA usando Ollama e modelos Qwen.

## ✨ Recursos

- ✅ Interface web React + Vite
- ✅ Backend FastAPI
- ✅ Integração Ollama
- ✅ Suporte Qwen (qwen3, qwen2.5-coder)
- ✅ Streaming em tempo real
- ✅ SQLite database
- ✅ Docker + Docker Compose
- ✅ Scripts de instalação/inicialização
- ✅ Multiplataforma (Linux, macOS, Windows)

## 🚀 Quick Start

### Linux/macOS

```bash
git clone https://github.com/cenaspedro445-dev/NetStudio-Codex.git
cd NetStudio-Codex
chmod +x scripts/install.sh
./scripts/install.sh
ollama pull qwen2.5-coder
./scripts/start.sh
```

### Windows

```cmd
git clone https://github.com/cenaspedro445-dev/NetStudio-Codex.git
cd NetStudio-Codex
scripts\install.bat
ollama pull qwen2.5-coder
scripts\start.bat
```

### Docker

```bash
ollama pull qwen2.5-coder
docker-compose up
```

## 📋 Pré-requisitos

- Python 3.10+
- Node.js 18+
- npm 8+
- [Ollama](https://ollama.ai) (gratuito)

## 🏗️ Arquitetura

```
NetStudio-Codex/
├── backend/                 # FastAPI (Python)
│   ├── main.py             # Aplicação principal
│   ├── config.py           # Configurações
│   ├── database.py         # SQLite setup
│   ├── schemas.py          # Modelos Pydantic
│   ├── services/
│   │   └── ollama.py       # Integração Ollama
│   └── requirements.txt     # Dependências Python
├── frontend/               # React + Vite (JavaScript)
│   ├── src/
│   │   ├── App.jsx
│   │   ├── components/
│   │   │   └── CodeGenerator.jsx
│   │   └── styles/
│   ├── package.json
│   └── vite.config.js
├── scripts/                # Setup scripts
│   ├── install.sh
│   ├── install.bat
│   ├── start.sh
│   └── start.bat
├── docker-compose.yml      # Orquestração Docker
├── Dockerfile.backend
├── Dockerfile.frontend
├── .env.example
└── README.md
```

## 📡 API Endpoints

- `GET /` - Info da API
- `GET /health` - Status (Backend + Ollama)
- `GET /models` - Lista modelos disponíveis
- `POST /generate` - Gera código com streaming

## 🔌 Portas

- Backend: http://localhost:8000
- Frontend: http://localhost:5173
- Ollama: http://localhost:11434

## 📝 Notas de Versão

### v0.1.0 (Inicial)

**Adicionado:**
- Backend FastAPI com health check
- Frontend React com interface de geração
- Integração Ollama com auto-detecção de modelos
- Streaming de resposta em tempo real
- Database SQLite
- Docker + Docker Compose
- Scripts de setup multiplataforma
- Documentação completa

**Não incluído nesta versão:**
- Autenticação/Autorização
- Histórico de gerações
- Cache de modelos
- API de análise
- Dashboard administrativo

## 🐛 Troubleshooting

### Ollama não conecta

```bash
# Verifique se Ollama está rodando
curl http://localhost:11434/api/tags

# Inicie Ollama
ollama serve

# Em outro terminal, puxe o modelo
ollama pull qwen2.5-coder
```

### Porta em uso

```bash
# Linux/macOS
lsof -ti:8000 | xargs kill -9  # Backend
lsof -ti:5173 | xargs kill -9  # Frontend

# Windows
netstat -ano | findstr :8000
taskkill /PID <PID> /F
```

### Dependências quebradas

```bash
rm -rf venv frontend/node_modules
./scripts/install.sh
```

## 📄 Licença

MIT

## 👨‍💻 Desenvolvimento

### Backend

```bash
cd backend
pip install -r requirements.txt
python -m uvicorn main:app --reload
```

Docs: http://localhost:8000/docs

### Frontend

```bash
cd frontend
npm install
npm run dev
```

## 🔄 Próximas versões

- [ ] Autenticação JWT
- [ ] Histórico de gerações
- [ ] Suporte a múltiplos modelos em parallel
- [ ] Sistema de fila de tarefas
- [ ] Análise de código
- [ ] Integração com GitHub
- [ ] Marketplace de plugins

## 📞 Suporte

Abra uma issue no GitHub para reportar bugs ou sugerir features.
