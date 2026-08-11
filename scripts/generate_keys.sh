#!/usr/bin/env bash

# Configuração de segurança: interrompe se houver erro em pipeline ou variáveis não definidas
set -euo pipefail

# Configurações fixas
EMAIL="seuemail@provedordeemail.com.br"
LISTA="nomes.txt"

# Verifica se o arquivo de lista existe
if [[ ! -f "$LISTA" ]]; then
    echo "Erro: Arquivo '$LISTA' não encontrado." >&2
    exit 1
fi

# Loop otimizado para processar cada nome
while IFS= read -r NOME || [[ -n "$NOME" ]]; do
    # Remove espaços no início e no fim nativamente no Bash
    NOME_LIMPO="${NOME#"${NOME%%[![:space:]]*}"}"
    NOME_LIMPO="${NOME_LIMPO%"${NOME_LIMPO##*[![:space:]]}"}"

    # Pula linhas vazias ou comentadas (se houver)
    if [[ -z "$NOME_LIMPO" || "$NOME_LIMPO" =~ ^# ]]; then 
        continue 
    fi

    echo "Gerando chave para: $NOME_LIMPO..."

    # Executa o GPG capturando eventuais erros
    if gpg --batch --no-tty --gen-key <<EOF
Key-Type: RSA
Key-Length: 2048
Key-Usage: sign
Subkey-Type: RSA
Subkey-Length: 2048
Subkey-Usage: encrypt
Name-Real: $NOME_LIMPO
Name-Email: $EMAIL
Expire-Date: 1y
%no-protection
%commit
EOF
    then
        echo "Chave para '$NOME_LIMPO' gerada com sucesso!"
    else
        echo "Erro ao gerar chave para '$NOME_LIMPO'." >&2
    fi

    echo "------------------------------------"
done < "$LISTA"