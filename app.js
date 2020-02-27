const express = require('express'),
      app = express(),
      port = process.env.PORT || 8080,
      client = require("./lib/mongoClient");

app.get("/", async(req, res) => {

    console.log("Request Coming into Express App...");
    const mongoClient = client.createGotClient();
    try{

        await mongoClient.connect();
        const item = await mongoClient.db("Test").collection('hello-world').find().toArray();
        console.log(`item length: ${item.length}`);
        res.send(`Hello World! I'm running on PORT : ${port}`);
    }catch(err){
        res.send(err.message);
    }
});

app.listen(port, () => {
    console.log(`Server running on ${port}`)
});