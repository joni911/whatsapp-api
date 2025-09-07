# WhatsApp API Server Deployment Tutorial

This tutorial provides detailed instructions for deploying the WhatsApp API on a server for production use.

## Table of Contents

1. [Prerequisites](#prerequisites)
2. [Deployment Options](#deployment-options)
3. [Docker Deployment (Recommended)](#docker-deployment-recommended)
4. [Direct Server Deployment](#direct-server-deployment)
5. [Environment Configuration](#environment-configuration)
6. [Setting Up Webhooks](#setting-up-webhooks)
7. [Security Considerations](#security-considerations)
8. [Session Management](#session-management)
9. [Monitoring and Maintenance](#monitoring-and-maintenance)
10. [Troubleshooting](#troubleshooting)

## Prerequisites

Before deploying the WhatsApp API, ensure your server meets the following requirements:

- Operating System: Linux (Ubuntu 18.04+, CentOS 7+, etc.) or Windows Server
- Node.js: Version 14.17.0 or higher
- Docker & Docker Compose (for Docker deployment)
- At least 1GB RAM (2GB+ recommended)
- At least 500MB free disk space
- Internet access for WhatsApp Web connectivity
- A domain name with SSL certificate (recommended)

## Deployment Options

You have two main options for deploying the WhatsApp API:

1. **Docker Deployment** (Recommended): Uses pre-built Docker images for easy deployment and updates
2. **Direct Server Deployment**: Runs the application directly on the server OS

## Docker Deployment (Recommended)

### Step 1: Install Docker and Docker Compose

```bash
# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

### Step 2: Clone the Repository

```bash
git clone https://github.com/chrishubert/whatsapp-api.git
cd whatsapp-api
```

### Step 3: Configure Environment Variables

Edit the `docker-compose.yml` file to set your environment variables:

```yaml
version: '3.8'

services:
  app:
    container_name: whatsapp_web_api
    image: chrishubert/whatsapp-web-api:latest
    restart: always
    ports:
      - "3000:3000"
    environment:
      - API_KEY=your_secure_api_key_here  # REQUIRED - Generate a strong key
      - BASE_WEBHOOK_URL=https://yourdomain.com/webhook  # REQUIRED - Your webhook endpoint
      - ENABLE_LOCAL_CALLBACK_EXAMPLE=FALSE  # DISABLE for production
      - MAX_ATTACHMENT_SIZE=10000000  # 10MB limit
      - SET_MESSAGES_AS_SEEN=TRUE
      - DISABLED_CALLBACKS=message_ack|message_reaction
      - ENABLE_SWAGGER_ENDPOINT=FALSE  # Disable in production
    volumes:
      - ./sessions:/usr/src/app/sessions  # Persistent session storage
```

### Step 4: Start the Service

```bash
# Pull the latest image and start the service
docker-compose pull && docker-compose up -d

# Check if the service is running
docker-compose ps
```

### Step 5: Verify the Deployment

```bash
# Check logs
docker-compose logs -f

# Test the API
curl http://localhost:3000/ping
```

## Direct Server Deployment

### Step 1: Install Node.js

```bash
# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
sudo apt-get install -y nodejs

# CentOS/RHEL
curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
sudo yum install -y nodejs
```

### Step 2: Install Chromium Dependencies

```bash
# Ubuntu/Debian
sudo apt-get update
sudo apt-get install -y chromium-browser

# CentOS/RHEL
sudo yum install -y chromium
```

### Step 3: Clone and Install the Application

```bash
# Clone the repository
git clone https://github.com/chrishubert/whatsapp-api.git
cd whatsapp-api

# Install production dependencies
npm install --only=production
```

### Step 4: Configure Environment Variables

Copy the example environment file and edit it:

```bash
cp .env.example .env
```

Edit the `.env` file with your configuration:

```bash
PORT=3000
API_KEY=your_secure_api_key_here
BASE_WEBHOOK_URL=https://yourdomain.com/webhook
ENABLE_LOCAL_CALLBACK_EXAMPLE=FALSE
MAX_ATTACHMENT_SIZE=10000000
SET_MESSAGES_AS_SEEN=TRUE
DISABLED_CALLBACKS=message_ack|message_reaction
ENABLE_SWAGGER_ENDPOINT=FALSE
SESSIONS_PATH=./sessions
```

### Step 5: Start the Application

For development/testing:
```bash
npm start
```

For production, use PM2:
```bash
# Install PM2 globally
npm install -g pm2

# Start the application with PM2
pm2 start server.js --name whatsapp-api

# Save the PM2 configuration
pm2 save

# Set PM2 to start on boot
pm2 startup
```

## Environment Configuration

### Required Environment Variables

1. **API_KEY**: A strong secret key to protect your API endpoints
2. **BASE_WEBHOOK_URL**: The URL where webhook events will be sent

### Optional Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `PORT` | Port for the API to listen on | 3000 |
| `ENABLE_LOCAL_CALLBACK_EXAMPLE` | Enable local callback example endpoint | FALSE |
| `MAX_ATTACHMENT_SIZE` | Maximum attachment size in bytes | 10000000 |
| `SET_MESSAGES_AS_SEEN` | Automatically mark messages as read | TRUE |
| `DISABLED_CALLBACKS` | Callbacks to disable (separated by \|) | - |
| `ENABLE_SWAGGER_ENDPOINT` | Enable Swagger documentation endpoint | FALSE |
| `SESSIONS_PATH` | Path to store session data | ./sessions |
| `RATE_LIMIT_MAX` | Maximum requests per time window | 1000 |
| `RATE_LIMIT_WINDOW_MS` | Rate limiting time window in ms | 1000 |

### Generating a Secure API Key

```bash
# Generate a secure API key
openssl rand -base64 32
```

## Setting Up Webhooks

Webhooks are essential for receiving real-time events from WhatsApp. You need to provide a publicly accessible URL that can receive HTTP POST requests.

### Webhook Requirements

1. Must be HTTPS (recommended) or HTTP
2. Must accept POST requests
3. Should return HTTP 200 status for successful processing
4. Should handle various event types (qr, message, ready, etc.)

### Example Webhook Handler (Node.js/Express)

```javascript
app.post('/webhook', (req, res) => {
  const { dataType, data, sessionId } = req.body;
  
  switch(dataType) {
    case 'qr':
      // Handle QR code for authentication
      console.log(`QR code for session ${sessionId}:`, data.qr);
      break;
    case 'message':
      // Handle incoming messages
      console.log(`New message in session ${sessionId}:`, data.message);
      break;
    case 'ready':
      // Session is ready
      console.log(`Session ${sessionId} is ready`);
      break;
    default:
      console.log(`Event ${dataType} in session ${sessionId}:`, data);
  }
  
  res.status(200).send('OK');
});
```

## Security Considerations

1. **API Key Protection**: Always use a strong API key in production
2. **Disable Local Callback**: Set `ENABLE_LOCAL_CALLBACK_EXAMPLE=FALSE` in production
3. **HTTPS Only**: Use HTTPS for all endpoints
4. **Firewall Configuration**: Restrict access to necessary ports only
5. **Regular Updates**: Keep the application updated with latest security patches
6. **Session Security**: Protect session files from unauthorized access

### Example Firewall Configuration (UFW)

```bash
# Allow SSH
sudo ufw allow ssh

# Allow HTTP and HTTPS
sudo ufw allow http
sudo ufw allow https

# Allow specific port (if not using reverse proxy)
sudo ufw allow 3000

# Enable firewall
sudo ufw enable
```

## Session Management

Sessions are stored in the `./sessions` directory by default. Each WhatsApp session creates a subdirectory with authentication data.

### Managing Sessions

1. **Starting a Session**:
   ```
   GET /session/start/SESSION_ID
   ```

2. **Checking Session Status**:
   ```
   GET /session/status/SESSION_ID
   ```

3. **Getting QR Code**:
   ```
   GET /session/qr/SESSION_ID
   GET /session/qr/SESSION_ID/image
   ```

4. **Terminating Sessions**:
   ```
   GET /session/terminate/SESSION_ID
   GET /session/terminateInactive
   GET /session/terminateAll
   ```

### Session Best Practices

1. Use descriptive session IDs
2. Regularly clean up inactive sessions
3. Backup session data regularly
4. Monitor disk usage of session directory

## Monitoring and Maintenance

### Health Checks

Use the built-in ping endpoint for health checks:
```
GET /ping
```

Expected response:
```json
{
  "success": true,
  "message": "pong"
}
```

### Log Management

When running with Docker:
```bash
# View logs
docker-compose logs -f

# View specific service logs
docker-compose logs -f app
```

When running directly:
```bash
# If using PM2
pm2 logs whatsapp-api

# If running directly
tail -f sessions/message_log.txt
```

### Automated Maintenance

Set up cron jobs for regular maintenance:

```bash
# Add to crontab
crontab -e

# Daily cleanup of inactive sessions at 2 AM
0 2 * * * curl -X GET "http://localhost:3000/session/terminateInactive?apikey=YOUR_API_KEY"
```

## Troubleshooting

### Common Issues and Solutions

1. **QR Code Not Generating**
   - Check internet connectivity
   - Verify firewall settings
   - Ensure WhatsApp Web is accessible

2. **Session Not Connecting**
   - Check logs for authentication errors
   - Verify session ID is correct
   - Ensure session files have proper permissions

3. **Webhook Not Receiving Events**
   - Verify BASE_WEBHOOK_URL is accessible
   - Check webhook server logs
   - Ensure webhook returns HTTP 200

4. **Memory Issues**
   - Monitor RAM usage
   - Restart service if memory leaks occur
   - Consider upgrading server resources

5. **Performance Problems**
   - Monitor CPU usage
   - Limit concurrent sessions
   - Optimize webhook processing

### Checking Logs

Docker:
```bash
docker-compose logs -f --tail 100
```

Direct installation:
```bash
# With PM2
pm2 logs whatsapp-api --lines 100

# Direct logs
tail -f sessions/message_log.txt
```

### Restarting the Service

Docker:
```bash
docker-compose restart
```

Direct installation:
```bash
# With PM2
pm2 restart whatsapp-api

# Without PM2
npm start
```

## Conclusion

This tutorial covered the essential steps for deploying the WhatsApp API on a server. For production use, always follow security best practices, monitor your service regularly, and keep the application updated.