const db = require("../configs/db");

const productSchema = new db.mongoose.Schema(
  {
    categoryId: {
      type: db.mongoose.Schema.Types.ObjectId,
      ref: "categoryModel",
      required: true,
    },
    productCode: { type: String, required: true, unique: true },
    productName: { type: String, required: true },
    description: { type: String },
    deleteAt: { type: Date, default: null },
  },
  { collection: "products", timestamps: true },
);

const productModel = db.mongoose.model("productModel", productSchema);
module.exports = { productModel };
