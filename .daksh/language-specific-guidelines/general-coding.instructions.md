---
applyTo: "**"
---

## Lookup files
- if the user query is related to React and TypeScript, look for `.github/instructions/react-typescript.instructions.md` file in the repository and apply those coding instructions.
- if the user query is related to Python, look for `.github/instructions/python.instructions.md` file in the repository and apply those coding instructions.
- if the user query is related to documentation writing, look for `.github/instructions/doc-gen.instructions.md` file in the repository and apply those coding instructions.

## 1. Tech stacks details
<---- Specify the technologies and frameworks used in the project to help Copilot generate relevant code suggestions. ----->

### Example Tech Stacks:
- **Frontend**: React, Next.js, Angular, Vue.js
- **Backend**: Node.js, Express, Django, Flask, Spring Boot
- **Database**: PostgreSQL, MySQL, MongoDB, Firebase
- **DevOps**: Docker, Kubernetes, AWS, Azure, CI/CD
- **Testing**: Jest, Mocha, Cypress, Playwright

----------------------------------------------------------------------------------------------------------------

## 2. Project-Specific Keywords
<------ Add relevant project-specific keywords here to help Copilot understand the context better.----------->

### Example Keywords:
- **User Management**: authentication, authorization, role-based access, user profiles
- **E-commerce**: cart, checkout, payment gateway, product listings
- **Healthcare**: patient records, appointments, prescriptions
- **Finance**: transactions, budgeting, reporting, analytics
- **AI/ML**: dataset processing, model training, inference

----------------------------------------------------------------------------------------------------------------

## 3. Handling Third-Party Libraries
If you introduce any third-party libraries that were not previously installed in the project, or if you believe additional dependencies are required, provide the necessary installation commands.

### Example:
```sh
npm install <library-name>
yarn add <library-name>
```

----------------------------------------------------------------------------------------------------------------

## 4. Validations for Required Fields
Ensure that all required fields have proper validation checks.

### Example (JavaScript Validation):
```js
if (!inputField) {
    throw new Error("Input field is required.");
}
```

### Example (React Form Validation with Yup):
```js
import * as Yup from 'yup';

const validationSchema = Yup.object({
    name: Yup.string().required('Name is required'),
    email: Yup.string().email('Invalid email').required('Email is required'),
});
```
### Example (TypeScript Validation):

```ts
const validateInput = (inputField?: string): void => {
  if (!inputField?.trim()) {
    throw new Error("Input field is required.");
  }
};
```

### Example (React Form Validation with Yup & TypeScript):

```ts
import * as Yup from "yup";

export const validationSchema = Yup.object({
  name: Yup.string().trim().required("Name is required"),
  email: Yup.string()
    .trim()
    .email("Invalid email")
    .required("Email is required"),
});
```
----------------------------------------------------------------------------------------------------------------