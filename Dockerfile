# Use the latest Debian image
FROM alpine:latest

# Copia o arquivo para dentro do contêiner

RUN apk update && \
apk add --no-cache \
bash sudo coreutils samba shadow   
# Update package lists and install required tools
# RUN apt-get update && \
#     apt-get install -y \
#     bash-completion curl wget net-tools unzip \
#     tar nano dnsutils vim htop neofetch tree \
#     lsof strace tmux iputils-* p7* sudo btop \
#     samba neovim procps nmap iproute2 

COPY --chmod=0755 samba.sh /samba.sh
COPY --chmod=0644 smb.conf /etc/samba/smb.conf

# The container will run tail -f /dev/null to keep running
ENTRYPOINT tail -f /dev/null
