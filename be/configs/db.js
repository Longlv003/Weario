const mongoose = require("mongoose");
require("dotenv").config();

const connectDB = async () => {
  try {
    await mongoose.connect(process.env.MONGOOSE_URL);
    console.log("Database connected successfully");
  } catch (err) {
    console.log("Error connecting to database");
    console.log(err.message);
  }
};

connectDB();

module.exports = { mongoose };
