// server.js
const express = require("express");
const cors = require("cors");
const logRoute = require("./routes/logRoute");
const regRoute = require("./routes/regRoute");
const databaseMedicinRoute = require("./routes/databaseMedicinRoute");
const databaseBillRoute = require("./routes/databaseBillRoute");
const statisRoute = require("./routes/statisRoute");
require("dotenv").config(); // Import dotenv để sử dụng biến môi trường
const app = express();
const port = process.env.PORT || 3000;
// const port = process.env.webport || 5100;
app.use(cors({}));

app.use(express.json());
app.use("/api/login", logRoute);
app.use("/api/register", regRoute);
app.use("/api/medicins", databaseMedicinRoute);
app.use("/api/bills", databaseBillRoute);
app.use("/api/statis", statisRoute);

app.listen(port, () => {
  console.log(`Server chạy ở http://localhost:${port}`);
});
