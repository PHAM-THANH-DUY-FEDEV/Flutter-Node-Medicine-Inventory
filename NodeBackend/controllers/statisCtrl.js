const {connectDB} = require('../db');
const { ObjectId } = require('mongodb');
const {get} = require('../routes/statisRoute');
const e = require('express');


async function getStatis(req,res) {
  try{ 
      const db = await connectDB();
      const MedicinCol =  db.collection("medicins");
      const items = await MedicinCol.find({}).toArray();
      const now = new Date();
      console.log(now)
      const dd = String(now.getDate()).padStart(2, '0');
      const mm = String(now.getMonth() + 1).padStart(2, '0');
      const yy = String(now.getFullYear());
      console.log(yy, mm, dd);
      const statisData = {
        expired: 0,
        medicinsexpired : [],
        available: 0,
        medicinsavailable : [],
        outOfStock: 0,
        medicinsoutofstock : [],
        nearExpiry: 0,
        medicinsnearexpiry : [],
      };
      items.forEach(item => {
        if(!checkExpiry(item)){
          if(!checkOutOfStock(item)){
            if(!checkNearExpiry(item)){
              statisData.available += 1;
              statisData.medicinsavailable.push({
                tenthuoc: item.tenthuoc,
                idthuoc: item._id,
                ngaynhap: item.ngaynhap,
                ngayhethan: item.ngayhethan,
              }); 
            }
          };
        };
      });
      
      function checkExpiry(item) {
        if (item.ngayhethan) {
          const [expiryDay, expiryMonth, expiryYear] = item.ngayhethan.split('-').map(Number);
          if (
            expiryYear < yy ||
            (expiryYear == yy && expiryMonth < mm) ||
            (expiryYear == yy && expiryMonth == mm && expiryDay < dd)
          ) {
            statisData.expired += 1;
            statisData.medicinsexpired.push({
              tenthuoc: item.tenthuoc,
              idthuoc: item._id,
              ngaynhap: item.ngaynhap,
              ngayhethan: item.ngayhethan,
            });
            return true
          } else {
            return false
          }
        }
      }

      function checkOutOfStock(item) {
          if (parseInt(item.soluongtonkho) === 0) {
            statisData.outOfStock += 1;
            statisData.medicinsoutofstock.push({
              tenthuoc: item.tenthuoc,
              idthuoc: item._id,  ngaynhap: item.ngaynhap,
              ngayhethan: item.ngayhethan,
            });
            return true
          } else {
            return false
          }
      }

      function checkNearExpiry(item) {
        if (item.ngaycanhbao) {
          const [expiryDay, expiryMonth, expiryYear] = item.ngaycanhbao.split('-').map(Number);
          if (
            (expiryYear == yy && expiryMonth == mm && dd >= expiryDay)
          ) {
            statisData.nearExpiry += 1;
            statisData.medicinsnearexpiry.push({
              tenthuoc: item.tenthuoc,
              idthuoc: item._id,  ngaynhap: item.ngaynhap,
              ngayhethan: item.ngayhethan,
            });
            return true
          } else {
            return false
          }
        }
      }

      console.log(statisData);

      return res.status(200).json({ statisData });

  }catch (error) {
    console.error("có lỗi vui lòng kiểm tra lại", error);
    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(401).json({ error: "có lỗi vui lòng kiểm tra lại" });
  }
};

async function getStatisWithCategory(req,res) {
  try{ 
      const db = await connectDB();
      const MedicinCol =  db.collection("medicins");
      const BillCol =  db.collection("bills");
      let statisDataCategory = await BillCol.aggregate([
      { $unwind: "$sanpham" },
      {
        $addFields: {
          "sanpham.idsanpham": { $toObjectId: "$sanpham.idsanpham" },
        },
      },
      {
        $lookup: {
          from: "medicins",
          localField: "sanpham.idsanpham",
          foreignField: "_id",
          as: "thuoc",
        },
      },
      
      { $unwind: "$thuoc" },
      {
        $group: {
          _id: {
            danhmuc: "$thuoc.danhmuc",
            tenthuoc: "$thuoc.tenthuoc",
          },
          tongSoLuong: { $sum: { $toInt: "$sanpham.soluong" } },
        },
      },
      {
        $group: {
          _id: "$_id.danhmuc",
          tongSoLuongTrongDanhMuc: { $sum: "$tongSoLuong" },
          thuocs: {
            $push: {
              tenthuoc: "$_id.tenthuoc",
              soluong: "$tongSoLuong",
            },
          },
        },
      },
      { $unwind: "$thuocs" },
      { $sort: { "_id": 1, "thuocs.soluong": -1 } },
      {
        $group: {
          _id: "$_id",
          tongSoLuongTrongDanhMuc: { $first: "$tongSoLuongTrongDanhMuc" },
          thuocBanNhieuNhat: { $first: "$thuocs" },
          danhSachThuoc: { $push: "$thuocs" },
        },
      },
      {
        $project: {
          danhmuc: "$_id",
          tongSoLuongTrongDanhMuc: 1,
          thuocBanNhieuNhat: 1,
        },
      },
    ]).toArray();
    statisDataCategory = JSON.stringify(statisDataCategory);
    console.log(statisDataCategory)
    return res.status(200).json({ statisDataCategory });

  }catch (error) {
    console.error("có lỗi vui lòng kiểm tra lại", error);
    // Nếu lỗi do token không hợp lệ hoặc hết hạn
    return res.status(401).json({ error: "có lỗi vui lòng kiểm tra lại" });
  }
};




module.exports = {
  getStatis,
  getStatisWithCategory
};