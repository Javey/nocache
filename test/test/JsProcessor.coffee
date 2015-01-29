# @fileoverview
# @author javey
# @date 14-12-19

Processor = require '../../src/lib/JsProcessor'
should = require 'should'
utils = require '../../src/lib/utils'
Promise = require 'bluebird'
fs = require 'fs'
path = require 'path'

content = """
var a = 'image/a.png',
    b = "/image/b.jpg';
console.log(a, b);
"""

output = """
var a = 'image/a.test.png',
    b = "/image/b.test.jpg';
console.log(a, b);
"""

cdnOutput = """
var a = 'http://s1.static.com/image/a.test.png',
    b = "http://s1.static.com/image/b.test.jpg';
console.log(a, b);
"""

multiCdnOutput = """
var a = 'http://s2.static.com/image/a.test.png',
    b = "http://s1.static.com/image/b.test.jpg';
console.log(a, b);
"""

cwd = process.cwd()

describe 'JsProcessor', ->
    processor = null

    beforeEach ->
        processor = new Processor

    describe '#setReplaceTypes()', ->
        it 'generate replace regexp correctly', ->
            processor.setReplaceTypes(['png', 'jpg', 'gif'])
            processor.reg.should.be.instanceOf RegExp

    describe '#process()', ->
        it 'should replace png image', ->
            processor.setReplaceTypes(['png', 'jpg', 'gif'])
            map = {}
            map[path.resolve 'image/a.png'] = path.resolve 'image/a.test.png'
            map[path.resolve 'image/b.jpg'] = path.resolve 'image/b.test.jpg'
            processor.setMap(map)
            processor.process(content, null, null, {sourceContext: '.', outputContext: '.'}).should.be.eql output

        it 'add one cdn', ->
            processor
                .setCdn('http://s1.static.com')
                .setReplaceTypes(['png', 'jpg', 'gif'])
            map = {}
            map[path.resolve 'image/a.png'] = path.resolve 'image/a.test.png'
            map[path.resolve 'image/b.jpg'] = path.resolve 'image/b.test.jpg'
            processor.setMap(map)
            processor.process(content, null, null, {sourceContext: '.', outputContext: '.'}).should.be.eql cdnOutput
        it 'add multi cdn', ->
            processor
                .setCdn(['http://s1.static.com', 'http://s2.static.com'])
                .setReplaceTypes(['png', 'jpg', 'gif'])
            map = {}
            map[path.resolve 'image/a.png'] = path.resolve 'image/a.test.png'
            map[path.resolve 'image/b.jpg'] = path.resolve 'image/b.test.jpg'
            processor.setMap(map)
            processor.process(content, null, null, {sourceContext: '.', outputContext: '.'}).should.be.eql multiCdnOutput