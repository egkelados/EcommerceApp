"use strict";

module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn("Users", "first_name", {
      type: Sequelize.STRING,
      allowNull: true, // Change to false if you want it to be required.
    });
    await queryInterface.addColumn("Users", "last_name", {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn("Users", "street", {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn("Users", "city", {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn("Users", "state", {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn("Users", "country", {
      type: Sequelize.STRING,
      allowNull: true,
    });
    await queryInterface.addColumn("Users", "zip_code", {
      type: Sequelize.STRING,
      allowNull: true, // Change as needed
    });
  },

  async down(queryInterface, Sequelize) {
    await queryInterface.removeColumn("Users", "first_name");
    await queryInterface.removeColumn("Users", "last_name");
    await queryInterface.removeColumn("Users", "street");
    await queryInterface.removeColumn("Users", "city");
    await queryInterface.removeColumn("Users", "state");
    await queryInterface.removeColumn("Users", "country");
    await queryInterface.removeColumn("Users", "zip_code");
  },
};
