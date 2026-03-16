const { connectDB } = require("../db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.SECRET_KEY || "mysecretkey";

async function userReg(req, res) {
  try {
    const db = await connectDB();
    const usersCol = db.collection("accounts_user");

    const { phone, password, repassword, name } = req.body;
    console.log("Received registration data:", {
      phone,
      password,
      name,
      repassword,
    });
    // Kiểm tra dữ liệu đầu vào
    if (!phone || !password || !repassword || !name) {
      return res
        .status(400)
        .json({ success: false, error: "Thiếu thông tin đăng ký" });
    }

    // Kiểm tra trùng email
    const existing = await usersCol.findOne({ phone });
    if (existing) {
      return res
        .status(409)
        .json({ success: false, error: "số điện thoại đã được đăng ký" });
    }

    const hashedPassword = await bcrypt.hash(password, 10);

    // Insert dữ liệu mới
    const result = await usersCol.insertOne({
      phone,
      hashedPassword,
      name,
      createAt: new Date(),
    });
    const userId = result.insertedId;

    const token = jwt.sign(
      {
        userId: userId,
        phone: phone,
      },
      JWT_SECRET,
      { expiresIn: "7d" },
    );
    res.status(200).json({
      success: true,
      message: "Đăng ký thành công",
      token: token,
      userId: userId,
    });
  } catch (error) {
    console.error("Error registering user:", error);
    res.status(500).json({ success: fasle, error: "Đăng ký thất bại" });
  }
}

module.exports = {
  userReg,
};
