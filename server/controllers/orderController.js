const models = require("../models");

exports.createOrder = async (req, res) => {
  const userId = 22; // dummy userId for testing
  //   const userId = req.userId;

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

    //update cart status to be active = false

    // clear cart items from the cart items table

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
