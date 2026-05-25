#!/bin/bash

ollama serve &

echo "⏳ A aguardar que o servidor Ollama inicialize..."
while ! ollama list > /dev/null 2>&1; do
  sleep 1
done

echo "📥 A descarregar o modelo gemma2:2b (isto pode demorar uns minutos na primeira execução)..."
ollama pull gemma2:2b

echo "✅ Modelo descarregado com sucesso e pronto a usar!"

wait