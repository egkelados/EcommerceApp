const express = require("express");
const models = require("./models");
const { Op } = require("sequelize");
const bcrypt = require("bcryptjs");
const app = express();
const authRoutes = require("./routes/auth");

// JSON parser
app.use(express.json()); // this is a middleware so the request will be parsed as JSON

// register the routes
app.use("/api/auth", authRoutes);

//start the server
app.listen(8080, () => {
  console.log("Server is running at http://localhost:8080 ");
});
