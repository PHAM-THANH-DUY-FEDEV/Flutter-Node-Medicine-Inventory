const {connectDB} = require("../db");
const {get} = require("../routes/regRoute");

async function userReg(req, res) {
  try {
    const db = await connectDB();
    const usersCol = db.collection("accounts_user");

    const { phone, password ,repassword ,name} = req.body;
    console.log("Received registration data:", { phone, password, name ,repassword});
    // Kiểm tra dữ liệu đầu vào
    if (!phone || !password || !repassword || !name) {
      return res.status(400).json({ error: "Thiếu thông tin đăng ký" });
    }

    // Kiểm tra trùng email
    const existing = await usersCol.findOne({ phone });
    if (existing) {
      return res.status(409).json({ error: "số điện thoại đã được đăng ký" });
    }

    // Insert dữ liệu mới
    const result = await usersCol.insertOne({ phone, password, name });
    res.status(200).json({ message: "Đăng ký thành công", id: result.insertedId });
  } catch (error) {
    console.error("Error registering user:", error);
    res.status(500).json({ error: "Đăng ký thất bại" });
  }
}


module.exports = {
   userReg,
};