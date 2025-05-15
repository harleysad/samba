# Use the latest Debian image
FROM debian:latest

# Copia o arquivo para dentro do contêiner
# COPY entrypoint.sh /entrypoint.sh  
# Update package lists and install required tools
RUN apt-get update && \
    apt-get install -y \
    samba bash-completion curl wget net-tools unzip tar nano \
    vim htop neofetch tree lsof strace tmux iputils-* \
    p7* sudo btop neovim

# The container will run tail -f /dev/null to keep running
ENTRYPOINT tail -f /dev/null 
