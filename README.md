# 🔑 GPG Key Manager (Automated Bulk Management)

[![DevSecOps Unified Security Scan](https://github.com/Mdsoare/gpg-key-manager/actions/workflows/security-scan.yml/badge.svg)](https://github.com/Mdsoare/gpg-key-manager/actions/workflows/security-scan.yml)
![Shell Script](https://img.shields.io/badge/shell-bash-blue.svg)
![GnuPG](https://img.shields.io/badge/GnuPG-v2.x-0093DD?logo=gnu&logoColor=white)
![dos2unix](https://img.shields.io/badge/utility-dos2unix-orange.svg)
![License MIT](https://img.shields.io/badge/license-MIT-green.svg)
![Compliance](https://img.shields.io/badge/compliance-LGPD%20%7C%20GDPR-purple.svg)

---

Uma suíte de scripts em **Bash** projetada para automatizar o ciclo de vida de chaves **GPG/PGP** em lote (bulk operations). O repositório oferece soluções para geração não-interativa, exportação organizada e deleção em massa de pares de chaves.

---

## 🛠️ Tecnologias Utilizadas

* **Bash Shell Scripting**
* **GnuPG (gpg)**
* **Linux CLI Tools** (`sed`, `tr`, `dos2unix`, etc.)

---

## 📂 Estrutura do Repositório

```text
.
├── .gitignore
├── LICENSE
├── README.md            # Documentação do projeto
└── scripts/
    ├── .gitignore
    ├── generate_keys.sh # Geração de chaves em lote a partir de lista de nomes
    ├── export_keys.sh   # Exportação em massa de chaves públicas e privadas
    └── delete_keys.sh   # Exclusão completa em massa com trava de segurança
```

---

## 🚀 Como Usar

### 1. Pré-requisitos e Preparação

1. Certifique-se de que o **GnuPG** e o **dos2unix** estejam instalados em seu ambiente:

   ```bash
   sudo apt update && sudo apt install gnupg dos2unix -y  # Debian/Ubuntu
   # ou
   sudo dnf install gnupg2 dos2unix -y                   # RHEL/CentOS/Fedora
   ```

2. Ajuste o formato de quebra de linha dos scripts caso tenham sido salvos/editados no Windows (`CRLF` -> `LF`):

   ```bash
   dos2unix scripts/*.sh nomes.txt
   ```

   > 💡 **Dica:** No VS Code, você também pode alterar o fim de linha no canto inferior direito do editor de **CRLF** para **LF** antes de salvar os arquivos.

3. Conceda permissão de execução aos scripts:

   ```bash
   chmod +x scripts/*.sh
   ```

---

### 2. Geração em Massa (`generate_keys.sh`)

Gera pares de chaves RSA de 2048 bits de forma não-interativa lendo o arquivo `nomes.txt`.

1. Adicione os nomes desejados no arquivo `nomes.txt` na raiz (suporta comentários usando `#`):

   ```text
   Nome_1
   Nome_2
   # Linha ignorada
   ```

2. Execute o script:

   ```bash
   ./scripts/generate_keys.sh
   ```

---

### 3. Exportação em Massa (`export_keys.sh`)

Lê as chaves existentes no keyring local e exporta os arquivos para a pasta `./chaves_exportadas/`.

* **Pública:** `.asc` (ASCII-armored)
* **Privada:** `.key` (ASCII-armored)

```bash
./scripts/export_keys.sh
```

---

### 4. Remoção em Massa (`delete_keys.sh`)

Efetua a limpeza de **todas** as chaves privadas e públicas associadas do keyring via Fingerprint.

> ⚠️ **Atenção:** Ação irreversível. O script exige confirmação digitada (`DELETAR`) para ser executado.

```bash
./scripts/delete_keys.sh
```

---

## 🔒 Boas Práticas e Segurança

* Os scripts utilizam a flag `--with-colons` do GPG para realizar o parsing seguro dos dados.
* Implementação do parâmetro `set -euo pipefail` para prevenção de execução sob falhas intermediárias.
* Tratamento nativo de *Parameter Expansion* para sanitização de strings e eliminação de subshells desnecessários.

---

## 📜 Licença

Este projeto está sob a licença [MIT](LICENSE).

---

*Desenvolvido por **Marcelo Soares** | Especialista em Segurança da Informação e Computação Forense.*