const express = require("express");
const router = express.Router();
const productController = require("../controllers/productController");
const { body, param } = require("express-validator");

const productValidator = [
  body("name", "name cannot be empty!").not().isEmpty(),
  body("description", "description cannot be empty!").not().isEmpty(),
  body("price", "price cannot be empty!").not().isEmpty(),
  body("photo_url").notEmpty().withMessage("photo_url cannot be empty!"),
];

const deleteProductValidator = [
  param("productId")
    .notEmpty()
    .withMessage("productId cannot be empty!")
    .isNumeric()
    .withMessage("productId must be a number"),
];

// api/products
router.get("/", productController.getAllProducts);
router.post("/", productValidator, productController.create);
router.get("/user/:user_id", productController.getMyProducts);
router.post("/uploads", productController.upload);

//Delete /api/products/34
router.delete(
  "/:productId",
  deleteProductValidator,
  productController.deleteProduct
);
module.exports = router;
