FROM golang:1.20-alpine AS build

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY *.go ./

RUN CGO_ENABLED=0 GOOS=linux go build -o bambulabs-exporter

FROM debian:12.6-slim

WORKDIR /app

COPY --from=build /app/bambulabs-exporter ./
COPY .env ./
COPY docker/docker-entrypoint.sh ./
RUN chmod +x docker-entrypoint.sh

EXPOSE 9101

ENTRYPOINT [ "/app/docker-entrypoint.sh" ]
CMD [ "bambulabs-exporter" ]
