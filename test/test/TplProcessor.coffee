# @fileoverview
# @author javey
# @date 14-12-19

Processor = require '../../src/lib/TplProcessor'
should = require 'should'
utils = require '../../src/lib/utils'
Promise = require 'bluebird'
fs = require 'fs'
path = require 'path'

pureContent = """
<!DOCTYPE html>
<html>
<head>
    <title>test</title>
    <link rel="stylesheet" href="test/a.css"/>
</head>
<body>
This is body.
<img src="./test/a.png"/>
<img src="test/b.png">
<script src="test/a.js"></script>
</body>
</html>
"""

outputPureContent = """
<!DOCTYPE html>
<html>
<head>
    <title>test</title>
    <link rel="stylesheet" href="test/a.test.css"/>
</head>
<body>
This is body.
<img src="test/a.test.png"/>
<img src="test/b.test.png">
<script src="test/a.test.js"></script>
</body>
</html>
"""

htmlWithStyle = """
<head>
<style _xprocess="true">
    .a {background: url('test/a.png')}
</style>
<style _xprocess="true">
    .a {background: url('test/a.png')}
</style>
</head>
"""
outputHtmlWithStyle = """
<head>
<style>.a {
  background: url('test/a.test.png');
}</style>
<style>.a {
  background: url('test/a.test.png');
}</style>
</head>
"""

htmlWithJs = """
<body>
<script _xprocess="true">
var img = 'test/a.png'
</script>
</body>
"""

outputHtmlWithJs = """
<body>
<script>
var img = 'test/a.test.png'
</script>
</body>
"""

velocityContent = """
#set($WEB_ROOT = "")
#set($STATIC_ROOT = $WEB_ROOT + "/resources/")
#set($MODEL = "development")
<link rel="stylesheet" href="test/a.css">
<body>
<img src="./test/a.png" #if ($a > 1)good#end/>
<img src="test/b.png">
<script src="test/a.js"></script>
</body>
"""

outputVelocityContent = """
#set($WEB_ROOT = "")
#set($STATIC_ROOT = $WEB_ROOT + "/resources/")
#set($MODEL = "development")
<link rel="stylesheet" href="test/a.test.css">
<body>
<img src="test/a.test.png" #if ($a > 1)good#end/>
<img src="test/b.test.png">
<script src="test/a.test.js"></script>
</body>
"""

smartyContent = """
{%extend file="test.tpl"%}
{%block name="title"}
<div>This is title</div>
{%/block%}
<link rel="stylesheet" href="test/a.css">
<body>
<img src="./test/a.png">
<img src="test/b.png">
<script src="test/a.js?v=1"></script>
</body>
"""

outputSmartyContent = """
{%extend file="test.tpl"%}
{%block name="title"}
<div>This is title</div>
{%/block%}
<link rel="stylesheet" href="test/a.test.css">
<body>
<img src="test/a.test.png">
<img src="test/b.test.png">
<script src="test/a.test.js?v=1"></script>
</body>
"""


cwd = process.cwd()

describe 'TplProcessor', ->
    processor = null

    map = {}
    map[path.resolve('./test/a.png')] = path.resolve('./test/a.test.png')
    map[path.resolve('./test/b.png')] = path.resolve('./test/b.test.png')
    map[path.resolve('./test/a.css')] = path.resolve('./test/a.test.css')
    map[path.resolve('./test/a.js')] = path.resolve('./test/a.test.js')

    beforeEach ->
        processor = new Processor null, map

    describe '#process()', ->
        it 'process html', ->
            processor.process(pureContent).should.eql outputPureContent

        it 'parse velocity', ->
            processor.process(velocityContent).should.eql outputVelocityContent

        it 'parse smarty', ->
            processor.process(smartyContent).should.eql outputSmartyContent

        it 'replace background-image in inner style', ->
            _Processor = require '../../src/lib/Processor'
            cssProcessor = _Processor.getInstance('css')
            cssProcessor.setMap(map)
            processor.process(htmlWithStyle).should.eql outputHtmlWithStyle

        it 'replace media resource in inner js', ->
            _Processor = require '../../src/lib/Processor'
            JsProcessor = _Processor.getInstance('js')
            JsProcessor.setMap(map)
            processor.process(htmlWithJs).should.eql outputHtmlWithJs