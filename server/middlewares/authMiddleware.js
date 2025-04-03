const jwt = require("jsonwebtoken");
const models = require("../models");

const authenticate = async (req, res, next) => {
  //get the authorization header
  const authHeader = req.headers["authorization"];
  //check if the authorization header is present
  if (!authHeader) {
    return res
      .status(401)
      .json({ success: false, message: "No token provided" });
  }

  const token = authHeader.split(" ")[1];
  //check if the token is valid
  if (!token) {
    return res
      .status(401)
      .json({ success: false, message: "Imnvalid token format" });
  }

  try {
    //verify the token
    const decoded = jwt.verify(token, "SECRETKEY");
    console.log(decoded);

    const user = await models.User.findByPk(decoded.userId);
    if (!user) {
      return res
        .status(401)
        .json({ success: false, message: "Invalid token for this user" });
    }

    req.userId = user.id;
    next();
  } catch (error) {
    console.log(error);
    return res.status(401).json({ success: false, message: "Invalid token" });
  }
};

module.exports = authenticate;
