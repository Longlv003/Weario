const db = require("../configs/db");

const productVariantSchema = new db.mongoose.Schema(
  {
    sku: { type: String, required: true, unique: true },
    productId: {
      type: db.mongoose.Schema.Types.ObjectId,
      required: true,
      ref: "productModel",
    },
    size: { type: String },
    quantity: { type: Number, default: 0, min: 0 },
    price: { type: Number, default: 0, min: 0 },
    imageProductVariant: { type: String },
    deleteAt: { type: Date, default: null },
  },
  { collection: "product_variants", timestamps: true },
);

const productVariantModel = db.mongoose.model(
  "productVariantModel",
  productVariantSchema,
);
module.exports = { productVariantModel };
