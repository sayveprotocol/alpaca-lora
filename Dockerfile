FROM ubuntu:20.04



RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    software-properties-common \
    && add-apt-repository ppa:deadsnakes/ppa \
    && apt install -y python3.10 \
    && rm -rf /var/lib/apt/lists/*


WORKDIR /app

COPY requirements.txt .

RUN curl -sS https://bootstrap.pypa.io/get-pip.py | python3.10
RUN python3.10 -m pip install -r requirements.txt
RUN python3.10 -m pip install numpy --pre torch --force-reinstall --index-url https://download.pytorch.org/whl/nightly/cu118

RUN mkdir models && \
    cd models && \
    wget https://huggingface.co/decapoda-research/llama-7b-hf/resolve/main/config.json && \
    wget https://huggingface.co/decapoda-research/llama-7b-hf/resolve/main/pytorch_model.bin && \
    wget https://huggingface.co/decapoda-research/llama-7b-hf/resolve/main/tokenizer_config.json && \
    wget https://huggingface.co/decapoda-research/llama-7b-hf/resolve/main/vocab.json && \
    wget https://huggingface.co/tloen/alpaca-lora-7b/resolve/main/config.json && \
    wget https://huggingface.co/tloen/alpaca-lora-7b/resolve/main/pytorch_model.bin

COPY generate.py .

CMD ["python3.10", "inference.py"]
