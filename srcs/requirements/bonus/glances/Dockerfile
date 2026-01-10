FROM debian:bookworm

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-dev \
    gcc \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN pip3 install --upgrade pip && \
    pip3 install "glances[web]"

COPY conf/glances.conf /etc/glances.conf

EXPOSE 61208

CMD ["glances", "-w"]