const { connectDB } = require("../db");
const { ObjectId } = require("mongodb");
const { uploadImage, deleteImage } = require("../services/cloudinaryService");

async function getMedicinsOfLib(req, res) {
  try {
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");
    const dataMedicins = await MedicinCol.find({}).toArray();
    return res.status(200).json({ dataMedicins });
  } catch (error) {
    console.error("không thể đăng nhập", error);
    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(401).json({ error: "không thể đăng nhập" });
  }
}

async function searchMedicinsLib(req, res) {
  try {
    const keyword = req.query.q || "";
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");

    const dataMedicins = await MedicinCol.find({
      tenthuoc: { $regex: keyword, $options: "i" },
    }).toArray();
    console.log(dataMedicins);
    res.status(200).json({ dataMedicins });
  } catch (error) {
    console.error("Lỗi tìm kiếm:", error);
    res.status(401).json({ error: "Lỗi khi tìm kiếm thuốc" });
  }
}

async function addMedicin(req, res) {
  try {
    const formData = req.body;

    formData.hoatchat = JSON.parse(formData.hoatchat);
    formData.luuy = JSON.parse(formData.luuy);

    let imageUrl = "";

    if (req.file) {
      imageUrl = await uploadImage(req.file);
    }

    formData.image = imageUrl;

    const db = await connectDB();
    const MedicinCol = db.collection("medicins");

    const result = await MedicinCol.insertOne(formData);

    res.status(200).json({
      message: "Thêm thuốc thành công",
      insertedId: result.insertedId,
    });
  } catch (error) {
    console.error("Error adding medicin:", error);

    res.status(401).json({
      error: "thêm thuốc thất bại vui lòng kiểm tra lại",
    });
  }
}
async function editMedicin(req, res) {
  try {
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");

    const formData = req.body;
    const id = formData._id;

    formData.hoatchat = JSON.parse(formData.hoatchat);
    formData.luuy = JSON.parse(formData.luuy);
    delete formData._id;
    const oldMedicin = await MedicinCol.findOne({
      _id: new ObjectId(id),
    });

    let imageUrl = oldMedicin.image;

    if (req.file) {
      const newImage = await uploadImage(req.file);

      if (oldMedicin.image) {
        await deleteImage(oldMedicin.image);
      }

      imageUrl = newImage;
    }

    formData.image = imageUrl;

    await MedicinCol.updateOne({ _id: new ObjectId(id) }, { $set: formData });

    res.status(200).json({
      success: true,
      message: "Cập nhật thuốc thành công",
    });
  } catch (error) {
    console.error(error);

    res.status(401).json({
      success: false,
      error: "Cập nhật thất bại",
    });
  }
}

async function deleteMedicin(req, res) {
  try {
    const idItem = req.query.id || "";
    console.log(idItem);
    const db = await connectDB();
    const MedicinCol = db.collection("medicins");
    const medicin = await MedicinCol.findOne({ _id: new ObjectId(idItem) });

    if (medicin.image) {
      await deleteImage(medicin.image);
    }

    const result = await MedicinCol.deleteOne({ _id: new ObjectId(idItem) });

    if (result.deletedCount === 1) {
      res.status(200).json({ success: true, message: "Xóa thuốc thành công" });
    } else {
      return res
        .status(401)
        .json({ success: false, error: "Không tìm thấy thuốc với id này" });
    }
  } catch (error) {
    console.error("Error delete medicin:", error);
    res.status(401).json({
      success: false,
      error: "Xóa thuốc thất bại vui lòng kiểm tra lại",
    });
  }
}

module.exports = {
  getMedicinsOfLib,
  searchMedicinsLib,
  addMedicin,
  editMedicin,
  deleteMedicin,
};
