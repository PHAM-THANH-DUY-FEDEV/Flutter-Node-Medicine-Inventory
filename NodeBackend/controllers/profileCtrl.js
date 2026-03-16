const jwt = require("jsonwebtoken");
const JWT_SECRET = process.env.JWT_SECRET;
async function getProfile(req, res) {
  console.log(req, res);
  try {
    const db = await connectDB();
    const usersCol = db.collection("accounts_user");

    const user = await usersCol.findOne(
      { _id: new ObjectId(req.user.userId) },
      { projection: { password: 0 } },
    );

    res.json({
      success: true,
      user: user,
    });
  } catch (err) {
    res.status(500).json({
      success: false,
      message: "Server error",
    });
  }
}
module.exports = {
  getProfile,
};
