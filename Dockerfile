FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

USER root
ENV USER=root

# Install essentials
RUN apt-get update \
    && apt-get install -y build-essential curl git exuberant-ctags software-properties-common gnupg \
    && apt-get install -y locales \
    && apt-get install -y unzip wget \
    && apt-get install -y python3-pip virtualenv \
    && apt-get clean

# Install neovim
RUN add-apt-repository -y ppa:neovim-ppa/unstable \
    && apt-get install -y neovim \
    && mkdir -p ~/.config/nvim/ \
    && apt-get clean

#RUN curl -L -o rust-analyzer-x86_64-unknown-linux-gnu.gz https://github.com/rust-analyzer/rust-analyzer/releases/download/nightly/rust-analyzer-x86_64-unknown-linux-gnu.gz \
#    && gzip -d rust-analyzer-x86_64-unknown-linux-gnu.gz \
#    && mkdir -p ~/.local/bin \
#    && mv rust-analyzer-x86_64-unknown-linux-gnu ~/.local/bin/rust-analyzer \
#    && chmod +x ~/.local/bin/rust-analyzer \

# Install Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.local/bin:/root/.cargo/bin:${PATH}"

RUN locale-gen it_IT.UTF-8
ENV LANG='it_IT.UTF-8' LANGUAGE='it_IT:en' LC_ALL='it_IT.UTF-8'

COPY ./configs/ /root/.config/nvim

RUN nvim --headless -c "autocmd User LazySync quitall" "+Lazy! sync" && nvim --headless +qa

CMD ["/bin/bash"]
