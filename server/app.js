const express = require("express");
const models = require("./models");
const { Op } = require("sequelize");
const bcrypt = require("bcryptjs");
const { body, validationResult } = require("express-validator");
const app = express();

// JSON parser
app.use(express.json()); // this is a middleware so the request will be parsed as JSON

const registerValidator = [
  body("username", "username cannot be emty!").not().isEmpty(),
  body("password", "password cannot be emty!").not().isEmpty(),
];

app.post("/register", registerValidator, async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const mes = errors
      .array()
      .map((e) => e.msg)
      .join(", ");
    return res.status(422).json({ success: false, errors: mes });
  }

  try {
    const { username, password } = req.body;

    const existingUser = await models.User.findOne({
      where: {
        username: { [Op.iLike]: username },
      },
    });

    if (existingUser) {
      return res.json({ success: false, errors: "Username already exists" });
    }

    //create a password hash
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);

    //create a new user
    const _ = models.User.create({
      username: username,
      password: hash,
    });

    res.status(201).json({ success: true });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, errors: "Internal server error" });
  }
});

//start the server
app.listen(8080, () => {
  console.log("Server is running at http://localhost:8080 ");
});
