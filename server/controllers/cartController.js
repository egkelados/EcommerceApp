const path = require("path");
const models = require("../models");
const { where } = require("sequelize");

exports.addItemToCart = async (req, res) => {
  const { productId, quantity } = req.body;

  req.userId = 22;

  try {
    //get the cart by user id is_active: true
    const cart = await models.Cart.findOne({
      where: {
        user_id: req.userId,
        is_active: true,
      },
    });

    if (!cart) {
      //create a new cart
      cart = await models.Cart.create({
        user_id: req.userId,
        is_active: true,
      });
    }

    // add item to the cart
    const [cartItem, created] = await models.CartItem.findOrCreate({
      where: {
        cart_id: cart.id,
        product_id: productId,
      },
      defaults: {
        quantity: quantity,
      },
    });

    if (!created) {
      //if the item already exists in the cart, update the quantity
      cartItem.quantity += quantity;
      await cartItem.save();
    }

    //get cartItem with product
    const cartItemWithProduct = await models.CartItem.findOne({
      where: {
        id: cartItem.id,
      },
      attributes: ["id", "cart_id", "product_id", "quantity"],
      include: [
        {
          model: models.Product,
          as: "product",
          attributes: [
            "id",
            "name",
            "description",
            "price",
            "photo_url",
            "user_id",
          ],
        },
      ],
    });

    res.status(201).json({
      success: true,
      message: "Item added to cart",
      cartItem: cartItemWithProduct,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({ success: false, message: "Internal server error" });
  }
};
