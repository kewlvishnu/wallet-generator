
FROM golang:1.11 as go-builder

RUN go get github.com/hashicorp/packer
WORKDIR /go/src/github.com/hashicorp/packer
RUN CGO_ENABLED=0 go build -o /usr/local/bin/packer

WORKDIR /go
RUN go get github.com/hashicorp/terraform
WORKDIR /go/src/github.com/hashicorp/terraform
RUN CGO_ENABLED=0 go build -o /usr/local/bin/terraform


FROM ubuntu:18.04
COPY --from=go-builder /usr/local/bin/packer /usr/local/bin/packer
COPY --from=go-builder /usr/local/bin/terraform /usr/local/bin/terraform
RUN apt-get update
RUN apt-get install -y software-properties-common git
RUN add-apt-repository ppa:jonathonf/python-3.6
RUN apt-get update
RUN apt-get install -y python3.6
RUN apt-get update
RUN apt-get -y install curl gnupg
RUN curl -sL https://deb.nodesource.com/setup_11.x  | bash -
RUN apt-get -y install nodejs
RUN npm install
RUN node -v
RUN npm -v
RUN rm -rf vutil/config.json
RUN git clone https://github.com/kewlvishnu/vutil.git
RUN cp -R vutil/config.sample.json vutil/config.json
RUN npm install vutil/
RUN chmod +x vutil/vutil-server-start.sh
RUN git clone https://github.com/vkobel/ethereum-generate-wallet.git
RUN cp ethereum-generate-wallet/ethereum-wallet-generator.py vutil/ethereum-wallet-generator.py
RUN cp ethereum-generate-wallet/requirements.txt vutil/requirements.txt
RUN apt-get install -y python3-pip
RUN pip3 install -r vutil/requirements.txt
#RUN PORT=4080 node vutil/server.js
