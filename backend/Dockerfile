FROM golang:1.25-alpine

RUN apk add --no-cache gcc musl-dev sqlite  # ← добавь sqlite

ENV CGO_ENABLED=1

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o server .

EXPOSE 8080

CMD ["./server"]