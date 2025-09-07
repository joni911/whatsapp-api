# WhatsApp REST API

REST API wrapper for the [whatsapp-web.js](https://github.com/pedroslopez/whatsapp-web.js) library, providing an easy-to-use interface to interact with the WhatsApp Web platform. 
It is designed to be used as a docker container, scalable, secure, and easy to integrate with other non-NodeJs projects.

This project is a work in progress: star it, create issues, features or pull requests ❣️

**NOTE**: I can't guarantee you will not be blocked by using this method, although it has worked for me. WhatsApp does not allow bots or unofficial clients on their platform, so this shouldn't be considered totally safe.

## Table of Contents

[1. Quick Start with Docker](#quick-start-with-docker)

[2. Features](#features)

[3. Run Locally](#run-locally)

[4. Testing](#testing)

[5. Documentation](#documentation)

[6. Deploy to Production](#deploy-to-production)

[7. Contributing](#contributing)

[8. License](#license)

[9. Star History](#star-history)

## Quick Start with Docker

[![dockeri.co](https://dockerico.blankenship.io/image/chrishubert/whatsapp-web-api)](https://hub.docker.com/r/chrishubert/whatsapp-web-api)

1. Clone the repository:

```bash
git clone https://github.com/chrishubert/whatsapp-api.git
cd whatsapp-api
```

3. Run the Docker Compose:

```bash
docker-compose pull && docker-compose up
```
4. Visit http://localhost:3000/session/start/ABCD

5. Scan the QR on your console using WhatsApp mobile app -> Linked Device -> Link a Device (it may take time to setup the session)

6. Visit http://localhost:3000/client/getContacts/ABCD

7. EXTRA: Look at all the callbacks data in `./session/message_log.txt`

![Quick Start](./assets/basic_start.gif)

## Features

1. API and Callbacks

| Actions                      | Status | Sessions                                | Status | Callbacks                                      | Status |
| ----------------------------| ------| ----------------------------------------| ------| ----------------------------------------------| ------|
| Send Image Message           | ✅     | Initiate session                       | ✅    | Callback QR code                               | ✅     |
| Send Video Message           | ✅     | Terminate session                      | ✅    | Callback new message                           | ✅     |
| Send Audio Message           | ✅     | Terminate inactive sessions            | ✅    | Callback status change                         | ✅     |
| Send Document Message        | ✅     | Terminate all sessions                 | ✅    | Callback message media attachment              | ✅     |
| Send File URL                | ✅     | Healthcheck                            | ✅    |                                                |        |
| Send Button Message          | ✅     | Local test callback                    |        |                                                |        |
| Send Contact Message         | ✅     |                                        |        |                                                |        |
| Send List Message            | ✅     |                                        |        |                                                |        |
| Set Status                   | ✅     |                                        |        |                                                |        |
| Send Button With Media       | ✅     |                                        |        |                                                |        |
| Is On Whatsapp?              | ✅     |                                        |        |                                                |        |
| Download Profile Pic         | ✅     |                                        |        |                                                |        |
| User Status                  | ✅     |                                        |        |                                                |        |
| Block/Unblock User           | ✅     |                                        |        |                                                |        |
| Update Profile Picture       | ✅     |                                        |        |                                                |        |
| Create Group                 | ✅     |                                        |        |                                                |        |
| Leave Group                  | ✅     |                                        |        |                                                |        |
| All Groups                   | ✅     |                                        |        |                                                |        |
| Invite User                  | ✅     |                                        |        |                                                |        |
| Make Admin                   | ✅     |                                        |        |                                                |        |
| Demote Admin                 | ✅     |                                        |        |                                                |        |
| Group Invite Code            | ✅     |                                        |        |                                                |        |
| Update Group Participants    | ✅     |                                        |        |                                                |        |
| Update Group Setting         | ✅     |                                        |        |                                                |        |
| Update Group Subject         | ✅     |                                        |        |                                                |        |
| Update Group Description     | ✅     |                                        |        |                                                |        |

3. Handle multiple client sessions (session data saved locally), identified by unique id

4. All endpoints may be secured by a global API key

5. On server start, all existing sessions are restored

6. Set messages automatically as read

7. Disable any of the callbacks

## Run Locally

1. Clone the repository:

```bash
git clone https://github.com/chrishubert/whatsapp-api.git
cd whatsapp-api
```

2. Install the dependencies:

```bash
npm install
```

3. Copy the `.env.example` file to `.env` and update the required environment variables:

```bash
cp .env.example .env
```

4. Run the application:

```bash
npm run start
```

5. Access the API at `http://localhost:3000`

## Testing

Run the test suite with the following command:

```bash
npm run test
```

## Documentation

API documentation can be found in the [`swagger.json`](https://raw.githubusercontent.com/chrishubert/whatsapp-api/master/swagger.json) file. See this file directly into [Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/chrishubert/whatsapp-api/master/swagger.json) or any other OpenAPI-compatible tool to view and interact with the API documentation.

This documentation is straightforward if you are familiar with whatsapp-web.js library (https://docs.wwebjs.dev/)
If you are still confused - open an issue and I'll improve it.

Also, there is an option to run the documentation endpoint locally by setting the `ENABLE_SWAGGER_ENDPOINT` environment variable. Restart the service and go to `/api-docs` endpoint to see it.

By default, all callback events are delivered to the webhook defined with the `BASE_WEBHOOK_URL` environment variable.
This can be overridden by setting the `*_WEBHOOK_URL` environment variable, where `*` is your sessionId.
For example, if you have the sessionId defined as `DEMO`, the environment variable must be `DEMO_WEBHOOK_URL`.

By setting the `DISABLED_CALLBACKS` environment variable you can specify what events you are **not** willing to receive on your webhook.

### Scanning QR code

In order to validate a new WhatsApp Web instance you need to scan the QR code using your mobile phone. Official documentation can be found at (https://faq.whatsapp.com/1079327266110265/?cms_platform=android) page. The service itself delivers the QR code content as a webhook event or you can use the REST endpoints (`/session/qr/:sessionId` or `/session/qr/:sessionId/image` to get the QR code as a png image). 

## Deploy to Production

This section covers different ways to deploy the WhatsApp API to a production server.

### Option 1: Using Docker (Recommended)

1. Pull and run the latest Docker image:
   ```bash
   docker-compose pull && docker-compose up -d
   ```

2. Configure the environment variables in `docker-compose.yml`:
   ```yaml
   environment:
     - API_KEY=your_secure_api_key_here  # REQUIRED for production
     - BASE_WEBHOOK_URL=https://yourdomain.com/webhook  # REQUIRED - your webhook endpoint
     - ENABLE_LOCAL_CALLBACK_EXAMPLE=FALSE  # DISABLE for production
     - MAX_ATTACHMENT_SIZE=10000000  # Adjust as needed
     - SET_MESSAGES_AS_SEEN=TRUE  # Optional
     - DISABLED_CALLBACKS=message_ack|message_reaction  # Optional
     - ENABLE_SWAGGER_ENDPOINT=FALSE  # Optional, disable in production
   ```

3. Ensure the `sessions` volume is properly mapped for persistent storage:
   ```yaml
   volumes:
     - ./sessions:/usr/src/app/sessions
   ```

### Option 2: Running Directly on Server

1. Install Node.js (version 14.17.0 or higher):
   ```bash
   # Ubuntu/Debian
   curl -fsSL https://deb.nodesource.com/setup_16.x | sudo -E bash -
   sudo apt-get install -y nodejs

   # CentOS/RHEL
   curl -fsSL https://rpm.nodesource.com/setup_16.x | sudo bash -
   sudo yum install -y nodejs
   ```

2. Install Chromium dependencies:
   ```bash
   # Ubuntu/Debian
   sudo apt-get install -y chromium-browser

   # CentOS/RHEL
   sudo yum install -y chromium
   ```

3. Clone the repository and install dependencies:
   ```bash
   git clone https://github.com/chrishubert/whatsapp-api.git
   cd whatsapp-api
   npm install --only=production
   ```

4. Configure environment variables by copying `.env.example` to `.env`:
   ```bash
   cp .env.example .env
   ```

5. Edit the `.env` file with your configuration:
   ```bash
   PORT=3000
   API_KEY=your_secure_api_key_here
   BASE_WEBHOOK_URL=https://yourdomain.com/webhook
   ENABLE_LOCAL_CALLBACK_EXAMPLE=FALSE
   ```

6. Start the application:
   ```bash
   npm start
   ```

7. For production, use a process manager like PM2:
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

### Server Configuration Requirements

- **Operating System**: Linux (Ubuntu 18.04+, CentOS 7+, etc.) or Windows Server
- **Node.js**: Version 14.17.0 or higher
- **Memory**: Minimum 1GB RAM (2GB+ recommended)
- **Storage**: Minimum 500MB free disk space
- **Browser**: Chromium/Chrome (automatically installed with Docker)

### Environment Variables

| Variable | Description | Required | Default |
|----------|-------------|----------|---------|
| `PORT` | Port for the API to listen on | No | 3000 |
| `API_KEY` | Global API key to protect endpoints | Yes (recommended) | - |
| `BASE_WEBHOOK_URL` | URL to receive webhook events | Yes | - |
| `ENABLE_LOCAL_CALLBACK_EXAMPLE` | Enable local callback example endpoint | No | FALSE |
| `MAX_ATTACHMENT_SIZE` | Maximum attachment size in bytes | No | 10000000 |
| `SET_MESSAGES_AS_SEEN` | Automatically mark messages as read | No | TRUE |
| `DISABLED_CALLBACKS` | Callbacks to disable (separated by \|) | No | - |
| `ENABLE_SWAGGER_ENDPOINT` | Enable Swagger documentation endpoint | No | FALSE |
| `SESSIONS_PATH` | Path to store session data | No | ./sessions |

### Security Considerations

1. Always set a strong `API_KEY` in production
2. Disable `ENABLE_LOCAL_CALLBACK_EXAMPLE` in production
3. Use HTTPS for your webhook endpoints
4. Restrict access to the API using firewalls
5. Regularly update the Docker image or application code
6. Monitor logs for suspicious activity

### Session Management

Sessions are stored in the `./sessions` directory by default. For production:

1. Ensure this directory is backed up regularly
2. Monitor disk space usage
3. Clean up old sessions using the `/session/terminateInactive` endpoint
4. Use a cron job to periodically clean up inactive sessions

### Monitoring and Maintenance

1. Set up log rotation for application logs
2. Monitor disk space for session storage
3. Set up health checks using the `/ping` endpoint
4. Regularly check for updates to the Docker image
5. Monitor for WhatsApp Web version compatibility issues

### Troubleshooting

1. **QR Code Not Generating**: Ensure the server can access the internet and WhatsApp servers
2. **Session Not Connecting**: Check firewall settings and ensure ports are not blocked
3. **Memory Issues**: Increase server memory or limit concurrent sessions
4. **Webhook Not Receiving**: Verify the `BASE_WEBHOOK_URL` is accessible from the internet
5. **Performance Issues**: Monitor CPU and memory usage, consider scaling horizontally

### Scaling

For handling multiple WhatsApp accounts:

1. Run multiple instances with different ports
2. Use a load balancer to distribute requests
3. Ensure each instance has its own session storage directory
4. Consider using Kubernetes for orchestration

## Contributing

Please read [CONTRIBUTING.md](./CONTRIBUTING.md) for details on our code of conduct, and the process for submitting pull requests to us.

## Disclaimer

This project is not affiliated, associated, authorized, endorsed by, or in any way officially connected with WhatsApp or any of its subsidiaries or its affiliates. The official WhatsApp website can be found at https://whatsapp.com. "WhatsApp" as well as related names, marks, emblems and images are registered trademarks of their respective owners.

## License

This project is licensed under the MIT License - see the [LICENSE.md](./LICENSE.md) file for details.

## Star History

[![Star History Chart](https://api.star-history.com/svg?repos=chrishubert/whatsapp-api&type=Date)](https://star-history.com/#chrishubert/whatsapp-api&Date)
