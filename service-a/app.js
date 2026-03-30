import express from "express";
import cors from "cors";
const app = express();

app.use(cors())
const port = process.env.PORT || 3000;

app.get("/", (req, res) => res.send("hello from service-a"));

app.listen(port, () => console.log(`service-a http://localhost:${port}`));
