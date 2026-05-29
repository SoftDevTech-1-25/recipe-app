# 🍳 Recipe App

Цифровая библиотека для домашних поваров, позволяющая хранить, организовывать и масштабировать свои любимые блюда.

## 📋 Описание

**Recipe App** — это полнофункциональное веб-приложение, которое помогает пользователям:
- 📚 Хранить и просматривать рецепты любимых блюд
- 🏷️ Организовывать рецепты по категориям и тегам
- 🔍 Быстро находить нужные рецепты
- ⭐ Отмечать и сохранять избранные рецепты
- 📱 Получать доступ к библиотеке с любого устройства

## 🛠️ Технологический стек

| Технология | Процент | Описание |
|-----------|---------|----------|
| **Go** | 43% | Backend, API, бизнес-логика |
| **HTML** | 40.1% | Структура веб-интерфейса |
| **JavaScript** | 8.4% | Интерактивность, клиентская логика |
| **CSS** | 8.2% | Стилизация и дизайн |
| **Other** | 0.3% | Конфиг файлы и утилиты |

## 🎯 Основные возможности

### Backend (Go)
- ✅ RESTful API для управления рецептами
- ✅ Работа с базой данных
- ✅ Аутентификация и авторизация
- ✅ Валидация данных

### Frontend (HTML/CSS/JavaScript)
- ✅ Отзывчивый веб-интерфейс
- ✅ Динамический поиск и фильтрация
- ✅ Сохранение избранных рецептов
- ✅ Красивая визуализация блюд

## 🚀 Быстрый старт

### Требования (для локального запуска)
- Go 1.16+
- Node.js (опционально, если используется сборка)
- Git

### Вариант 1: Запуск с использованием Docker 🐳 (Рекомендуется)

#### Требования
- [Docker Desktop](https://www.docker.com/products/docker-desktop)
- Docker Compose (входит в Docker Desktop)

#### 📦 Установка Docker Desktop

**На Windows:**
1. Скачайте [Docker Desktop для Windows](https://www.docker.com/products/docker-desktop)
2. Запустите установщик и следуйте инструкциям
3. Перезагрузитесь (может потребоваться несколько раз)
4. Откройте PowerShell или Command Prompt и проверьте установку:
   ```bash
   docker --version
   docker-compose --version
   ```

**На macOS/Linux:**
1. Скачайте [Docker Desktop для macOS](https://www.docker.com/products/docker-desktop) или установите через пакетный менеджер
2. Запустите установщик
3. Проверьте установку:
   ```bash
   docker --version
   docker-compose --version
   ```

#### 🚀 Установка и запуск

**Шаг 1 — Останови и удали все старые контейнеры (при переустановке):**
```bash
docker compose down
```

**Шаг 2 — Принудительно удали контейнеры, если всё ещё присутствуют:**
```bash
docker rm -f mc-backend mc-frontend
```

**Шаг 3 — Запусти всё заново:**
```bash
# Клонируем репозиторий (если ещё не клонирован)
git clone https://github.com/SoftDevTech-1-25/recipe-app.git
cd recipe-app

# Запускаем приложение с пересборкой образов
docker compose up --build
```

**Приложение будет доступно по адресам:**
- 🌐 Frontend: `http://localhost` (80 порт)
- 🔌 Backend API: `http://localhost:8080` (8080 порт)

#### 🛑 Остановка контейнеров:
```bash
docker compose down
```

#### 📋 Просмотр логов:
```bash
docker compose logs -f
```

#### 🔍 Проверка статуса контейнеров:
```bash
docker compose ps
```

---

### Вариант 2: Запуск локально (без Docker)

```bash
# Клонируем репозиторий
git clone https://github.com/SoftDevTech-1-25/recipe-app.git
cd recipe-app

# Устанавливаем зависимости Go
go mod download

# Запускаем приложение
go run main.go
```

**Приложение будет доступно по адресу:** `http://localhost:8080`

---

## 📁 Структура проекта

```
recipe-app/
├── backend/
│   ├── Dockerfile              # Docker конфиг для backend
│   ├── main.go                 # Точка входа приложения
│   ├── internal/
│   │   ├── handler/            # HTTP обработчики
│   │   ├── service/            # Бизнес-логика
│   │   ├── repository/         # Работа с БД
│   │   ├── domain/             # Структуры данных
│   │   └── dto/                # Data Transfer Objects
│   ├── go.mod                  # Зависимости Go
│   └── go.sum                  # Версии зависимостей
├── frontend/
│   ├── index.html              # Главная страница
│   ├── recipes.html            # Страница рецептов
│   ├── recipe-detail.html      # Детальный вид рецепта
│   ├── calendar.html           # Календарь питания
│   ├── notepad.html            # Блокнот и список покупок
│   ├── favorites.html          # Избранные рецепты
│   ├── help.html               # Справка
│   ├── css/
│   │   ├── style.css           # Основные стили
│   │   └── *.css               # Компонент-специфичные стили
│   ├── js/
│   │   ├── main.js             # Основной скрипт
│   │   └── frontend-api-client.js  # API клиент
│   └── img/                    # Изображения и иконки
├── docker-compose.yml          # Конфигурация Docker Compose
├── nginx.conf                  # Конфигурация Nginx
├── README.md                   # Этот файл
└── LICENSE                     # Лицензия (MIT)
```

## 🔌 API Endpoints

### Рецепты
- `GET /api/recipes` — Получить все рецепты с фильтрацией
- `GET /api/recipes/:id` — Получить рецепт по ID
- `POST /api/recipes` — Создать новый рецепт
- `PUT /api/recipes/:id` — Обновить рецепт
- `DELETE /api/recipes/:id` — Удалить рецепт
- `GET /api/recipes/:id/scale` — Масштабировать рецепт

### Избранное
- `POST /api/recipes/:id/favorite` — Добавить в избранное
- `DELETE /api/recipes/:id/favorite` — Удалить из избранного
- `GET /api/favorites` — Получить все избранные рецепты

### Категории и теги
- `GET /api/categories` — Получить все категории
- `GET /api/tags` — Получить все теги

### Аутентификация
- `POST /auth/register` — Регистрация пользователя
- `POST /auth/login` — Вход в систему
- `GET /users/me` — Получить профиль текущего пользователя
- `PUT /users/me` — Обновить профиль

### План питания
- `GET /meal-plans` — Получить планы питания за период
- `POST /meal-plans` — Создать план питания
- `PUT /meal-plans/:id` — Обновить план питания
- `DELETE /meal-plans/:id` — Удалить план питания

### Список покупок
- `GET /shopping-list` — Получить список покупок
- `PUT /shopping-list/:id` — Обновить элемент списка
- `DELETE /shopping-list/:id` — Удалить элемент из списка
- `DELETE /shopping-list/clear` — Очистить список

**👉 Подробное описание API находится в [API.md](./API.md) или смотрите в коде**

## 💾 Работа с данными

Приложение поддерживает сохранение и обработку:
- Названия и описания рецептов
- Список ингредиентов с количеством и единицами измерения
- Пошаговые инструкции приготовления с длительностью
- Время приготовления и уровень сложности
- Фотографии блюд
- Избранные рецепты (сохраняются локально в браузере)
- Категории и теги рецептов

## 🎨 Интерфейс

- 🎮 Уникальный дизайн в стиле Minecraft (пиксель-арт)
- 📱 Адаптивная вёрстка (Mobile-first)
- ⚡ Быстрая загрузка страниц
- 🧭 Удобная навигация
- 💾 Локальное сохранение данных в браузере

## 🐳 Docker инструкции (Продвинутые)

### Запуск с Docker Compose (все-в-одном)
```bash
# Запуск всех сервисов
docker compose up -d

# Проверка статуса
docker compose ps

# Просмотр логов backend
docker compose logs -f backend

# Просмотр логов frontend
docker compose logs -f frontend
```

### Ручная сборка и запуск образов
```bash
# Сборка backend образа
docker build -t recipe-app-backend ./backend

# Запуск backend контейнера
docker run -d -p 8080:8080 --name backend recipe-app-backend

# Запуск frontend контейнера (Nginx)
docker run -d -p 80:80 --name frontend -v $(pwd)/frontend:/usr/share/nginx/html nginx:alpine
```

### Удаление контейнеров и томов
```bash
# Остановка и удаление контейнеров
docker compose down

# Удаление контейнеров, сетей, томов
docker compose down -v

# Удаление образов
docker compose down --rmi all
```

## 🚀 Переменные окружения

Для Docker Compose можно создать файл `.env`:
```env
# Backend
BACKEND_PORT=8080
DB_PATH=/app/data/recipes.db

# Frontend
FRONTEND_PORT=80
API_URL=http://localhost:8080
```

## 📊 Требования системы

**Для Docker:**
- CPU: 1 core
- RAM: 512 MB
- Storage: ~500 MB

**Для локального запуска:**
- CPU: 1 core
- RAM: 256 MB
- Storage: ~100 MB

## 🤝 Внесение вклада

Мы приветствуем любые улучшения! Для внесения изменений:

1. Создайте Fork репозитория
2. Создайте branch для вашей фичи (`git checkout -b feature/amazing-feature`)
3. Сделайте Commit (`git commit -m 'Add amazing feature'`)
4. Отправьте Push (`git push origin feature/amazing-feature`)
5. Создайте Pull Request

## 📝 Лицензия

Этот проект лицензирован под MIT License — см. файл [LICENSE](LICENSE) для деталей.

## 👥 Команда разработки

Разработано командой **SoftDevTech**

- 🎨 **Эрбол** — Frontend разработка
- ⚙️ **Эмир** — Backend разработка
- 🗄️ **Бекжан** — Database архитектура

## 📞 Обратная связь

Если у вас есть вопросы или предложения, откройте [Issue](https://github.com/SoftDevTech-1-25/recipe-app/issues) или свяжитесь с нами.

## 🔗 Полезные ссылки

- 📖 [API документация](./API.md)
- 🐛 [Сообщить об ошибке](https://github.com/SoftDevTech-1-25/recipe-app/issues)
- 💡 [Запросить фичу](https://github.com/SoftDevTech-1-25/recipe-app/issues)
- 🌐 [GitHub репозиторий](https://github.com/SoftDevTech-1-25/recipe-app)

---

**Спасибо за использование Recipe App! Приятного приготовления! 👨‍🍳👩‍🍳**

Made with ❤️ by SoftDevTech
