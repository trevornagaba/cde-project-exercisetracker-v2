const assert = require('assert');
const { uuid }  = require('uuidv4');
const mongoose = require('../services/mongoose').mongoose;
const User = require( '../models/user');
const Exercise = require('../models/exercise');

// describe('User', () => {
//   it('should create a new user', (done) => {
//     const username = 'test-user';
//     User.createAndSaveUser(username, (err, data) => {
//       assert.strictEqual(err, null);
//       assert.strictEqual(data.username, username);
//       done();
//     });
//   });
// });

describe('Create and save exercise', () => {
  it('should create and save an exercise', async () => {
    const exercise = {
      description: 'Running',
      duration: '30 minutes',
      date: '2023-03-08',
      user_id: '1234567890',
    };
    Exercise.createAndSaveExercise(exercise, (err, data) => {
      assert.strictEqual(err, null);
      assert.strictEqual(data.description, exercise.description);
      assert.strictEqual(data.duration, exercise.duration);
      assert.strictEqual(data.date, exercise.date);
      assert.strictEqual(data.user_id, exercise.user_id);
      done();
    });
  });
});