# @fileoverview
# @author javey
# @date 14-12-19

Processor = require '../../src/lib/MediaProcessor'
should = require 'should'
utils = require '../../src/lib/utils'
Promise = require 'bluebird'
fs = require 'fs'
mmm = require 'mmmagic'

magic = new mmm.Magic(mmm.MAGIC_MIME_TYPE)

describe 'MediaProcessor', ->
    processor = null

    beforeEach ->
        processor = new Processor

    describe '#setFiles()', ->
        it 'set one file', ->
            processor.setFiles('/a/b.png')
            processor.files.should.eql ['/a/b.png']
            processor.types.should.eql {png: true}
            processor.getTypes().should.eql ['png']

        it 'set multi files', ->
            processor.setFiles(['a/b/c.png', 'a/b.jpg', 'a/b.png', 'a/b/c.gif'])
            processor.types.should.eql {png: true, jpg: true, gif: true}
            processor.getTypes().should.eql ['png', 'jpg', 'gif']

    describe '#write()', ->
        it 'should create a file whose MIME is image/png', (done) ->
            output = '../asset/build/image/edit.mediatest.png'
            processor.setFiles('../asset/src/image/edit.png')
                .write('../asset/build/image/[name].mediatest.[ext]')
                .then ->
                    utils.fileExists(output)
                .then (exists) ->
                    exists.should.be.true
                    magic.detectFile(output, (err, result) ->
                        result.should.be.eql 'image/png'
                        fs.unlink output
                        done()
                    )