FROM homebrew/brew:4.0.4 AS base

LABEL maintainer="Ralph Brynard <ralph@thebrynards.com>" \
    org.label-schema.name="collection" \
    org.label-schema.description="Ansible Collection for VMWare - Ubuntu 20.04" \
    org.label-schema.version="1.0.0"

# Install Zsh
RUN echo "****** Installing Zsh ******" \
	&& brew install zsh

# Set Zsh as default shell
RUN echo "****** Setting Zsh as default shell ******" \
	&& chsh -s /bin/zsh \
	&& exec zsh \
	&& echo $SHELL

# Install Oh-My-Posh
RUN echo "****** Installing Oh-My-Posh ******" \
	&& brew install jandedobbeleer/oh-my-posh/oh-my-posh

# Install FiraCode Nerd Font
RUN echo "****** Installing FiraCode Nerd Font ******" \
	&& brew tap homebrew/cask-fonts \
	&& brew install --cask font-firacode-nerd-font


CMD ["brew", "--version"]
