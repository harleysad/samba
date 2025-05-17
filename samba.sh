#!/bin/sh

USER_ID=1000 # Id do primeiro usuario linux
USER_NAME=$DEFAULT_USER # Nome do usuario padrao
PASSWORD=$SENHA_UBT
DATADIR=$VSCODE_DATA_DIR
GROUP="users"
GROUP_SUDO="sudo"

# -----------------------------------------------------------------------------
# 1- Configração para um usuario padrão e permissoes de acesso
# -----------------------------------------------------------------------------
# Verifica se o grupo 'sudo' existe
if ! getent group $GROUP_SUDO > /dev/null 2>&1; then
    # se nao existe cria
    groupadd $GROUP_SUDO
fi
# Verifica se o grupo 'users' existe
if ! getent group $GROUP > /dev/null 2>&1; then
    # se nao existe cria
    groupadd $GROUP
fi
# Verifica se já existe um usuário com o UID fornecido
if getent passwd "$USER_ID" >/dev/null 2>&1; then
    # Armazena o nome original
    USER_NAMEI=$(getent passwd "$USER_ID" | cut -d: -f1)
    # Altera o nome do usuario parão para o da variavel
    usermod -l $USER_NAME $USER_NAMEI
    # Ajusta o diretório home
    mv /home/$USER_NAMEI /home/$USER_NAME
    usermod -d /home/$USER_NAME -m $USER_NAME
else
    # cria o novo usuário
    useradd -m -u $USER_ID -s /bin/bash $USER_NAME
fi

# Muda o grupo parao do usuário
usermod -g $GROUP $USER_NAME
# Altera a senha
echo "$USER_NAME:$PASSWORD" | chpasswd
# Usuario vai ter sudo
usermod -aG $GROUP_SUDO $USER_NAME
#------------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# 2- Configuração do Samba
# -----------------------------------------------------------------------------
# Adiciona o usuário ao banco de dados do Samba
(echo "$PASSWORD"; echo "$PASSWORD") | smbpasswd -a -s "$USER_NAME" 
# Habilita o usuário no Samba
smbpasswd -e "$USER_NAME"
# -----------------------------------------------------------------------------
# 3 - Configuração do sambashare
# -----------------------------------------------------------------------------
# cria /var/lib/samba/usershares se ele nao existir
if [ ! -d /var/lib/samba/usershares ]; then
    mkdir -p /var/lib/samba/usershares
fi
sudo chmod 1777 /var/lib/samba/usershares
sudo chown  $USER_NAME:$GROUP /var/lib/samba/usershares

# Executa a aplicação com o usuário especificado
# runuser -l $USER_NAME -c "umask 0002 && \
#                         tail -f /dev/null "
tail -f /dev/null
# smbd -F