#!/usr/bin/env bash

# Interrompe em caso de erro em pipelines ou variáveis não definidas
set -euo pipefail

# Diretório onde as chaves serão salvas
DIRETORIO_SAIDA="./chaves_exportadas"
mkdir -p "$DIRETORIO_SAIDA"

echo "📦 Iniciando exportação em massa de chaves GPG..."
echo "Diretório de destino: $DIRETORIO_SAIDA"
echo "------------------------------------------------"

# Contador de chaves exportadas
CONTADOR=0

# Loop usando --with-colons (saída estruturada e segura do GPG)
# Filtramos apenas as linhas 'uid' para capturar o nome do titular
while IFS=':' read -r TIPO _ _ _ _ _ _ _ _ UID_RAW _; do
    if [[ "$TIPO" == "uid" ]]; then
        # Extrai apenas o nome real (remover o e-mail e comentários entre < > e ( ))
        NOME_LIMPO=$(echo "$UID_RAW" | sed -E 's/ *<.*>//; s/ *\(.*\)//')

        # Sanitiza o nome para ser um nome de arquivo válido no Linux (troca caracteres estranhos por _)
        NOME_ARQUIVO=$(echo "$NOME_LIMPO" | tr -c 'a-zA-Z0-9._-' '_')

        if [[ -z "$NOME_ARQUIVO" ]]; then
            continue
        fi

        echo "Exportando: $NOME_LIMPO..."

        # 1. Exporta a Chave Pública
        gpg --batch --yes --output "${DIRETORIO_SAIDA}/${NOME_ARQUIVO}_publica.asc" \
            --armor --export "$NOME_LIMPO"

        # 2. Exporta a Chave Privada (Secret)
        gpg --batch --yes --output "${DIRETORIO_SAIDA}/${NOME_ARQUIVO}_privada.key" \
            --armor --export-secret-keys "$NOME_LIMPO"

        ((CONTADOR++))
        echo "✅ OK -> ${NOME_ARQUIVO}_publica.asc e ${NOME_ARQUIVO}_privada.key"
        echo "------------------------------------------------"
    fi
done < <(gpg --batch --with-colons --list-secret-keys)

echo "🎉 Concluído! Total de $CONTADOR par(es) de chaves exportado(s)."