# build terraform
FROM alpine AS build-terraform

ENV TERRAFORM_VERSION=1.1.7

RUN apk update && \
    apk add unzip wget

RUN cd /tmp && \
    wget https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip -d /usr/bin

# build stage
FROM golang:alpine AS build-go
RUN apk update && \
    apk add --no-cache git

COPY ./ /app
WORKDIR /app

RUN go get 
RUN go build

# final stage
FROM alpine

RUN apk update && \
    apk add ca-certificates bash curl

WORKDIR /app

COPY --from=build-terraform /usr/bin/terraform /usr/bin/

COPY --from=build-go /app/terraform-provider-regions /app/

ENTRYPOINT ["/bin/bash", "-c"]

CMD ["terraform"]

