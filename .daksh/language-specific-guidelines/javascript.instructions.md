---
applyTo: "**/*.js"
---
### JavaScript and TypeScript Coding Conventions

#### General Principles
- **Consistency**: Consistent code is crucial for readability and maintenance.
- **Clarity**: Write code that is clear and easy to understand.
- **Simplicity**: Avoid complexity when simpler solutions exist.
- **Scalability**: Ensure that code is scalable and maintainable.

#### Formatting
- **Indentation**: Use 2 spaces for indentation. Do not use tabs.
- **Line Length**: Limit lines to 120 characters.
- **Semicolons**: Always use semicolons to terminate statements.
- **Braces**: Use braces for all control structures (e.g., if, else, for, while, try, catch), even if a block contains only a single statement.
- **Whitespace**: Use single blank lines to separate logical blocks of code. Use spaces around operators and after commas.

#### Naming Conventions
- **Variables and Functions**: Use camelCase for variable and function names.
- **Classes**: Use UpperCamelCase (PascalCase) for class names.
- **Constants**: Use CONSTANT_CASE for constant values.
- **Private Properties**: Prefix private properties and methods with an underscore (`_`).

#### Comments
- **Block Comments**: Use block comments (`/* ... */`) for longer explanations and documentation.
- **Line Comments**: Use line comments (`// ...`) for brief explanations and annotations.
- **JSDoc**: Use JSDoc for documenting functions, methods, classes, and modules.

### Common Best Practices
- **Use `let` and `const`**: Prefer `const` for variables that will not be reassigned, and `let` for variables that can be reassigned. Avoid using `var`.
- **Strict Mode**: Use JavaScript's strict mode (`'use strict';`) to enforce stricter parsing and error handling.
- **Arrow Functions**: Use arrow functions (`=>`) for anonymous functions, especially for callbacks.
- **Avoid Global Variables**: Minimize the use of global variables. Use IIFE (Immediately Invoked Function Expressions) or modules to encapsulate code.
- **Error Handling**: Always handle errors gracefully. Use `try...catch` for synchronous code and `.catch()` for Promises.
- **Testing**: Write unit tests for your code. Use frameworks like Jest.
- Use async/await for handling asynchronous operations.
- Avoid callback hell; use Promises or async/await instead.
- Prefer template literals over string concatenation.