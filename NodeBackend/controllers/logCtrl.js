const {connectDB} = require("../db");
const {get} = require("../routes/logRoute");
const jwt = require("jsonwebtoken");
require('dotenv').config(); // Import dotenv để sử dụng biến môi trường
const SECRET_KEY = process.env.SECRET_KEY;

async function userLog(req, res) {
  try{ 
      const { phone, password } = req.body;
      console.log(phone, "Pass nhận từ fontend " + password)
      const db = await connectDB();
      const usersCol = db.collection("accounts_user");
      let existing = await usersCol.findOne({ phone });
      if (existing == null) {
        return res.status(409).json({ error: "số điện thoại chưa được đăng ký" });
      } 
      console.log(existing)
      if (existing.password !== password) {
          return res.status(401).json({ error: "Sai mật khẩu" });
      } else {
        const username = existing.username || existing.phone;
        const token = jwt.sign({ username }, SECRET_KEY, { expiresIn: "1h" });
        const ids = existing._id;
        res.status(200).json({ token , ids});
      }
  }catch (error) {
    console.error("không thể đăng nhập", error);
    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(401).json({ error: "không thể đăng nhập" });
  }
}



async function checkToken(req, res) {
  try {
    const { token } = req.body;

    if (!token) {
      return res.status(400).json({ error: "Token không được cung cấp" });
    }

    // Xác thực token
    const decoded = jwt.verify(token, SECRET_KEY);

    // Nếu thành công, trả về OK
    return res.status(200).json({ message: "Token hợp lệ", user: decoded });

  } catch (error) {
    console.error("Error checking token:", error);

    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(401).json({ error: "Token không hợp lệ hoặc đã hết hạn" });
  }
}


module.exports = {
  userLog,

  checkToken,
};