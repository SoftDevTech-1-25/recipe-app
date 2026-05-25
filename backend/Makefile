.PHONY: build run test migrate migrate-down swagger clean docker-up docker-down

build:
	go build -o bin/api ./cmd/api

run:
	go run ./cmd/api

test:
	go test -v ./...

migrate:
	go run ./cmd/api migrate

migrate-down:
	go run ./cmd/api migrate-down

swagger:
	swag init -g cmd/api/main.go

clean:
	rm -rf bin/

docker-up:
	docker-compose up --build -d

docker-down:
	docker-compose down -v

lint:
	golangci-lint run
