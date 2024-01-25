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
