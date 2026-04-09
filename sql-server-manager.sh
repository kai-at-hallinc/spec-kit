#!/bin/bash

# SQL Server Docker Container Manager
# Usage: ./sql-server-manager.sh [start|stop|restart|status|logs|connect]

CONTAINER_NAME="sqlserver"
IMAGE="mcr.microsoft.com/mssql/server:2022-latest"
SA_PASSWORD="YourPassword@123"
PORT="1433"

case "${1:-status}" in
  start)
    echo "Starting SQL Server container..."
    docker start "$CONTAINER_NAME" 2>/dev/null || {
      echo "Container not found. Creating new container..."
      docker run -e "ACCEPT_EULA=Y" -e "SA_PASSWORD=$SA_PASSWORD" \
        -p "$PORT:1433" --name "$CONTAINER_NAME" -d "$IMAGE"
    }
    echo "SQL Server started. Waiting for readiness..."
    sleep 5
    echo "✓ SQL Server is ready on localhost:$PORT"
    ;;
  
  stop)
    echo "Stopping SQL Server container..."
    docker stop "$CONTAINER_NAME"
    echo "✓ SQL Server stopped"
    ;;
  
  restart)
    echo "Restarting SQL Server container..."
    docker restart "$CONTAINER_NAME"
    echo "Waiting for readiness..."
    sleep 5
    echo "✓ SQL Server restarted"
    ;;
  
  status)
    if docker ps | grep -q "$CONTAINER_NAME"; then
      echo "✓ SQL Server is RUNNING on localhost:$PORT"
      docker ps | grep "$CONTAINER_NAME"
    else
      echo "✗ SQL Server is NOT running"
      docker ps -a | grep "$CONTAINER_NAME" || echo "  (Container not found)"
    fi
    ;;
  
  logs)
    echo "Showing SQL Server logs..."
    docker logs -f "$CONTAINER_NAME"
    ;;
  
  connect)
    echo "Connection details:"
    echo "  Server: localhost,1433"
    echo "  Username: sa"
    echo "  Password: $SA_PASSWORD"
    echo ""
    echo "Example connection strings:"
    echo "  sqlcmd: sqlcmd -S localhost,1433 -U sa -P '$SA_PASSWORD'"
    echo "  Node.js: mssql://sa:$SA_PASSWORD@localhost:1433"
    echo "  Python: pyodbc.connect('Driver={ODBC Driver 17 for SQL Server};Server=localhost,1433;UID=sa;PWD=$SA_PASSWORD')"
    ;;
  
  *)
    echo "SQL Server Container Manager"
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start       - Start SQL Server container"
    echo "  stop        - Stop SQL Server container"
    echo "  restart     - Restart SQL Server container"
    echo "  status      - Show container status (default)"
    echo "  logs        - Show container logs"
    echo "  connect     - Show connection details"
    ;;
esac
