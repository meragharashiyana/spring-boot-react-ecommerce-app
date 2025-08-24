## Windows Local Run (No Docker)

This guide shows how to run the app natively on Windows using PowerShell.

### 1) Prerequisites (Windows)
- Java 11 (JDK)
- Node.js 14+ (LTS recommended)
- MySQL 8.x running locally
- Redis running locally on `127.0.0.1:6379` with password `mypass`

### 2) MySQL Setup
Create database and user (adjust names if needed):
1. Open a terminal and log in to MySQL as root:
```
mysql -u root -p
```
2. Run the SQL:
```
CREATE DATABASE ecommerce_app_database CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'mysqluser'@'%' IDENTIFIED BY 'mypass';
GRANT ALL PRIVILEGES ON ecommerce_app_database.* TO 'mysqluser'@'%';
FLUSH PRIVILEGES;
```

### 3) Redis Setup
Start Redis locally on port `6379` with password `mypass`.
- Ensure clients can connect to `127.0.0.1:6379` and that `requirepass mypass` is set.

    Steps (Windows):
    1) Download and extract Redis for Windows: [Redis for Windows releases](https://github.com/tporadowski/redis/releases)
    - Example path: `C:\redis`

    2) Quick start (PowerShell):
    ```
    cd C:\redis
    ./redis-server.exe --port 6379 --requirepass mypass
    ```

    3) Optional: install and run as a Windows service (uses config file):
    ```
    cd D:\project_workspace\test\spring-boot-react-ecommerce-app\Redis-x64-5.0.14.1
    # edit .\redis.windows.conf and ensure:
    #   port 6379
    #   requirepass mypass
    ./redis-server.exe --service-install .\redis.windows.conf --service-name Redis
    ./redis-server.exe --service-start --service-name Redis
    ```

    4) Verify connection:
    ```
    cd C:\redis
    ./redis-cli.exe -a mypass ping
    # Expect: PONG
    ```

    5) Verify data inside redis
      ./redis-cli.exe -a mypass
      inside redis shell
        127.0.0.1:6379> DBSIZE
        127.0.0.1:6379> KEYS *
        127.0.0.1:6379> GET somekey
        127.0.0.1:6379> INFO

### 4) Backend Services (PowerShell)
Run each service in its own PowerShell window from the project root.

Common environment values (run in EACH PowerShell window before starting a service):
```
$env:DB_HOST="localhost"; $env:DB_PORT="3306"; $env:DB_USER="mysqluser"; $env:DB_PASS="mypass"; $env:DB_SCHEMA="ecommerce_app_database"; $env:ACTIVE_PROFILE="dev"
```

4.1) Authentication Service (port 7000)
```
cd server\authentication-service
$env:PORT="7000"
$env:JAVA_HOME="C:\Users\shriv\.jdks\openjdk-24.0.2"
$env:JAVA_HOME="C:\Program Files\Java\jdk-11.0.16"
.\mvnw.cmd spring-boot:run
```

4.2) Common Data Service (port 9000)
```
cd server\common-data-service
$env:PORT="9000"; $env:REDIS_HOST="localhost"; $env:REDIS_PORT="6379"; $env:REDIS_PASSWORD="mypass"; $env:REACT_CLIENT_URL="http://localhost:3000"
$env:JAVA_HOME="C:\Program Files\Java\jdk-11.0.16"
.\mvnw.cmd spring-boot:run
```

4.3) Payment Service (port 9050)
```
cd server\payment-service
$env:PORT="9050"
$env:JAVA_HOME="C:\Program Files\Java\jdk-11.0.16"
.\mvnw.cmd spring-boot:run
```

4.4) Search Suggestion Service (port 10000)
```
cd server\search-suggestion-service
$env:PORT="10000"; $env:COMMON_DATA_SERVICE_URL="http://localhost:9000"; $env:ACTIVE_PROFILE="dev"
$env:JAVA_HOME="C:\Program Files\Java\jdk-11.0.16"
.\mvnw.cmd spring-boot:run
```

Notes:
- Keep each window open; services must stay running.
- If your MySQL/Redis credentials differ, update the env vars accordingly.

### 5) Frontend (React)
In a new PowerShell window:
```
cd client
copy .env-sample .env
```
Edit `.env` to include the local ports and dev mode (example):
```
REACT_APP_ENVIRONMENT=dev

REACT_APP_AUTHENTICATION_SERVICE_PORT=7000
REACT_APP_COMMON_DATA_SERVICE_PORT=9000
REACT_APP_PAYMENT_SERVICE_PORT=9050
REACT_APP_SEARCH_SUGGESTION_SERVICE_PORT=10000

# Optional (overrides the PORT-based URLs above)
# REACT_APP_AUTHENTICATION_SERVICE_URL=http://localhost:7000
# REACT_APP_COMMON_DATA_SERVICE_URL=http://localhost:9000
# REACT_APP_PAYMENT_SERVICE_URL=http://localhost:9050
# REACT_APP_SEARCH_SUGGESTION_SERVICE_URL=http://localhost:10000
```
Install dependencies and start the dev server:
```
npm install
npm run start_dev
or 
npx env-cmd -f .env react-scripts start
```

### 6) Verify
- UI: `http://localhost:3000`
- Backend health (examples):
  - Common Data Service: `http://localhost:9000/actuator/health`

### 7) Ports Summary
- React UI: 3000
- Authentication: 7000
- Common Data: 9000
- Payment: 9050
- Search Suggestion: 10000
- MySQL: 3306
- Redis: 6379

### 8) Troubleshooting
- If CORS errors occur, ensure `REACT_CLIENT_URL` is set to `http://localhost:3000` for the Common Data Service window.
- Verify MySQL credentials and that the database exists.
- Ensure Redis is running and password matches `REDIS_PASSWORD`.

