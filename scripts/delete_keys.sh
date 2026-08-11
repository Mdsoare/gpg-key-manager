#!/usr/bin/env bash

set -euo pipefail

echo "⚠️  ATENÇÃO: ESTE SCRIPT APAGARÁ TODAS AS CHAVES DO SEU KEYRING! ⚠️"
echo "------------------------------------------------------------------"

# Lista as chaves que serão afetadas antes de pedir confirmação
echo "As seguintes chaves serão EXCLUÍDAS:"
gpg --list-secret-keys --keyid-format LONG || true
echo "------------------------------------------------------------------"

# Trava de Segurança
read -rp "Digite 'DELETAR' em maiúsculas para confirmar a exclusão em massa: " CONFIRMACAO

if [[ "$CONFIRMACAO" != "DELETAR" ]]; then
    echo "❌ Operação cancelada pelo usuário."
    exit 0
fi

echo ""
echo "🔥 Iniciando deleção em massa via Fingerprint..."

CONTADOR=0

# Captura diretamente os Fingerprints (linha 'fpr', campo 10)
while IFS=':' read -r TIPO _ _ _ _ _ _ _ _ FPR _; do
    if [[ "$TIPO" == "fpr" && -n "$FPR" ]]; then
        echo "Deletando chave via Fingerprint: $FPR"

        # Tenta deletar a chave secreta (privada)
        gpg --batch --yes --delete-secret-keys "$FPR" 2>/dev/null || true

        # Deleta a chave pública associada
        gpg --batch --yes --delete-keys "$FPR" 2>/dev/null || true

        ((CONTADOR++))
        echo "✅ Fingerprint $FPR removido."
        echo "------------------------------------------------"
    fi
done < <(gpg --batch --with-colons --fingerprint)

echo "🧹 Faxina concluída! $CONTADOR chave(s) processada(s)."