FROM ubuntu

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    git \
    ssh

RUN mkdir /app
WORKDIR /app

COPY . /app

CMD [ "bash", "/app/sync.sh" ]