const express = require("express");
const router = express.Router();
const { body } = require("express-validator");
const authController = require("../controllers/authController");

const registerValidator = [
  body("username", "username cannot be emty!").not().isEmpty(),
  body("password", "password cannot be emty!").not().isEmpty(),
];

router.post("/register", registerValidator, authController.register);

module.exports = router;
