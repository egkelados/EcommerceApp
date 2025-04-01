const bcrypt = require("bcryptjs");
const { body, validationResult } = require("express-validator");
const jwt = require("jsonwebtoken");
const models = require("../models");
const { Op } = require("sequelize");

exports.login = async (req, res) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      const msg = errors
        .array()
        .map((e) => e.msg)
        .join(", ");
      return res.status(422).json({ success: false, message: msg });
    }

    const { username, password } = req.body;
    console.log(username, password); // log the username and password

    // check if the user exists

    const user = await models.User.findOne({
      where: {
        username: { [Op.iLike]: username }, // insensitive search
      },
    });

    if (!user) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid username or password" });
    }

    // if the user exists, check if the password is correct
    const isPasswordValid = await bcrypt.compare(password, user.password);

    if (!isPasswordValid) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid username or password" });
    }

    //generate JWT token

    const token = jwt.sign({ userId: user.id }, "SECRETKEY", {
      expiresIn: "1h",
    });

    return res.status(200).json({
      userId: user.id,
      username: user.username,
      token: token,
      success: true,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};

/// Register
exports.register = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const mes = errors
      .array()
      .map((e) => e.msg)
      .join(", ");
    return res.status(422).json({ success: false, message: mes });
  }

  try {
    const { username, password } = req.body;

    const existingUser = await models.User.findOne({
      where: {
        username: { [Op.iLike]: username },
      },
    });

    if (existingUser) {
      return res.json({ success: false, message: "Username already exists" });
    }

    //create a password hash
    const salt = await bcrypt.genSalt(10);
    const hash = await bcrypt.hash(password, salt);

    //create a new user
    const _ = await models.User.create({
      username: username,
      password: hash,
    });

    res.status(201).json({ success: true });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};
