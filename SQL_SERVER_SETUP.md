# SQL Server 2022 Setup Guide

SQL Server 2022 is running in Docker for your GitHub Codespace development environment.

## Quick Start

### Check Status
```bash
./sql-server-manager.sh status
```

### Connection Details
- **Server**: `localhost,1433`
- **Username**: `sa`
- **Password**: `YourPassword@123`

## Manager Script Commands

```bash
# Show SQL Server status
./sql-server-manager.sh status

# Start SQL Server (creates container if needed)
./sql-server-manager.sh start

# Stop SQL Server
./sql-server-manager.sh stop

# Restart SQL Server
./sql-server-manager.sh restart

# View container logs
./sql-server-manager.sh logs

# Show connection details
./sql-server-manager.sh connect
```

## Connection Examples

### sqlcmd (Command Line)
```bash
sqlcmd -S localhost,1433 -U sa -P 'YourPassword@123'
```

### Node.js (mssql package)
```javascript
const sql = require('mssql');

const config = {
  server: 'localhost',
  port: 1433,
  authentication: {
    type: 'default',
    options: {
      userName: 'sa',
      password: 'YourPassword@123'
    }
  },
  options: {
    trustServerCertificate: true,
    enableKeepAlive: true
  }
};

sql.connect(config).then(pool => {
  console.log('Connected!');
}).catch(err => console.log(err));
```

### Python (pyodbc or pymssql)
```python
import pyodbc

conn = pyodbc.connect(
    'Driver={ODBC Driver 17 for SQL Server};'
    'Server=localhost,1433;'
    'UID=sa;'
    'PWD=YourPassword@123;'
    'TrustServerCertificate=yes'
)
cursor = conn.cursor()
cursor.execute("SELECT @@VERSION")
print(cursor.fetchone())
```

### C# (.NET)
```csharp
string connectionString = "Server=localhost,1433;User Id=sa;Password=YourPassword@123;Encrypt=true;TrustServerCertificate=true;";
using (SqlConnection connection = new SqlConnection(connectionString))
{
    connection.Open();
    // Your code here
}
```

## Persistent Data

To persist data between Codespace sessions, create a volume:

```bash
docker stop sqlserver
docker rm sqlserver
docker run -e 'ACCEPT_EULA=Y' -e 'SA_PASSWORD=YourPassword@123' \
  -p 1433:1433 --name sqlserver \
  -v sqlserver_data:/var/opt/mssql \
  -d mcr.microsoft.com/mssql/server:2022-latest
```

## Troubleshooting

### Check if container is running
```bash
docker ps | grep sqlserver
```

### View recent logs
```bash
docker logs sqlserver | tail -20
```

### Connection refused?
Wait a few seconds after starting, SQL Server takes time to initialize.

### Reset everything
```bash
docker stop sqlserver
docker rm sqlserver
./sql-server-manager.sh start
```
