const jwt = require("jsonwebtoken");
const JWT_SECRET = process.env.SECRET_KEY;
async function authMiddleware(req, res, next) {
  try {
    const authHeader = req.headers.authorization;
    console.log("Authorization header:", req.headers.authorization);
    if (!authHeader) {
      return res.status(401).json({
        success: false,
        message: "không có token",
      });
    }
    const token = authHeader.split(" ")[1];
    if (!token) {
      return res.status(401).json({
        success: false,
        message: "Token không hợp lệ",
      });
    }
    const decode = jwt.verify(token, JWT_SECRET);
    req.user = decode;
    console.log(decode);
    next();
  } catch (errors) {
    return res.status(401).json({
      success: false,
      message: "Token hết hạn hoặc không hợp lệ",
    });
  }
}
module.exports = {
  authMiddleware,
};
