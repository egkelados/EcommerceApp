const { validationResult } = require("express-validator");
const multer = require("multer");
const path = require("path");
const models = require("../models");
const { getFileNameFromUrl, deleteFile } = require("../Utils/fileUtils");
const { where } = require("sequelize");
const { use } = require("../routes/auth");

// configure multer for file storage

const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, "uploads/");
  },
  filename: function (req, file, cb) {
    const ext = path.extname(file.originalname);
    cb(null, file.fieldname + "-" + Date.now() + ext);
  },
});

//setting up multer for image upload
const uploadImage = multer({
  storage: storage,
  limits: {
    fileSize: 1024 * 1024 * 5, // 5MB
  },
  fileFilter: function (req, file, cb) {
    const fileTypes = /jpeg|jpg|png/;
    const extname = fileTypes.test(
      path.extname(file.originalname).toLowerCase()
    );
    const mimetype = fileTypes.test(file.mimetype);

    if (mimetype && extname) {
      return cb(null, true);
    } else {
      cb(new Error("Only images are allowed"));
    }
  },
}).single("image");

//upload image
exports.upload = async (req, res) => {
  uploadImage(req, res, (err) => {
    if (err) {
      return res.status(400).json({ success: false, message: err.message });
    }
    if (!req.file) {
      return res
        .status(400)
        .json({ success: false, message: "Please select an image" });
    }
    const baseUrl = `${req.protocol}://${req.get("host")}`; // http://localhost:8080 construct the base URL
    const filePath = `/api/uploads/${req.file.filename}`; // http://localhost:8080/api/uploads/filename
    const fileUrl = `${baseUrl}${filePath}`;
    res.json({ success: true, url: fileUrl, message: "Image uploaded" });
  });
};

//get all products
exports.getAllProducts = async (req, res) => {
  const products = await models.Product.findAll();
  res.json(products);
};

// get my products
// /api/products/user/6
exports.getMyProducts = async (req, res) => {
  try {
    const userId = req.params.user_id;
    const products = await models.Product.findAll({
      where: {
        user_id: userId,
      },
    });

    res.json(products);
  } catch (error) {
    console.log(error);
    res
      .status(500)
      .json({ success: false, message: "Error retrieving products" });
  }
};

//create product
exports.create = async (req, res) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    const msg = errors
      .array()
      .map((e) => e.msg)
      .join(", ");
    return res.status(422).json({ success: false, message: msg });
  }

  const { name, description, price, photo_url, user_id } = req.body;

  console.log(req.body);

  try {
    const newProduct = await models.Product.create({
      name: name,
      description: description,
      price: price,
      photo_url: photo_url,
      user_id: user_id,
    });

    res
      .status(201)
      .json({ success: true, product: newProduct, message: "Product created" });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};

exports.deleteProduct = async (req, res) => {
  const errors = validationResult(req);

  if (!errors.isEmpty()) {
    const msg = errors
      .array()
      .map((e) => e.msg)
      .join(", ");
    return res.status(422).json({ success: false, message: msg });
  }

  const productId = req.params.productId;
  try {
    const product = await models.Product.findByPk(productId);
    if (!product) {
      return res
        .status(404)
        .json({ success: false, message: "Product not found" });
    }

    const fileName = getFileNameFromUrl(product.photo_url);

    // delete the product
    const result = await models.Product.destroy({
      where: {
        id: productId,
      },
    });

    if (result == 0) {
      return res
        .status(404)
        .json({ success: false, message: "Product not found" });
    }

    //delete file

    await deleteFile(fileName);

    return res.status(200).json({
      success: true,
      message: `Product with ID ${productId} deleted succesfully`,
    });
  } catch (err) {
    return res.status(500).json({
      success: false,
      message: `Error deleting product ${err.message}`,
    });
  }
};

//Update product

exports.updateProduct = async (req, res) => {
  const errors = validationResult(req);
  if (!errors.isEmpty()) {
    const msg = errors
      .array()
      .map((e) => e.msg)
      .join(", ");
    return res.status(422).json({ success: false, message: msg });
  }
  try {
    const { name, description, price, photo_url, user_id } = req.body;
    const { productId } = req.params;

    const product = await models.Product.findOne({
      where: {
        id: productId,
        user_id: user_id,
      },
    });

    if (!product) {
      return res
        .status(404)
        .json({ success: false, message: "Product not found" });
    }

    product.update({
      name,
      description,
      price,
      photo_url,
      user_id,
    });

    return res.status(200).json({
      success: true,
      message: `Product with ID ${productId} updated successfully`,
      product,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      message: "An error occured while updating the product",
    });
  }
};
