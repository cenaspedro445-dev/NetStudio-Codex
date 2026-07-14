#!/bin/bash
# Extrair e reorganizar NetStudio-Codex

set -e

echo "🔍 Detectando arquivos..."
unzip -q NetStudio-Codex-main.zip -d /tmp/extract || true

if [ -d "/tmp/extract/NetStudio-Codex-main" ]; then
    echo "📦 Movendo conteúdo..."
    cd /tmp/extract/NetStudio-Codex-main
    
    # Identificar estrutura
    if [ -d "backend" ]; then
        echo "✅ Backend encontrado"
        cp -r backend/* /workspace/backend/ 2>/dev/null || cp -r backend /workspace/
    fi
    
    if [ -d "frontend" ]; then
        echo "✅ Frontend encontrado"
        cp -r frontend/* /workspace/frontend/ 2>/dev/null || cp -r frontend /workspace/
    fi
    
    if [ -d "src" ]; then
        echo "✅ Source encontrado"
        [ ! -d "/workspace/backend" ] && mkdir -p /workspace/backend && cp -r src /workspace/backend/
    fi
    
    echo "✅ Extração concluída"
else
    echo "❌ Arquivo inválido"
    exit 1
fi
