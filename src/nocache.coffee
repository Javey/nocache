# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './lib/Processor'

class NoCache
    constructor: (@options = { sourceContext: '', outputContext: '', cdn: [] }) ->
        @map = {}

    processMedia: (files, pattern, cdn) ->
        processor = Processor.getInstance('media')
        processor
            .setFiles(files)
            .setCdn(cdn || @options.cdn)
            .write(pattern, @options)
            .then => @map = processor.getMap()

    processCss: (files, pattern, cdn) ->
        processor = Processor.getInstance('css')
        processor
            .setFiles(files)
            .setMap(@map)
            .setCdn(cdn || @options.cdn)
            .write(pattern, @options)
            .then => @map = processor.getMap()

    processJs: (files, pattern, cdn) ->
        processor = Processor.getInstance('js')
        processor
            .setFiles(files)
            .setMap(@map)
            .setCdn(cdn || @options.cdn)
            .write(pattern, @options)
            .then => @map = processor.getMap()

    processTpl: (files, pattern, cdn) ->
        processor = Processor.getInstance('tpl')
        processor
            .setFiles(files)
            .setMap(@map)
            .setCdn(cdn || @options.cdn)
            .write(pattern, @options)
            .then => @map = processor.getMap()

module.exports = {
    NoCache: NoCache
    Processor: Processor
    utils: require('./lib/utils')
}