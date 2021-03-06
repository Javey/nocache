// Generated by CoffeeScript 1.8.0
var Path, Promise, fs, utils, _;

Promise = require('bluebird');

fs = Promise.promisifyAll(require('fs-extra'));

Path = require('path');

_ = require('lodash');

utils = module.exports = {
  writeFile: function(file, content) {
    var dirname;
    dirname = Path.dirname(file);
    return utils.fileExists(dirname).then(function(exists) {
      if (!exists) {
        return fs.mkdirpAsync(dirname);
      }
    }).then(function() {
      return fs.writeFileAsync(file, content);
    });
  },
  fileExists: function(file) {
    return new Promise(function(resolve) {
      return fs.exists(file, function(exists) {
        return resolve(exists);
      });
    });
  },
  ucfirst: function(str) {
    str += '';
    return str.charAt(0).toUpperCase() + str.substring(1);
  },
  isPathUrl: function(url) {
    return url && !~url.indexOf('data:') && !~url.indexOf('about:') && !~url.indexOf('://');
  },
  isAbsolute: function(pathName) {
    return pathName.charAt(0) === '/';
  },
  addCdn: function(path, cdn) {
    var fileName, index;
    if (!_.isEmpty(cdn)) {
      fileName = Path.basename(path, Path.extname(path));
      index = (fileName.charCodeAt(0) + fileName.charCodeAt(fileName.length - 1)) % cdn.length;
      path = cdn[index] + path;
    }
    return path;
  }
};
