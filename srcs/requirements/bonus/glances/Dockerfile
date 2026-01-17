FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip --break-system-packages && \
    pip3 install "glances[web]" --break-system-packages

COPY conf/glances.conf /etc/glances.conf

EXPOSE 61208

CMD ["glances", "-w"]