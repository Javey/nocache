# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './Processor'
$ = require 'cheerio'
utils = require './utils'
path = require 'path'

class TplProcessor extends Processor
    process: (content, sourceFile, outputFile, options) ->
        $ = $.load(content)
        @_replaceMedia($, sourceFile, outputFile, options)
        @_replaceCss($, sourceFile, outputFile, options)
        @_repalceJs($, sourceFile, outputFile, options)
        $.html()

    _replaceMedia: ($, sourceFile, outputFile, options) ->
        $('img').each (i, elem) =>
            @_replacePath($(elem), 'src', sourceFile, outputFile, options)

    _replaceCss: ($, sourceFile, outputFile, options) ->
        $('link[rel="stylesheet"]').each (i , elem) =>
            @_replacePath($(elem), 'href', sourceFile, outputFile, options)

        # 处理内联样式
        $('style').each (i, elem) =>
            $style = $(elem)
            if $style.attr('_xprocess') == 'true'
                # 内联样式需要处理
                processor = Processor.getInstance('css')
                $style.html processor.process($style.html(), sourceFile, outputFile, options)
                $style.removeAttr('_xprocess')

    _repalceJs: ($, sourceFile, outputFile, options) ->
        $('script').each (i, elem) =>
            $elem = $(elem)
            if $elem.attr('src')
                @_replacePath($elem, 'src', sourceFile, outputFile, options)
            else if $elem.attr('_xprocess') == 'true'
                # 处理内联js
                processor = Processor.getInstance('js')
                $elem.html processor.process($elem.html(), sourceFile, outputFile, options)
                $elem.removeAttr('_xprocess')

    _replacePath: (dom, prop, sourceFile, outputFile, options) ->
        if value = dom.attr(prop)
            # 去掉queryString
            value = value.split('?')[0]

            value = @_getNewUrl(value, path.dirname(sourceFile), path.dirname(outputFile), options)
            dom.attr(prop, value)

module.exports = TplProcessor