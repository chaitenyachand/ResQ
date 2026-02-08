require("dotenv").config();
const express = require("express");
const http = require("http");
const socketio = require("socket.io");
require("./config/db");

const app = express();
const server = http.createServer(app);
const io = socketio(server, { cors: { origin: "*" } });

app.use(express.json());
app.use((req, res, next) => {
  req.io = io;
  next();
});

require("./socket")(io);

app.use("/user", require("./routes/user.routes"));
app.use("/panic", require("./routes/panic.routes"));

server.listen(process.env.PORT, () =>
  console.log("🚨 Backend running")
);
