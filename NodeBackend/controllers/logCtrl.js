const { connectDB } = require("../db");
const jwt = require("jsonwebtoken");
const bcrypt = require("bcrypt");
require("dotenv").config(); // Import dotenv để sử dụng biến môi trường
const SECRET_KEY = process.env.SECRET_KEY;

async function userLog(req, res) {
  try {
    const { phone, password } = req.body;
    console.log(phone, "Pass nhận từ fontend " + password);
    const db = await connectDB();
    const usersCol = db.collection("accounts_user");
    let existing = await usersCol.findOne({ phone });
    if (!existing) {
      return res.status(404).json({
        success: false,
        message: "Số điện thoại chưa được đăng ký",
      });
    }
    console.log(existing);
    const isMatch = await bcrypt.compare(password, existing.hashedPassword);

    if (!isMatch) {
      return res.status(401).json({
        success: false,
        message: "Sai mật khẩu",
      });
    }
    const token = jwt.sign(
      {
        userId: existing._id,
        username: existing.username || existing.phone,
      },
      SECRET_KEY,
      { expiresIn: "1h" },
    );
    return res.status(200).json({
      success: true,
      token: token,
      userId: existing._id,
    });
  } catch (error) {
    console.error("không thể đăng nhập", error);
    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(500).json({
      success: false,
      message: "Không thể đăng nhập",
    });
  }
}

module.exports = {
  userLog,
};
