const { productModel } = require("../models/product.model");
const { productVariantModel } = require("../models/product.variants.model");

exports.GetListProductInStock = async (req, res, next) => {
  let dataRes = { msg: "OK" };
  try {
    // Lấy danh sách sản phẩm chưa xóa
    const products = await productModel.find({ deleteAt: null });

    // Lấy thống kê quantity và min/max price từ product variants chưa xóa
    const variantStats = await productVariantModel.aggregate([
      { $match: { deleteAt: null } },
      {
        $group: {
          _id: "$productId",
          totalQuantity: { $sum: "$quantity" },
          minPrice: { $min: "$price" },
          maxPrice: { $max: "$price" },
        },
      },
    ]);

    // Lấy variant đầu tiên (chưa xóa) của mỗi product để lấy image
    const productIds = products.map((p) => p._id);
    const firstVariants = await productVariantModel
      .find({
        productId: { $in: productIds },
        deleteAt: null,
      })
      .sort({ _id: 1 });

    const variantMap = {};
    firstVariants.forEach((v) => {
      const pid = v.productId.toString();
      if (!variantMap[pid]) variantMap[pid] = v;
    });

    // Chuyển mảng aggregate thành object map cho dễ lookup
    const statsMap = {};
    variantStats.forEach((v) => {
      statsMap[v._id.toString()] = {
        totalQuantity: v.totalQuantity,
        minPrice: v.minPrice,
        maxPrice: v.maxPrice,
      };
    });

    // Gắn quantity, min/max price, image vào từng product và loại bỏ product hết hàng
    const result = products
      .map((p) => {
        const stats = statsMap[p._id.toString()] || {};
        const variant = variantMap[p._id.toString()];
        return {
          ...p.toObject(),
          quantity: stats.totalQuantity || 0,
          minPrice: stats.minPrice || 0,
          maxPrice: stats.maxPrice || 0,
          image: variant ? variant.image : null,
        };
      })
      .filter((p) => p.quantity > 0); // Loại bỏ sản phẩm hết hàng

    dataRes.msg = "Product List";
    dataRes.data = result;
  } catch (error) {
    dataRes.data = null;
    dataRes.msg = error.message;
  }

  res.json(dataRes);
};

exports.GetProductDetail = async (req, res, next) => {
  let dataRes = { msg: "OK", data: null };

  try {
    const { _id } = req.params;

    if (!_id) {
      dataRes.msg = "Missing productId";
      return res.json(dataRes);
    }

    // 1. Lấy product
    const product = await productModel.findOne({
      _id: _id,
      deleteAt: null,
    });

    if (!product) {
      dataRes.msg = "Product not found";
      return res.json(dataRes);
    }

    // 2. Lấy tất cả variants chưa xóa và còn quantity
    const variants = await productVariantModel
      .find({
        productId: _id,
        deleteAt: null,
        quantity: { $gt: 0 },
      })
      .sort({ _id: 1 });

    dataRes.data = {
      ...product.toObject(),
      variants,
    };
  } catch (error) {
    dataRes.msg = error.message;
    dataRes.data = null;
  }

  res.json(dataRes);
};

exports.GetListProduct = async (req, res, next) => {
  let dataRes = { msg: "OK", data: [] };

  try {
    // 1. Lấy product chưa xóa
    const products = await productModel.find({ deleteAt: null });

    // 2. Lấy toàn bộ variants chưa xóa
    const variants = await productVariantModel.find({
      deleteAt: null,
      quantity: { $gt: 0 },
    });

    // 3. Gom variants theo productId
    const variantMap = {};
    variants.forEach((v) => {
      const pid = v.productId.toString();
      if (!variantMap[pid]) variantMap[pid] = [];
      variantMap[pid].push(v);
    });

    // 4. Tính stats (quantity, min/max price)
    const statsMap = {};
    variants.forEach((v) => {
      const pid = v.productId.toString();

      if (!statsMap[pid]) {
        statsMap[pid] = {
          totalQuantity: 0,
          minPrice: v.price,
          maxPrice: v.price,
        };
      }

      statsMap[pid].totalQuantity += v.quantity;
      statsMap[pid].minPrice = Math.min(statsMap[pid].minPrice, v.price);
      statsMap[pid].maxPrice = Math.max(statsMap[pid].maxPrice, v.price);
    });

    // 5. Map ra kết quả
    const result = products
      .map((p) => {
        const pid = p._id.toString();
        const productVariants = variantMap[pid] || [];
        const stats = statsMap[pid] || {};

        return {
          ...p.toObject(),
          variants: productVariants,
          quantity: stats.totalQuantity || 0,
          minPrice: stats.minPrice || 0,
          maxPrice: stats.maxPrice || 0,
        };
      })
      .filter((p) => p.quantity > 0); // bỏ sản phẩm hết hàng

    dataRes.msg = "Product list";
    dataRes.data = result;
  } catch (error) {
    dataRes.msg = error.message;
    dataRes.data = [];
  }

  return res.json(dataRes);
};
