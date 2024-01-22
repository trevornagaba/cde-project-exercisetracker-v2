const { uuid } = require('uuidv4');
const mongoose = require('../services/mongoose').mongoose;

const exerciseSchema = new mongoose.Schema({
  description: {
    type: String,
    required: true,
  },
  duration: {
    type: String,
    required: true,
  },
  date: {
    type: String,
  },
  id: {
    type: String,
  }
});

let Exercise = mongoose.model('Exercise', exerciseSchema);

exports.createAndSaveExercise = (req, done) => {
  const exercise = new Exercise({
    description: req.description,
    duration: req.duration,
    date: req.date,
    id: req.id
  });
  exercise.save(function (err, data) {
  done(null , data);});
  return exercise;
};

exports.listExercises = (done) => {
  return Exercise.find({}, function (err, data) {
    done(null, data);
  });
};

// const createManyExercise = (arrayOfExercise, done) => {
//   done(null /*, data*/);
// };

// const findExerciseByName = (personName, done) => {
//   done(null /*, data*/);
// };

// const findOneByFood = (food, done) => {
//   done(null /*, data*/);
// };

// const findExerciseById = (personId, done) => {
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

// const removeManyExercise = (done) => {
//   const nameToRemove = "Mary";

//   done(null /*, data*/);
// };

// const queryChain = (done) => {
//   const foodToSearch = "burrito";

//   done(null /*, data*/);
// };

exports.Exercise = Exercise;