FROM golang:1.25-alpine

WORKDIR /app

# Устанавливаем GCC и musl-dev для CGO (SQLite требует)
RUN apk add --no-cache gcc musl-dev

# Включаем CGO
ENV CGO_ENABLED=1

COPY go.mod go.sum ./
RUN go mod download

COPY . .

RUN go build -o server .

EXPOSE 8080

CMD ["./server"]