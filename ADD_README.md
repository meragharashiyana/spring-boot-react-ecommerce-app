## Spring Boot + React E‑commerce (Project Guide)

### Overview
A full‑stack e‑commerce application using a microservices architecture:
- **Backend**: Spring Boot 2.x (Java 11), MySQL, Redis
- **Frontend**: React (Redux, Thunk), Material‑UI, Semantic‑UI
- **Infra**: Docker Compose for local orchestration; deployable to Heroku
- **3rd‑party**: Stripe (payments), Google OAuth (auth), Cloudinary (images)

### Architecture
- **React‑UI Service** (`client/`): SPA UI that calls backend APIs via Axios.
- **Authentication Service** (`server/authentication-service/`): Username/password + Google OAuth; persists users to MySQL.
- **Common Data Service** (`server/common-data-service/`): Products, categories, filters, orders; Redis caching.
- **Payment Service** (`server/payment-service/`): Handles Stripe payment flows.
- **Search Suggestion Service** (`server/search-suggestion-service/`): Default and prefix‑based suggestions; builds in‑memory maps.
- **MySQL** and **Redis** containers.
- All services wired via `docker-compose.yml` and network `spring-cloud-microservices`.

### Tech Stack
- **Backend**: Spring Boot (web, data‑jpa, cache, actuator), Lombok, ModelMapper, Spring Data Redis, Jedis; MySQL 8
- **Frontend**: React 16, Redux, Redux‑Thunk, React Router, Material‑UI, Semantic‑UI, Stripe JS
- **Infra**: Docker, Docker Compose, Heroku container stack

### Key Features
- **Auth**: Google OAuth 2.0 + Username/Password
- **Product discovery**: Search, suggestions, filters, sorting, pagination
- **Cart & Auth cookies**: Persists cart items and tokens client‑side
- **Performance**: Redis caching for API data
- **Payments**: Stripe integration
- **Responsive UI**: Material‑UI and Semantic‑UI

### Ports (defaults from `.env-sample`)
- React UI: `3000`
- Authentication: `7000`
- Common Data: `9000`
- Payment: `9050`
- Search Suggestion: `10000`
- MySQL: `3306`
- Redis: `6379`

### Configuration
Copy and adjust environment variables:
- Duplicate `.env-sample` as `.env`
- Core variables:
  - **MySQL**: `MYSQL_ROOT_PASSWORD`, `MYSQL_DATABASE`, `MYSQL_USER`, `MYSQL_PASSWORD`
  - **Spring services**: `DB_PORT`, `DB_SCHEMA`, `DB_USER`, `DB_PASS`, `ACTIVE_PROFILE`
  - **Redis**: `REDIS_PASSWORD`, `REDIS_PORT`
  - **React**: `REACT_APP_PORT`, `REACT_CLIENT_URL`, `REACT_APP_ENVIRONMENT`
  - **3rd‑party**: `REACT_APP_STRIPE_PUBLISH_KEY`, `REACT_APP_GOOGLE_AUTH_CLIENT_ID`
  - **Service ports**: `AUTHENTICATION_SERVICE_PORT`, `PAYMENT_SERVICE_PORT`, `COMMON_DATA_SERVICE_PORT`, `SEARCH_SUGGESTION_SERVICE_PORT`

### Running Locally (Docker Compose)
Prereqs: Docker + Docker Compose installed.

- Windows:
  - Run: `start-all.bat`

This script recreates the `spring-cloud-microservices` network and builds/starts all containers. Frontend is served at `http://localhost:3000` (default).

To stop/clean between code changes, use:
```
./stop-all.bat
```

### Frontend Notes
- Entry: `client/src/index.js` mounts `<App />` with Redux store.
- Routing: `client/src/components/app.js` configures routes for home, auth, product list/details, shopping bag, checkout, success/cancel pages, and 400 handler.
- Dev mode: `REACT_APP_ENVIRONMENT=dev` enables logs and Redux DevTools; otherwise logs are suppressed.

### Backend Notes
- Example service: `server/common-data-service/`
  - Spring Boot 2.3, Java 11
  - Uses JPA + MySQL; Redis for caching
  - Main class calls `CommonDataController#fillWithTestData()` on startup (dev) to seed mock data.
- Databases:
  - MySQL initialized via `mysql-db/user.sql` (grants needed privileges).
- Inter‑service URLs and ports configured by `docker-compose.yml` and `.env`.

### Payments (Stripe Test)
Use Stripe test card:
- Card: `4242 4242 4242 4242`
- Expiry: any future date
- CVC: any 3 digits

Payments and Google login require keys, but the app runs without them (these features will be disabled).

### Deployment (Heroku)
- Use container stack (`heroku stack:set container -a <app-name>`).
- Provision a MySQL add‑on (requires adding a credit card to the Heroku account).
- Set config vars to match your DB/Redis/keys.
- Create `heroku.yml` (compose isn’t invoked directly on Heroku).
- Deploy services individually as needed.

### Project Structure (high‑level)
```
.
├─ client/                         # React app (Redux, routing, UI)
│  └─ src/
│     ├─ components/               # app, navbar, routes, UI
│     ├─ actions/ reducers/ api/   # Redux + API
│     └─ styles/ images/           # styling and assets
├─ server/                         # Spring Boot microservices
│  ├─ authentication-service/
│  ├─ common-data-service/
│  ├─ payment-service/
│  ├─ search-suggestion-service/
│  └─ seller-account-service/
├─ mysql-db/                       # DB init scripts
├─ docker-compose.yml              # Orchestration for local dev
├─ start-all.sh / start-all.bat    # Run all services
└─ README.md                       # Project readme (features, setup)
```

### Useful Links
- Spring CORS: https://spring.io/blog/2015/06/08/cors-support-in-spring-framework
- Stripe docs: https://stripe.com/docs
- Google OAuth: https://developers.google.com/identity/protocols/oauth2
- Spring Data Redis: https://docs.spring.io/spring-data/data-redis/docs/current/reference/html/
- Material‑UI: https://mui.com/
- Semantic‑UI: https://react.semantic-ui.com/
