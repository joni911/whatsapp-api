# Source Code Documentation

This document provides an overview of the source code structure and key components.

## Main Entry Point

- `app.js` - Main application file that sets up the Express server
- `server.js` - Server initialization and startup

## Core Components

- `config.js` - Configuration management
- `middleware.js` - Custom middleware functions
- `routes.js` - Route definitions
- `sessions.js` - Session management for WhatsApp clients
- `utils.js` - Utility functions used across the application

## Controllers

Each controller handles specific functionality of the API:

- `chatController.js` - Chat-related operations
- `clientController.js` - Client management operations
- `contactController.js` - Contact-related operations
- `groupChatController.js` - Group chat operations
- `healthController.js` - Health check endpoints
- `messageController.js` - Message sending and receiving operations
- `sessionController.js` - Session management operations

## Development Notes

When adding new functionality:
1. Create a new controller if needed
2. Add routes in `routes.js`
3. Implement business logic in the controller
4. Add utility functions to `utils.js` if they are reusable
5. Update session management in `sessions.js` if needed