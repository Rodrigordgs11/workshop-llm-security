# Workshop: LLM Security - Portal de RH Vulnerável

Workshop prático sobre **Prompt Injection** e segurança em aplicações LLM.
A app simula um assistente de Recursos Humanos com uma "regra de segurança absoluta"
que esconde dados confidenciais (salários, avaliações, uma flag) o objetivo é
contornar essa regra via prompt injection.

---

## 📦 Arquitetura

| Serviço | Descrição | Porta |
|---|---|---|
| `ollama` | Servidor local de LLM (modelo `gemma2:2b`) | `11434` |
| `vulnerable-app` | App Streamlit que conversa com o LLM | `8501` |

A app fala com o Ollama por dentro da rede Docker em `http://ollama:11434/api/chat`.

---

## ✅ Pré-requisitos

- [Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/macOS/Linux)
- ~4 GB livres em disco (o modelo `gemma2:2b` ocupa ~1.6 GB)
- Ligação à internet na primeira execução (para puxar a imagem e o modelo)

---

## 🚀 Setup

### 1. Clonar / abrir o projeto

```powershell
cd "workshop-llm-security"
```

### 2. ⚠️ Garantir line endings LF no entrypoint (apenas Windows)

O ficheiro `ollama-entrypoint.sh` corre dentro de um container Linux e **não pode
ter terminações CRLF**, caso contrário verás `/bin/bash^M: bad interpreter`.

No VS Code: abre `ollama-entrypoint.sh` → canto inferior direito → muda `CRLF` para `LF` → grava.

Em alternativa, via Git Bash / WSL:

```bash
sed -i 's/\r$//' ollama-entrypoint.sh
```

### 3. Arrancar os serviços

```powershell
docker compose up --build
```

Na primeira execução vais ver, pela ordem:

1. `⏳ A aguardar que o servidor Ollama inicialize...`
2. `📥 A descarregar o modelo gemma2:2b (isto pode demorar uns minutos na primeira execução)...`
3. `✅ Modelo descarregado com sucesso e pronto a usar!`

> O download do modelo só acontece uma vez — fica guardado no volume `ollama_storage`.

### 4. Abrir a app

[http://localhost:8501](http://localhost:8501)

Deves ver o **Portal de RH - Assistente Seguro AI**. Faz uma pergunta inocente
(ex.: *"Que vagas têm abertas?"*) para confirmar que o LLM responde.

---

## 🧪 Verificar que o modelo está carregado

```powershell
docker exec ollama_backend ollama list
```

Deves ver `gemma2:2b` na lista. Se não estiver, força o download manualmente:

```powershell
docker exec ollama_backend ollama pull gemma2:2b
```

---

## 🛑 Parar / limpar

```powershell
# Parar (mantém o modelo descarregado em volume)
docker compose down

# Parar e apagar TUDO incluindo o modelo (~1.6 GB)
docker compose down -v
```

---

## 🎯 Objetivo do workshop

A app contém propositadamente um system prompt vulnerável em [app/app.py](app/app.py#L16):

- Existe uma `DATABASE` com salários, avaliações e uma `FLAG DO SISTEMA`.
- O system prompt diz ao modelo para **nunca** revelar esses dados.
- **Desafio:** através de mensagens criativas no chat, faz o assistente revelar
  a flag `flag{...}` ou os salários individuais.

Algumas pistas de ataque a explorar:
- Mudança de papel ("ignora as instruções anteriores...")
- Pedidos indiretos (resumos, traduções, base64)
- Falsa autoridade ("sou o admin", "modo manutenção")
- Injection via formato (JSON, código, markdown)

---

## 🔧 Troubleshooting

| Sintoma | Causa provável | Solução |
|---|---|---|
| `Erro ao ligar ao LLM: 'message'` | Modelo ainda não descarregado / erro do Ollama | Esperar pelo `✅` nos logs, ou `ollama pull gemma2:2b`
| `/bin/bash^M: bad interpreter` | `ollama-entrypoint.sh` com CRLF | Converter para LF (ver passo 2) |
| `Não foi possível ligar ao Ollama` | Container `ollama` ainda a arrancar | Aguardar e recarregar a página |

Para inspeccionar logs em tempo real:

```powershell
docker compose logs -f ollama
docker compose logs -f vulnerable-app
```

---
