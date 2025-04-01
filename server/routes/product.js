const express = require("express");
const router = express.Router();
const productController = require("../controllers/productController");
const { body, param } = require("express-validator");
const authenticate = require("../middlewares/authMiddleware");

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

const updateProductValidator = [
  param("productId")
    .notEmpty()
    .withMessage("productId cannot be empty!")
    .isNumeric()
    .withMessage("productId must be a number"),

  body("name", "name cannot be empty!").not().isEmpty(),
  body("description", "description cannot be empty!").not().isEmpty(),
  body("price", "price cannot be empty!").not().isEmpty(),
  body("photo_url").notEmpty().withMessage("photo_url cannot be empty!"),
  body("user_id")
    .notEmpty()
    .withMessage("user_id cannot be empty!")
    .isNumeric()
    .withMessage("user_id must be a number"),
];

// api/products
router.get("/", productController.getAllProducts);
router.post("/", productValidator, productController.create);
router.get("/user/:user_id", authenticate, productController.getMyProducts);
router.post("/uploads", productController.upload);

//DELETE /api/products/34
router.delete(
  "/:productId",
  deleteProductValidator,
  productController.deleteProduct
);
// update the whole product with PUT , PATCH is for partial update
// PUT  /api/products/34
router.put(
  "/:productId",
  updateProductValidator,
  productController.updateProduct
);
module.exports = router;
