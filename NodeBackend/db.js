const { MongoClient } = require("mongodb");
require("dotenv").config();
const uri = process.env.MONGODB_URI;
const client = new MongoClient(uri);



if (!uri) {
  throw new Error("liên kết MongoDB URI không được cung cấp. Vui lòng đặt biến môi trường MONGODB_URI.");
}

async function connectDB() {
  if (!client.topology?.isConnected()) { // hoặc dùng client.connect() luôn an toàn hơn
    await client.connect();
    console.log("Connected to MongoDB");

  }

  return client.db("medicinsdb");
}
async function disconnectDB() {
  try {
    await client.close();
    console.log("Disconnected from MongoDB Atlas");
  } catch (error) {
    console.error("Error disconnecting from MongoDB Atlas:", error);
  }
}
module.exports = {
  connectDB,
  disconnectDB,
};
