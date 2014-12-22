# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './Processor'
$ = require 'cheerio'
utils = require './utils'

class TplProcessor extends Processor
    process: (content) ->
        $ = $.load(content)
        @_replaceMedia($)
        @_replaceCss($)
        @_repalceJs($)
        $.html()

    _replaceMedia: ($) ->
        $('img').each (i, elem) =>
            @_replacePath($(elem), 'src')

    _replaceCss: ($) ->
        $('link[rel="stylesheet"]').each (i , elem) =>
            @_replacePath($(elem), 'href')

        # 处理内联样式
        $('style').each (i, elem) =>
            $style = $(elem)
            if $style.attr('_xprocess') == 'true'
                # 内联样式需要处理
                processor = Processor.getInstance('css')
                $style.html processor.process($style.html())
                $style.removeAttr('_xprocess')

    _repalceJs: ($) ->
        $('script').each (i, elem) =>
            $elem = $(elem)
            if $elem.attr('src')
                @_replacePath($elem, 'src')
            else if $elem.attr('_xprocess') == 'true'
                # 处理内联js
                processor = Processor.getInstance('js')
                $elem.html processor.process($elem.html())
                $elem.removeAttr('_xprocess')

    _replacePath: (dom, prop) ->
        if value = dom.attr(prop)
            # 去掉queryString
            value = value.split('?')[0]

            value = @_getNewUrl(value)
            dom.attr(prop, value)

module.exports = TplProcessor