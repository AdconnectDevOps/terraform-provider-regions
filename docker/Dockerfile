# build terraform
FROM alpine AS build-terraform

ENV TERRAFORM_VERSION=0.12.28

RUN apk update && \
    apk add unzip wget

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

# build stage
FROM golang:alpine AS build-go

RUN apk update && \
    apk add --no-cache git

RUN go get -v github.com/hashicorp/terraform/plugin

ADD terraform-providers /go/src/github.com/terraform-providers

RUN cd /go/src/github.com/terraform-providers/terraform-provider-dnsimple && \
    go build -o terraform-provider-regions

# final stage
FROM alpine

RUN apk update && \
    apk add ca-certificates bash curl

WORKDIR /app

COPY --from=build-terraform /usr/bin/terraform /usr/bin/

COPY --from=build-go /go/src/github.com/terraform-providers/terraform-provider-dnsimple/terraform-provider-regions /app/

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["terraform"]

