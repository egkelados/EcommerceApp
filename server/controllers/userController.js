const models = require("../models");

exports.updateUserInfo = async (req, res) => {
  try {
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
