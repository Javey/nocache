# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './Processor'
utils = require './utils'
path = require 'path'

class TplProcessor extends Processor
    process: (content, sourceFile, outputFile, options) ->
        content = @_replaceMedia(content, sourceFile, outputFile, options)
        content = @_replaceCss(content, sourceFile, outputFile, options)
        content = @_repalceJs(content, sourceFile, outputFile, options)

        content

    _replaceMedia: (content, sourceFile, outputFile, options) ->
        content.replace(/(src=[\'\"]?)([^\'\"]+)([\'\"]?)/g, (str, str1, src, str2) =>
            str1 + @_replacePath(src, sourceFile, outputFile, options) + str2
        )

    _replaceCss: (content, sourceFile, outputFile, options) ->
        content = content.replace(/(href=[\'\"]?)([^\'\"]+)([\'\"]?)/g, (str, str1, href, str2) =>
            str1 + @_replacePath(href, sourceFile, outputFile, options) + str2
        )

        content = content.replace(/(<style)(?:\s+_xprocess=(?:[\'\"]?)true(?:[\'\"]?))([^>]*>)((?:.|\n)*?)(<\/style>)/g, (str, str1, str2, style, str3) =>
            # 内联样式需要处理
            processor = Processor.getInstance('css')
            style = processor.process(style, sourceFile, outputFile, options)
            str1 + str2 + style + str3
        )

        content


    _repalceJs: (content, sourceFile, outputFile, options) ->
        content.replace(/(<script)(?:\s+_xprocess=(?:[\'\"]?)true(?:[\'\"]?))([^>]*>)((?:.|\n)*?)(<\/script>)/g, (str, str1, str2, script, str3) =>
            # 内联样式需要处理
            processor = Processor.getInstance('js')
            script = processor.process(script, sourceFile, outputFile, options)
            str1 + str2 + script + str3
        )

    _replacePath: (value, sourceFile, outputFile, options) ->
        if value
            # 去掉queryString
            value = value.split('?')[0]

            value = @_getNewUrl(value, path.dirname(sourceFile), path.dirname(outputFile), options)
        value

module.exports = TplProcessor