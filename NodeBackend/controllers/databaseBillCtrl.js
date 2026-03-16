const { connectDB } = require("../db");
const { ObjectId } = require("mongodb");

async function getBills(req, res) {
  try {
    const db = await connectDB();
    const BillCol = db.collection("bills");
    const dataBills = await BillCol.find({}).toArray();
    return res.status(200).json({ dataBills });
  } catch (error) {
    console.error("không thể đăng nhập", error);
    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(401).json({ error: "không thể đăng nhập" });
  }
}

async function searchBills(req, res) {
  try {
    const keyword = req.query.q || "";
    const db = await connectDB();
    const BillCol = db.collection("bills");

    const dataBills = await BillCol.find({
      dienthoai: { $regex: keyword, $options: "i" },
    }).toArray();
    console.log(dataBills);
    res.status(200).json({ dataBills });
  } catch (error) {
    console.error("Lỗi tìm kiếm:", error);
    res
      .status(401)
      .json({ error: "Lỗi hoặc không tìm thấy hóa đơn với số điện thoại này" });
  }
}

async function deleteBill(req, res) {
  try {
    const idItem = req.query.id || "";
    console.log(idItem);
    const db = await connectDB();
    const BillCol = db.collection("bills");
    const result = await BillCol.deleteOne({ _id: new ObjectId(idItem) });
    if (result.deletedCount === 1) {
      res.status(200).json({ message: "Xóa hóa đơn thành công" });
    } else {
      return res
        .status(401)
        .json({ error: "Không tìm thấy hóa đơn với số điện thoại này" });
    }
  } catch (error) {
    console.error("Error delete medicin:", error);
    res
      .status(401)
      .json({ error: "Xóa hóa đơn thất bại vui lòng kiểm tra lại" });
  }
}

module.exports = {
  deleteBill,
  getBills,
  searchBills,
};
