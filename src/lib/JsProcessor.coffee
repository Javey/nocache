# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './Processor'
path = require 'path'
_ = require 'lodash'

class JsProcessor extends Processor

    process: (content, sourceFile, outputFile, options) ->
        @reg ?= @setReplaceTypes(['png', 'jpg', 'gif'])
        content = content.replace(@reg, (all, rest, url) =>
            url = @_getNewUrl(url, path.dirname(sourceFile), path.dirname(outputFile), options)
            rest + url
        )
        content

    setReplaceTypes: (types) ->
        reg = "(['\"])((?:[^'\"\\\\]{1,300})\\\.(?:#{types.join('|')}))(?=['\"\\\\])"
        @reg = new RegExp(reg, 'ig')


module.exports = JsProcessor