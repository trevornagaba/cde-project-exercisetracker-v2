const { uuid } = require('uuidv4');
const mongoose = require('../services/mongoose').mongoose;

const userSchema = new mongoose.Schema({
  username: {
    type: String,
  }
});

let User = mongoose.model('User', userSchema);

exports.createAndSaveUser = (username, done) => {
  const user = new User({
    username: username,
    id: uuid()
  });
  user.save(function (err, data) {
  done(null , data);});
  return user;
};

exports.listUsers = (done) => {
  return User.find({}, function (err, data) {
    done(null, data);
  });
};

// const createManyUsers = (arrayOfUsers, done) => {
//   done(null /*, data*/);
// };

// const findUsersByName = (personName, done) => {
//   done(null /*, data*/);
// };

// const findOneByFood = (food, done) => {
//   done(null /*, data*/);
// };

// const findUserById = (personId, done) => {
//   done(null /*, data*/);
// };

// const findEditThenSave = (personId, done) => {
//   const foodToAdd = "hamburger";

//   done(null /*, data*/);
// };

// const findAndUpdate = (personName, done) => {
//   const ageToSet = 20;

//   done(null /*, data*/);
// };

// const removeById = (personId, done) => {
//   done(null /*, data*/);
// };

// const removeManyUsers = (done) => {
//   const nameToRemove = "Mary";

//   done(null /*, data*/);
// };

// const queryChain = (done) => {
//   const foodToSearch = "burrito";

//   done(null /*, data*/);
// };