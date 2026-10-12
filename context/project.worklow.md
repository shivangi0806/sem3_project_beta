# Project Feature Workflow

This document defines the implementation workflow and naming conventions for features in the Athlete Performance Tracker project. Follow it alongside `project.spec.md` and `project.architecture.md`.

## Backend (Node.js, Express, Mongoose)

Implement each feature in this order:

1. **Evaluate the API and data requirements.** Confirm the request/response contract, validation rules, authorization needs, and expected error cases before implementation.
2. **Create the Mongoose model.** The model represents the entity stored in the database.
3. **Create the service.** Put business logic in a file named `[featurename].service.js`.
4. **Create the route.** Put HTTP route handlers in `[feature-name].routes.js` and add Swagger documentation for every route. Swagger operation names, summaries, schemas, parameters, responses, and errors must accurately match the implemented route and its API contract.
5. **Register the route.** If it is not already registered, integrate it in `index.js`.
6. **Test the integrated route.** Cover all four outcome categories:
   - **True positive:** valid input and authorized request succeed as expected.
   - **True negative:** invalid input or unauthorized request is rejected as expected.
   - **False positive:** confirm invalid input or an unauthorized request cannot be accepted accidentally.
   - **False negative:** confirm valid input or an authorized request is not rejected accidentally.

### Backend naming

Use the pattern `[featurename].[specific component].js`, with the feature name and component matching the file's responsibility. Examples include:

- `session.model.js`
- `session.service.js`
- `session.routes.js`
- `session.config.js`
- `session.seed.js`

Use the established repository naming style when it differs, and keep names consistent across a feature.

## Frontend (Flutter)

Implement each feature in this order:

1. **Evaluate the backend route first.** Read its implementation and Swagger/API documentation. Confirm its URL, method, authentication, request fields, response shape, and error behavior before creating a Flutter service.
2. **Create a data model.** Define the model for data returned by or transmitted through the service.
3. **Create the service.** The service makes the API call and returns raw data as `Map<String, dynamic>` or `List<String, dynamic>`. Do not use or construct the feature model directly in the service.
4. **Create the Cubit and states.** The Cubit calls the service, converts the returned map/list into the model, and emits the feature's declared states. Keep model parsing and state transitions in this layer.
5. **Add a Provider only when needed** for dependency injection or shared state wiring.
6. **Build the UI components.** Screens and components consume the Cubit's states and present loading, success, empty, and error cases.

### Frontend naming

Use the pattern `[ScreenName]_[FeatureName]_[Component].dart` for screen and UI component files. Choose names that identify the screen, feature, and component clearly, and keep related files consistent.

## Feature completion checklist

- Backend behavior and API contract are evaluated before Flutter service work begins.
- The Mongoose model, service, documented route, and route registration are complete where applicable.
- Swagger documentation accurately describes the implemented route.
- Integrated backend tests cover true positive, true negative, false positive, and false negative cases.
- Flutter has a data model, raw-data service, Cubit/state handling, and UI; the service does not use the model directly.
- Provider is added only if needed.
- UI covers loading, success, empty, and error states.
