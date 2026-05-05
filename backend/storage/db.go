package storage

import (
	"database/sql"
	"log"

	_ "modernc.org/sqlite"
)

var DB *sql.DB

func InitDB() {
	var err error

	DB, err = sql.Open("sqlite", "../database/recipes.db")
	if err != nil {
		log.Fatal("Ошибка подключения к БД:", err)
	}

	if err = DB.Ping(); err != nil {
		log.Fatal("База данных недоступна:", err)
	}

	createTableSQL := `CREATE TABLE IF NOT EXISTS recipes (
		"id" INTEGER PRIMARY KEY AUTOINCREMENT,
		"name" TEXT,
		"difficulty" INTEGER,
		"image_slug" TEXT
	);`

	_, err = DB.Exec(createTableSQL)
	if err != nil {
		log.Fatal("Ошибка создания таблицы:", err)
	}

	log.Println(" База данных (Pure Go) подключена!")
}
