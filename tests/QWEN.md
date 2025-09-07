# Testing Documentation

This directory contains the test files for the WhatsApp API project.

## Test Structure

- `api.test.js` - Main test file containing API endpoint tests

## Testing Framework

The project uses Jest as the testing framework. Tests are organized by feature and API endpoint.

## Running Tests

To run all tests:
```bash
npm test
```

To run tests in watch mode:
```bash
npm run test:watch
```

## Writing Tests

When adding new tests:

1. Group related tests in `describe` blocks
2. Use clear test descriptions that explain what is being tested
3. Follow the AAA pattern (Arrange, Act, Assert)
4. Mock external dependencies when necessary
5. Test both success and error cases

## Test Environment

Tests use a separate test database and environment variables defined in `.env.test`.

## Code Coverage

To generate a code coverage report:
```bash
npm run test:coverage
```