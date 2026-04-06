const db = require("../configs/db");

const categorySchema = new db.mongoose.Schema(
  {
    categoryCode: { type: String, required: true, unique: true },
    categoryName: { type: String, required: true },
    imageCategory: { type: String },
    deleteAt: { type: Date, default: null },
  },
  { collection: "categories", timestamps: true },
);

const categoryModel = db.mongoose.model("categoryModel", categorySchema);
module.exports = { categoryModel };
