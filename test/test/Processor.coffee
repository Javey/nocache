# @fileoverview
# @author javey
# @date 14-12-18

should = require 'should'
Processor = require '../../src/lib/Processor'
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
utils = require '../../src/lib/utils'
glob = require 'glob'
chai = require 'chai'
chaiAsPromised = require 'chai-as-promised'
path = require 'path'

chai.use(chaiAsPromised)
chai.Should()

describe 'Processor', ->
    processor = null;

    input = '../asset/src/js/test.js'

    beforeEach ->
        processor = new Processor input

    describe '#write()', ->
        it 'write file with path and name', (done) ->
            processor.write('[path][name]test.[ext]')
            .then -> utils.fileExists('../asset/src/js/testtest.js').should.eventually.be.true
            .then -> fs.unlink '../asset/src/js/testtest.js'
            .then -> done()

        it 'write file with name', (done) ->
            processor.write('../asset/build/js/[name].[ext]')
            .then -> utils.fileExists('../asset/build/js/test.js').should.eventually.be.true
            .then -> done()

        it 'write file with hash', (done) ->
            processor.write('../asset/build/js/[hash:8].[ext]')
            .then -> utils.fileExists('../asset/build/js/5c164850.js').should.eventually.be.true
            .then -> done()

        it 'write file with path, specify sourceContext', (done) ->
            processor.write('../asset/build/[path][name].sourceContext.js', {sourceContext: '../asset/src'})
            .then -> utils.fileExists('../asset/build/js/test.sourceContext.js').should.eventually.be.true
            .then -> done()

        it 'should generate map correctly', ->
            map = {}
            map[path.resolve('../asset/src/js/test.js')] = path.resolve('../asset/build/js/test.test.js')
            processor.write('../asset/build/[path][name].test.js', {sourceContext: '../asset/src'})
            .then -> processor.getMap().should.be.eql map

        it 'should generate map correctly with multi files', ->
            Promise.promisify(glob)('../asset/src/js/**/*.js')
            .then (files) ->
                processor.setFiles(files)
                processor.write('../asset/build/[path][name].[ext]', {
                    sourceContext: '../asset/src'
                })
            .then ->
                processor.getMap().should.be.not.empty

    describe '#_getNewUrl()', ->
        beforeEach ->

        it 'relative path without extra arguments', ->
            map = {}
            map[path.resolve 'a/a.png'] = path.resolve 'a/a.test.png'
            processor.setMap(map)
            processor._getNewUrl('a/a.png').should.eql 'a/a.test.png'

        it 'relative path with sourcePath', ->
            map = {}
            map[path.resolve '../asset/src/image/a/a.png'] = path.resolve 'a/a.test.png'
            processor.setMap(map)
            processor._getNewUrl('a/a.png', '../asset/src/image').should.eql 'a/a.test.png'

        it 'relative path with sourcePath and outputPath', ->
            map = {}
            map[path.resolve '../asset/src/image/a/a.png'] = path.resolve '../asset/build/image/a/a.test.png'
            processor.setMap(map)
            processor._getNewUrl('a/a.png', '../asset/src/image', '../asset/build/image').should.eql 'a/a.test.png'

        it 'absolute path with options, specify sourceContext and outputContext', ->
            map = {}
            map[path.resolve '../asset/src/image/a/a.png'] = path.resolve '../asset/build/image/a/a.test.png'
            processor.setMap(map)
            processor._getNewUrl('/a/a.png', {sourceContext: '../asset/src/image', outputContext: '../asset/build/image'}).should.eql '/a/a.test.png'