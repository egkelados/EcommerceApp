const express = require("express");
const models = require("./models");
const { Op } = require("sequelize");
const bcrypt = require("bcryptjs");
const app = express();
const authRoutes = require("./routes/auth");
const productRoutes = require("./routes/product");
const cartRoutes = require("./routes/cart");
const userRoutes = require("./routes/user");
const authenticate = require("./middlewares/authMiddleware");
const orderRoutes = require("./routes/order");

app.use("/api/uploads", express.static("uploads")); // serve the iploads folder as static files

// JSON parser
app.use(express.json()); // this is a middleware so the request will be parsed as JSON

// register the routes
// auth routes
app.use("/api/auth", authRoutes);
// product routes
app.use("/api/products", productRoutes);
// cart routes
app.use("/api/cart", authenticate, cartRoutes);
// user routes
app.use("/api/user", authenticate, userRoutes);
// order routes
app.use("/api/orders", authenticate, orderRoutes);

//start the server
app.listen(8080, () => {
  console.log("Server is running at http://localhost:8080 ");
});

app.get("/ping", (req, res) => {
  res.send("pong");
});
