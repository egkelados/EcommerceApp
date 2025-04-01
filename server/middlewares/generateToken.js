const jwt = require("jsonwebtoken");

const token = jwt.sign({ userId: 9999 }, "SECRETKEY", { expiresIn: "1h" });
console.log("Generated token: -> ", token);
