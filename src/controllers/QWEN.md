# Controllers Documentation

This directory contains all the controllers that handle the business logic for different parts of the API.

## Controller Overview

- `chatController.js` - Handles chat-related operations
- `clientController.js` - Manages WhatsApp client instances
- `contactController.js` - Handles contact-related operations
- `groupChatController.js` - Manages group chat operations
- `healthController.js` - Provides health check endpoints
- `messageController.js` - Handles message sending and receiving
- `sessionController.js` - Manages user sessions with WhatsApp

## Common Patterns

All controllers follow a similar pattern:
1. Export functions that match the route handlers
2. Receive req, res, next parameters
3. Use async/await for asynchronous operations
4. Handle errors appropriately
5. Return JSON responses

## Adding New Controllers

When adding a new controller:
1. Create a new file with the naming pattern `[feature]Controller.js`
2. Follow the existing code style
3. Export functions that handle specific routes
4. Add error handling
5. Document the controller in this file