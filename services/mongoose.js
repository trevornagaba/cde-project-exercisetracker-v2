require('dotenv').config();
const mongoose = require('mongoose');

// Wrap the connection to mongoose in an asyncrhonous function
async function connect() {
  await mongoose
    .connect(process.env.MONGO_URI, {
      useNewUrlParser: true,
      useUnifiedTopology: true,
    })
    .then(console.log("Connected to MongoDB"))
    .catch(function (err) {
      console.log(err);
      console.log("Error connecting to MongoDB");
    });
}
connect();

exports.mongoose = mongoose;