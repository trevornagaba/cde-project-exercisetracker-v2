const express = require('express')
const app = express()
const cors = require('cors')
// Enable serverless. This module allows you to 'wrap' your API for serverless use
const serverless = require('serverless-http');
require('dotenv').config()
const { uuid } = require('uuidv4');
const mongoose = require('./services/mongoose').mongoose;
const User = require( './models/user');
const Exercise = require('./models/exercise');

// Function to parse data
const bodyParser = require('body-parser');
app.use(bodyParser.urlencoded({ extended: true }));

app.use(cors())
app.use(express.static('public'))
app.get('/', (req, res) => {
  // res.sendFile(__dirname + '/views/index.html')
  res.json({"message": "Hello"});
});

console.log(uuid());

app.route('/api/users').get(function(req, res) {
  User.listUsers(function(err, data) {
    if (err) {
      console.log(err);
    } else {
      console.log(data);
      res.json(data);
    }
  });
}).post(function(req, res) {
  User.createAndSaveUser(req.body.username, function(err, data) {
    if (err) {
      console.log(err);
    } else {
      res.json({user: data});
    }});
})

app.post('/api/users/:id/exercises', function(req, res) {
  Exercise.createAndSaveExercise(req.body, function(err, data) {
    if (err) {
      console.log(err);
    } else {
      res.json({exercise: data});
    }});
});

const listener = app.listen(process.env.PORT || 3000, () => {
  console.log('Your app is listening on port ' + listener.address().port)
})

// Convert app to serverless; exporting handler allows lambda to call it
module.exports.handler = serverless(app);