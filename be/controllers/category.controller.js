const { categoryModel } = require("../models/category.model");
const { productModel } = require("../models/product.model");
const { productVariantModel } = require("../models/product.variants.model");

exports.GetListCategory = async (req, res, next) => {
  let dataRes = { msg: "OK", data: null };

  try {
    const categories = await categoryModel
      .find({ deleteAt: null })
      .sort({ createdAt: -1 });

    dataRes.data = categories.map((category) => ({
      ...category._doc,
      imageCategory: `${req.protocol}://${req.get("host")}/images/categories/${category.imageCategory}`,
    }));
  } catch (error) {
    dataRes.msg = error.message;
  }

  res.json(dataRes);
};

exports.GetListCategoryInStock = async (req, res, next) => {
  let dataRes = { msg: "OK", data: null };

  try {
    // Lấy product_id từ variant còn hàng
    const productIds = await productVariantModel.distinct("productId", {
      quantity: { $gt: 0 },
      deleteAt: null,
    });

    if (!productIds.length) {
      dataRes.msg = "No categories found";
      dataRes.data = [];
    } else {
      // Lấy category_id từ product còn tồn tại
      const categoryIds = await productModel.distinct("categoryId", {
        _id: { $in: productIds },
        deleteAt: null,
      });

      if (!categoryIds.length) {
        dataRes.msg = "No categories found";
        dataRes.data = [];
      } else {
        // Lấy category chưa bị xoá
        const categories = await categoryModel
          .find({
            _id: { $in: categoryIds },
            deleteAt: null,
          })
          .sort({ createdAt: -1 });

        dataRes.data = categories.map((category) => ({
          ...category._doc,
          imageCategory: `${req.protocol}://${req.get("host")}/images/categories/${category.imageCategory}`,
        }));
      }
    }
  } catch (error) {
    dataRes.msg = error.message;
  }

  res.json(dataRes);
};
