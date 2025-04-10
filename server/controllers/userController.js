const models = require("../models");
const { validationResult } = require("express-validator");

exports.loadUserInfo = async (req, res) => {
  try {
    // check if the user is valid
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      const msg = errors
        .array()
        .map((e) => e.msg)
        .join(", ");
      return res.status(422).json({ success: false, message: msg });
    }

    // const userId = 22; // uncomment for testing purpose via curl command or postman
    const userId = req.userId; // Assuming you have userId in the request
    console.log(userId);
    // Fetch user information
    const user = await models.User.findByPk(userId, {
      attributes: [
        "id",
        "username",
        "first_name",
        "last_name",
        "street",
        "city",
        "state",
        "country",
        "zip_code",
      ],
    });
    console.log(user);
    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }
    return res.status(200).json({
      success: true,
      message: "User information loaded successfully",
      user,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "An error occurred while loading user information",
    });
  }
};

exports.updateUserInfo = async (req, res) => {
  try {
    console.log(req.body);
    // const userId = 22; // uncomment for testing purpose
    const userId = req.userId; // Assuming you have userId in the request

    const { first_name, last_name, street, city, state, country, zip_code } =
      req.body;
    console.log(req.body);

    // Check if the user exists
    const user = await models.User.findByPk(userId, {
      attributes: [
        "id",
        "username",
        "first_name",
        "last_name",
        "street",
        "city",
        "state",
        "country",
        "zip_code",
      ],
    });

    if (!user) {
      return res.status(404).json({
        success: false,
        message: "User not found",
      });
    }

    // Update user information
    await user.update({
      first_name,
      last_name,
      street,
      city,
      state,
      country,
      zip_code,
    });

    return res.status(200).json({
      success: true,
      message: "User information updated successfully",
      user,
    });
  } catch (error) {
    console.error(error);
    res.status(500).json({
      success: false,
      message: "An error occured while updating the user",
    });
  }
};
