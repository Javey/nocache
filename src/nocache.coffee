# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './lib/Processor'

class NoCache
    constructor: (@options = { sourceContext: '', outputContext: '' }) ->
        @map = {}

    processMedia: (files, pattern) ->
        processor = Processor.getInstance('media')
        processor
            .setFiles(files)
            .write(pattern, @options)
            .then => @map = processor.getMap()

    processCss: (files, pattern) ->
        processor = Processor.getInstance('css')
        processor
            .setFiles(files)
            .setMap(@map)
            .write(pattern, @options)
            .then => @map = processor.getMap()

    processJs: (files, pattern) ->
        processor = Processor.getInstance('js')
        processor
            .setFiles(files)
            .setMap(@map)
            .write(pattern, @options)
            .then => @map = processor.getMap()

    processTpl: (files, pattern) ->
        processor = Processor.getInstance('tpl')
        processor
            .setFiles(files)
            .setMap(@map)
            .write(pattern, @options)
            .then => @map = processor.getMap()

module.exports = {
    NoCache: NoCache
    Processor: Processor
}