const bcrypt = require("bcryptjs");
const { body, validationResult } = require("express-validator");
const models = require("../models");
const { Op } = require("sequelize");

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
    const _ = models.User.create({
      username: username,
      password: hash,
    });

    res.status(201).json({ success: true });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};
