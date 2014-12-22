# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './lib/Processor'

class NoCache
    constructor: (@options = { sourceContext: '', outputContext: '' }) ->

    processMedia: (pattern) ->
        Processor.getInstance('media').write(pattern, @options)

    processCss: (pattern) ->
        Processor.getInstance('css').write(pattern, @options)

    processJs: (pattern) ->
        Processor.getInstance('js').write(pattern, @options)

    processTpl: (pattern) ->
        Processor.getInstance('tpl').write(pattern, @options)

module.exports = {
    NoCache: NoCache
    Processor: Processor
}