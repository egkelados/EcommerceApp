const { validationResult } = require("express-validator");
const models = require("../models");

exports.getAllProducts = async (req, res) => {
  const products = await models.Product.findAll();
  res.json(products);
};

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
