"use strict";
const { Model } = require("sequelize");
module.exports = (sequelize, DataTypes) => {
  class Cart extends Model {
    /**
     * Helper method for defining associations.
     * This method is not a part of Sequelize lifecycle.
     * The `models/index` file will call this method automatically.
     */
    static associate(models) {
      // define association here
      Cart.hasMany(models.CartItem, {
        foreignKey: "cart_id",
        as: "cartItems", // cart.cartItems
      });

      // Cart.belongsTo(models.User, {
      //   foreignKey: "user_id",
      //   as: "user", // cart.user
      // });
    }
  }
  Cart.init(
    {
      user_id: DataTypes.INTEGER,
      is_active: DataTypes.BOOLEAN,
    },
    {
      sequelize,
      modelName: "Cart",
    }
  );
  return Cart;
};
