# @fileoverview
# @author javey
# @date 14-12-18

should = require 'should'
utils = require '../../src/lib/utils'
fs = require 'fs'

describe 'utils', ->

    describe '#fileExists()', ->
        it 'should not exist', ->
            utils.fileExists('../a/b/c.js').then (exists)->
                exists.should.be.false
        it 'should exist', ->
            utils.fileExists('../asset/src/js/main.js').then (exists) ->
                exists.should.be.true

    describe '#writeFile()', ->
        it 'should write file success', ->
            file = '../asset/build/test.js'
            utils.writeFile(file, 'test')
            .then ->
                utils.fileExists(file)
            .then (exists) ->
                exists.should.be.true
