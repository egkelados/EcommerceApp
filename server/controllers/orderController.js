const models = require("../models");
const cartController = require("./cartController");

exports.createOrder = async (req, res) => {
  const userId = req.userId;

  const { total, order_items } = req.body;

  //start transaction
  const transaction = await models.sequelize.transaction();

  try {
    //   create new order
    const newOrder = await models.Order.create(
      {
        user_id: userId,
        total: total,
      },
      { transaction } // ensure the order is created in the transaction
    );

    //   create order items
    const orderItemsData = order_items.map((item) => ({
      order_id: newOrder.id,
      product_id: item.product_id,
      quantity: item.quantity,
      price: item.price,
    }));
    await models.OrderItem.bulkCreate(orderItemsData, {
      transaction,
    });

    //get the active cart for the user
    const cart = await models.Cart.findOne({
      where: {
        user_id: userId,
        is_active: true,
      },
      attributes: ["id"],
    });

    // Only update cart if it exists
    if (cart) {
      //update cart status to be active = false
      await cartController.updateCartStatus(cart.id, false, transaction);

      // clear cart items from the cart items table
      await cartController.removeCartItems(cart.id, transaction);
    }

    // commit the transaction
    await transaction.commit();

    return res.status(201).json({
      success: true,
      order: newOrder,
      message: "Order created successfully",
    });
  } catch (error) {
    console.log(error);
    await transaction.rollback();
    return res
      .status(500)
      .json({ success: false, message: "Internal server error" });
  }
};
