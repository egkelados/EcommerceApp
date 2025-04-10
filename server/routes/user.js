const express = require("express");
const body = require("express-validator").body;
const router = express.Router();
const userController = require("../controllers/userController");

const updateUserInfoValidator = [
  body("first_name", "First name cannot be empty!").not().isEmpty(),
  body("last_name", "Last name cannot be empty!").not().isEmpty(),
  body("street", "Street cannot be empty!").not().isEmpty(),
  body("city", "City cannot be empty!").not().isEmpty(),
  body("state", "State cannot be empty!").not().isEmpty(),
  body("country", "Country cannot be empty!").not().isEmpty(),
  body("zip_code", "Zip code cannot be empty!").not().isEmpty(),
];

// get user info
router.get("/", userController.loadUserInfo);
// update user info
router.put("/", updateUserInfoValidator, userController.updateUserInfo);

module.exports = router;
