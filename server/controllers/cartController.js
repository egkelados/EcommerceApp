const path = require("path");
const models = require("../models");
const { where } = require("sequelize");

exports.deleteCartItem = async (req, res) => {
  try {
    const { cartItemId } = req.params;
    console.log(cartItemId);
    //destroy the cart item by id
    const cartItem = await models.CartItem.destroy({
      where: {
        id: cartItemId,
      },
    });
    if (!cartItem) {
      return res
        .status(404)
        .json({ success: false, message: "Cart item not found" });
    }
    res.status(200).json({
      success: true,
      message: "Cart item deleted successfully",
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      message: "An error occurred while deleting the cart item",
    });
  }
};

exports.loadCart = async (req, res) => {
  try {
    // const userId = req.userId;
    // console.log(userId);

    const cart = await models.Cart.findOne({
      where: {
        user_id: 22,
        is_active: true,
      },
      attributes: ["id", "user_id", "is_active"],
      include: [
        {
          model: models.CartItem,
          as: "cartItems",
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
        },
      ],
    });

    return res.status(200).json({
      success: true,
      message: "Cart Items loaded successfully",
      cart: cart,
    });
  } catch (error) {
    console.log(error);
    res.status(500).json({
      success: false,
      message: "Internal server error, Can not load your cart Items",
    });
  }
};

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
