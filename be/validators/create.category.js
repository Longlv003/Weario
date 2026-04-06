const { body } = require("express-validator");

const createCategoryValidator = [
  body("categoryCode")
    .trim()
    .notEmpty()
    .withMessage("categoryCode is required"),
  body("categoryName")
    .trim()
    .notEmpty()
    .withMessage("categoryName is required"),
];

module.exports = {
  createCategoryValidator,
};
