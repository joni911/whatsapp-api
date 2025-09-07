#!/bin/bash

# WhatsApp API Management Script
# This script helps manage the WhatsApp API service

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if running on Windows or Linux
IS_WINDOWS=false
if [[ "$OSTYPE" == "msys" ]] || [[ "$OSTYPE" == "win32" ]]; then
    IS_WINDOWS=true
fi

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if Docker is installed
check_docker() {
    if command_exists docker; then
        print_success "Docker is installed"
        return 0
    else
        print_error "Docker is not installed"
        return 1
    fi
}

# Function to check if Docker Compose is installed
check_docker_compose() {
    if command_exists docker-compose; then
        print_success "Docker Compose is installed"
        return 0
    else
        print_error "Docker Compose is not installed"
        return 1
    fi
}

# Function to check if Node.js is installed
check_node() {
    if command_exists node; then
        NODE_VERSION=$(node --version)
        print_success "Node.js $NODE_VERSION is installed"
        return 0
    else
        print_error "Node.js is not installed"
        return 1
    fi
}

# Function to check if PM2 is installed
check_pm2() {
    if command_exists pm2; then
        PM2_VERSION=$(pm2 --version)
        print_success "PM2 $PM2_VERSION is installed"
        return 0
    else
        print_warning "PM2 is not installed (recommended for production)"
        return 1
    fi
}

# Function to start the service with Docker
start_docker() {
    print_status "Starting WhatsApp API with Docker..."
    
    if ! check_docker || ! check_docker_compose; then
        print_error "Docker or Docker Compose is not installed. Cannot start with Docker."
        return 1
    fi
    
    if [ -f "docker-compose.yml" ]; then
        docker-compose pull
        docker-compose up -d
        if [ $? -eq 0 ]; then
            print_success "WhatsApp API started successfully with Docker"
            print_status "Service is running on port 3000"
            docker-compose ps
        else
            print_error "Failed to start WhatsApp API with Docker"
            return 1
        fi
    else
        print_error "docker-compose.yml not found"
        return 1
    fi
}

# Function to stop the Docker service
stop_docker() {
    print_status "Stopping WhatsApp API Docker service..."
    
    if [ -f "docker-compose.yml" ]; then
        docker-compose down
        if [ $? -eq 0 ]; then
            print_success "WhatsApp API Docker service stopped successfully"
        else
            print_error "Failed to stop WhatsApp API Docker service"
            return 1
        fi
    else
        print_error "docker-compose.yml not found"
        return 1
    fi
}

# Function to view Docker logs
logs_docker() {
    print_status "Viewing Docker logs..."
    
    if [ -f "docker-compose.yml" ]; then
        docker-compose logs -f
    else
        print_error "docker-compose.yml not found"
        return 1
    fi
}

# Function to start the service directly
start_direct() {
    print_status "Starting WhatsApp API directly..."
    
    if ! check_node; then
        print_error "Node.js is not installed. Cannot start service directly."
        return 1
    fi
    
    if [ -f "server.js" ]; then
        if command_exists pm2; then
            pm2 start server.js --name whatsapp-api
            if [ $? -eq 0 ]; then
                print_success "WhatsApp API started successfully with PM2"
                pm2 list
            else
                print_error "Failed to start WhatsApp API with PM2"
                return 1
            fi
        else
            print_warning "PM2 not found, starting with Node.js directly (not recommended for production)"
            node server.js &
            if [ $? -eq 0 ]; then
                print_success "WhatsApp API started successfully with Node.js"
            else
                print_error "Failed to start WhatsApp API with Node.js"
                return 1
            fi
        fi
    else
        print_error "server.js not found"
        return 1
    fi
}

# Function to stop the direct service
stop_direct() {
    print_status "Stopping WhatsApp API direct service..."
    
    if command_exists pm2; then
        pm2 stop whatsapp-api
        if [ $? -eq 0 ]; then
            print_success "WhatsApp API stopped successfully with PM2"
        else
            print_error "Failed to stop WhatsApp API with PM2"
            return 1
        fi
    else
        print_error "PM2 not found. If you started the service directly with Node.js, you'll need to kill the process manually."
        return 1
    fi
}

# Function to view direct logs
logs_direct() {
    print_status "Viewing direct logs..."
    
    if command_exists pm2; then
        pm2 logs whatsapp-api
    else
        print_error "PM2 not found. Checking for log files..."
        if [ -f "sessions/message_log.txt" ]; then
            tail -f sessions/message_log.txt
        else
            print_error "No log files found"
            return 1
        fi
    fi
}

# Function to check service status
status() {
    print_status "Checking service status..."
    
    # Check Docker status
    if command_exists docker && command_exists docker-compose; then
        if [ -f "docker-compose.yml" ]; then
            print_status "Docker service status:"
            docker-compose ps
        fi
    fi
    
    # Check direct service status
    if command_exists pm2; then
        print_status "PM2 service status:"
        pm2 list
    fi
    
    # Check if port 3000 is in use
    if [ "$IS_WINDOWS" = true ]; then
        netstat -an | findstr :3000 > /dev/null
    else
        netstat -tuln | grep :3000 > /dev/null
    fi
    
    if [ $? -eq 0 ]; then
        print_success "Service appears to be running on port 3000"
    else
        print_warning "No service found running on port 3000"
    fi
}

# Function to restart the service
restart() {
    print_status "Restarting service..."
    
    # Try Docker first
    if command_exists docker && command_exists docker-compose && [ -f "docker-compose.yml" ]; then
        stop_docker
        sleep 3
        start_docker
    elif command_exists pm2; then
        stop_direct
        sleep 3
        start_direct
    else
        print_error "No service management method found"
        return 1
    fi
}

# Function to show help
show_help() {
    echo "WhatsApp API Management Script"
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  start     Start the WhatsApp API service"
    echo "  stop      Stop the WhatsApp API service"
    echo "  restart   Restart the WhatsApp API service"
    echo "  status    Check the service status"
    echo "  logs      View service logs"
    echo "  check     Check system requirements"
    echo "  help      Show this help message"
    echo ""
    echo "Examples:"
    echo "  $0 start    Start the service"
    echo "  $0 logs     View logs"
    echo "  $0 status   Check service status"
}

# Function to check system requirements
check_requirements() {
    print_status "Checking system requirements..."
    
    check_node
    check_docker
    check_docker_compose
    check_pm2
    
    print_status "Checking for required files..."
    
    if [ -f ".env.example" ]; then
        print_success ".env.example found"
    else
        print_warning ".env.example not found"
    fi
    
    if [ -f "docker-compose.yml" ]; then
        print_success "docker-compose.yml found"
    else
        print_warning "docker-compose.yml not found"
    fi
    
    if [ -f "server.js" ]; then
        print_success "server.js found"
    else
        print_error "server.js not found"
    fi
    
    print_status "Checking directory permissions..."
    
    if [ -w "." ]; then
        print_success "Current directory is writable"
    else
        print_error "Current directory is not writable"
    fi
    
    if [ -d "sessions" ]; then
        if [ -w "sessions" ]; then
            print_success "sessions directory is writable"
        else
            print_error "sessions directory is not writable"
        fi
    else
        print_warning "sessions directory not found (will be created on first run)"
    fi
}

# Main script logic
case "$1" in
    start)
        if [ "$2" = "docker" ]; then
            start_docker
        elif [ "$2" = "direct" ]; then
            start_direct
        else
            # Default to Docker if available, otherwise direct
            if command_exists docker && command_exists docker-compose && [ -f "docker-compose.yml" ]; then
                start_docker
            elif command_exists node && [ -f "server.js" ]; then
                start_direct
            else
                print_error "No suitable method found to start the service"
                exit 1
            fi
        fi
        ;;
    stop)
        if [ "$2" = "docker" ]; then
            stop_docker
        elif [ "$2" = "direct" ]; then
            stop_direct
        else
            # Try to detect which method was used
            if command_exists docker && command_exists docker-compose && [ -f "docker-compose.yml" ]; then
                stop_docker
            elif command_exists pm2; then
                stop_direct
            else
                print_error "No suitable method found to stop the service"
                exit 1
            fi
        fi
        ;;
    logs)
        if [ "$2" = "docker" ]; then
            logs_docker
        elif [ "$2" = "direct" ]; then
            logs_direct
        else
            # Try to detect which method was used
            if command_exists docker && command_exists docker-compose && [ -f "docker-compose.yml" ]; then
                logs_docker
            elif command_exists pm2 || [ -f "sessions/message_log.txt" ]; then
                logs_direct
            else
                print_error "No suitable method found to view logs"
                exit 1
            fi
        fi
        ;;
    restart)
        restart
        ;;
    status)
        status
        ;;
    check)
        check_requirements
        ;;
    help)
        show_help
        ;;
    *)
        show_help
        ;;
esac