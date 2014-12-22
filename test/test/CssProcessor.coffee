# @fileoverview
# @author javey
# @date 14-12-18

should = require 'should'
Processor = require '../../src/lib/Processor'
CssProcessor = require '../../src/lib/CssProcessor'
MediaProcessor = require '../../src/lib/MediaProcessor'
Promise = require 'bluebird'
fs = Promise.promisifyAll require('fs')
utils = require '../../src/lib/utils'
glob = Promise.promisify(require 'glob')

describe 'CssProcessor', ->
    cssProcessor = null
    mediaProcessor = null

    beforeEach ->
        glob('../asset/src/image/**/*.png')
        .then (files) ->
            mediaProcessor = Processor.getInstance('media')
            mediaProcessor
                .setFiles(files)
                .write('../asset/build/image/[name].test.[ext]', {
                    sourceContext: '../asset/src'
                    outputContext: '../asset/build'
                })
        .then ->
            glob('../asset/src/css/**/*.css')
        .then (files) ->
            cssProcessor = new CssProcessor files

    describe '#write()', ->
        it 'should replace url correctly', ->
            cssProcessor.setMap(mediaProcessor.getMap())
            cssProcessor.write('../asset/build/css/[name].test.[ext]', {
                sourceContext: '../asset/src'
                outputContext: '../asset/build'
            })
