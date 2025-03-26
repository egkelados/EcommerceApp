# **Definition of router.post("/login", loginValidator, authController.login);**

1. router.post("/login", ...):
   This tells Express: "When a client makes a POST request to the '/login' endpoint, handle it using the following functions."

2. loginValidator:
   This is a middleware function (or an array of middleware functions) that runs before the main controller. It checks the incoming request for required data (like ensuring that username and password are not empty). If any of these checks fail, it can stop the request from proceeding further and send back an error response. Think of it as a gatekeeper that ensures the request is valid before any business logic is executed.

3. authController.login:
   This is the main route handler function. It contains the logic to process the login request, such as checking if the user exists, validating the password, and generating a JWT token if the credentials are correct.

### How Does the Request Reach the Controller Function?

- Incoming Request:
  When a client sends a POST request to /login, Express first finds the route that matches this path and HTTP method.

- Middleware Chain Execution:
  Express then executes the functions listed in the order they were added.

      * First, it runs loginValidator, which inspects the request data.

      * If loginValidator calls next() (which it will do if validation passes), Express moves on to the next function in the list.

- Calling the Controller:
  Finally, Express calls authController.login. When it does so, it automatically passes the request (req), response (res), and optionally a next function as arguments:

```sh
authController.login(req, res, next);
```

This is how the controller gets access to the request data submitted by the client. The controller then processes this data—by, for example, looking up the user in the database—and sends back the appropriate response.

Summary

- router.post: Registers a POST endpoint.

- Endpoint String ("/login"): Specifies where the client sends the request.

- Validator Middleware (loginValidator): Checks and validates the incoming request data.

- Controller Function (authController.login): Contains the business logic and automatically receives the request and response objects from Express when the route is triggered.

In essence, the whole process is like a relay race where the request is handed over from one function (validator) to the next (controller) until it gets processed and a response is sent back to the client.

In Express, every middleware function is automatically provided with three parameters: req, res, and next. The next function is a callback that, when invoked, passes control to the next middleware or route handler in the chain.

Even if you don't see next explicitly defined in your code (for example, within the express-validator middleware functions), it's still being used under the hood. When loginValidator runs, it processes the request and, if everything is valid, it calls next() to signal that Express should move on to the next function—in this case, authController.login.

In summary:

- next() is provided by Express to each middleware.

- It ensures that after one middleware completes its task (or validation), the request is forwarded to the next function in the sequence.

- If next() isn't called (for example, if an error is encountered and the middleware sends a response immediately), the following middleware or route handler will not run.

This design keeps the middleware modular and organized, allowing each piece to focus on a specific task before handing off the request to the next function in line.

# Req and Res objects

The req and res objects are created by Express when a client makes an HTTP request. Here's how it works:

1.  Client Request:
    When a client (like a browser or a mobile app) sends a request to your server (e.g., a POST request to /login), Express intercepts this request.

2.  Creating Request and Response Objects:
    Express automatically creates two objects:

        * req (request): Contains all the details about the incoming request—such as headers, body data, parameters, and more.

        * res (response): Provides methods to send back a response to the client, like res.send(), res.json(), etc.

3) Passing to Middleware/Route Handlers:
   When the route is matched (e.g., for /login), Express calls the middleware chain in order. It passes these req and res objects as arguments to every middleware function and finally to the controller function:

```sh
authController.login(req, res, next);
```

This means you don't have to manually provide these objects; Express handles that automatically.

In short, req and res are provided by Express as part of its core functionality whenever a route is triggered, ensuring that your controller functions always have access to the necessary request data and response methods.
