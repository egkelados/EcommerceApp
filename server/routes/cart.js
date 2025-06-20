const express = require("express");
const router = express.Router();
const cartController = require("../controllers/cartController");
const { body, param } = require("express-validator");
const authenticate = require("../middlewares/authMiddleware");

router.post("/items", cartController.addItemToCart);

// api/cart/user
router.get("/user", cartController.loadCart);

// api/cart/item/:cartItemId
router.delete("/item/:cartItemId", cartController.deleteCartItem);

module.exports = router;
