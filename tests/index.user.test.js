const assert = require('assert');
const { uuid }  = require('uuidv4');
const mongoose = require('../services/mongoose').mongoose;
const User = require( '../models/user');
const Exercise = require('../models/exercise');

describe('User', () => {
  it('should create a new user', (done) => {
    const username = 'test-user';
    User.createAndSaveUser(username, (err, data) => {
      assert.strictEqual(err, null);
      assert.strictEqual(data.username, username);
      done();
    });
  });
});

// describe('Exercise', () => {
//   it('should create a new exercise', (done) => {
//     const userId = uuid();
//     const description = 'test-description';
//     const duration = 10;
//     const date = new Date();

//     Exercise.createAndSaveExercise({
//       userId,
//       description,
//       duration,
//       date
//     }, (err, data) => {
//       assert.strictEqual(err, null);
//       assert.strictEqual(data.userId, userId);
//       assert.strictEqual(data.description, description);
//       assert.strictEqual(data.duration, duration);
//       assert.strictEqual(data.date, date);
//       done();
//     });
//   });
// });
