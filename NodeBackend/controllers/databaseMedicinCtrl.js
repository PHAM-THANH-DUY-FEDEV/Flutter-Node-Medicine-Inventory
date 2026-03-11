const {connectDB} = require('../db');
const { ObjectId } = require('mongodb');
const {get} = require('../routes/databaseMedicinRoute');


async function getMedicinsOfLib(req,res) {
  try{ 
      const db = await connectDB();
      const MedicinCol =  db.collection("medicins")
      const dataMedicins = await MedicinCol.find({}).toArray();
      return res.status(200).json({dataMedicins});

  }catch (error) {
    console.error("không thể đăng nhập", error);
    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(401).json({ error: "không thể đăng nhập" });
  }
};

async function searchMedicinsLib(req, res) {
  try {
    const keyword = req.query.q || "";  
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");

    const dataMedicins = await MedicinCol.find({
      tenthuoc: { $regex: keyword, $options: "i" }
    }).toArray();
    console.log(dataMedicins)
    res.status(200).json({ dataMedicins });

  } catch (error) {
    console.error("Lỗi tìm kiếm:", error);
    res.status(401).json({ error: "Lỗi khi tìm kiếm thuốc" });
  }
}

async function addMedicin(req, res) {
  try {
    const formData = req.body;
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");
    const result = await MedicinCol.insertOne(formData);
    res.status(200).json({ message: "Thêm thuốc thành công", insertedId: result.insertedId });
  } catch (error) {
    console.error("Error adding medicin:", error);
    res.status(401).json({ error: "thêm thuốc thất bại vui lòng kiểm tra lại" });
  }
}
async function editMedicin(req, res) {
  try {
    const formData = req.body;
    console.log(formData);
    const id = formData["_id"];
    delete formData._id
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");
    const result = await MedicinCol.updateOne(
      { _id: new ObjectId(id) },
      { $set: formData }
    );
    if (result.matchedCount === 0) {
      return res.status(404).json({ error: "Không tìm thấy thuốc với ID này" });
    }

    res.status(200).json({ message: "Thay đổi thông tin thành công" });

  } catch (error) {
    console.error("Error edited medicin:", error);
    res.status(401).json({ error: "Chỉnh sửa thất bại, vui lòng kiểm tra lại" });
  }
}

async function deleteMedicin(req, res) {
  try {
    const idItem =  req.query.id || ""; 
    console.log(idItem)
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");
    const result = await MedicinCol.deleteOne({ _id: new ObjectId(idItem) });
    if (result.deletedCount === 1){
      res.status(200).json({ message: "Xóa thuốc thành công" });
    }else {
      return res.status(401).json({ error: "Không tìm thấy thuốc với id này" });
    }
  } catch (error) {
    console.error("Error delete medicin:", error);
    res.status(401).json({ error: "Xóa thuốc thất bại vui lòng kiểm tra lại" });
  }
}


module.exports = {
  getMedicinsOfLib,
  searchMedicinsLib,
  addMedicin,
  editMedicin,
  deleteMedicin
};