# Qwen Code - WhatsApp API Project

This document contains information and guidelines for working with the WhatsApp API project.

## Project Overview

This is a WhatsApp API built with Node.js that allows interaction with WhatsApp through a web interface. The project uses Puppeteer to control a WhatsApp Web instance.

## Project Structure

```
.
├── .github/
│   └── workflows/
├── assets/
├── src/
│   ├── controllers/
│   │   ├── chatController.js
│   │   ├── clientController.js
│   │   ├── contactController.js
│   │   ├── groupChatController.js
│   │   ├── healthController.js
│   │   ├── messageController.js
│   │   └── sessionController.js
│   ├── app.js
│   ├── config.js
│   ├── middleware.js
│   ├── routes.js
│   ├── sessions.js
│   └── utils.js
├── tests/
│   └── api.test.js
├── server.js
├── swagger.js
├── swagger.json
└── ...
```

## Setup Instructions

1. Clone the repository
2. Install dependencies: `npm install`
3. Copy `.env.example` to `.env` and configure the environment variables
4. Run the server: `npm start`

## Development Guidelines

- Follow the existing code style
- Add tests for new functionality
- Update documentation when making changes
- Use meaningful commit messages

## Common Tasks

### Starting the Server
```bash
npm start
```

### Running Tests
```bash
npm test
```

### Linting
```bash
npm run lint
```

## API Documentation

API documentation is available through Swagger at `/api-docs` when the server is running.

## Contributing

Please see [CONTRIBUTING.md](CONTRIBUTING.md) for information on how to contribute to this project.