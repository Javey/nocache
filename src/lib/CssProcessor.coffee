# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './Processor'
css = require 'css'
_ = require 'lodash'
path = require 'path'

class CssProcessor extends Processor
    process: (content, sourceFile, outputFile, options) ->
        obj = css.parse content
        _.each obj.stylesheet.rules, (rule) =>
            if rule.type == 'rule'
                @_replace(rule, sourceFile, outputFile, options)
        css.stringify(obj)

    _replace: (rule, sourceFile, outputFile, options) ->
        _.each rule.declarations, (decl) =>
            property = decl.property
            if ~property?.indexOf('background')
                @_replaceBackground(decl, sourceFile, outputFile, options)
            else if ~property?.indexOf('filter')
                @_replaceFilter(decl, sourceFile, outputFile, options)

    _replaceBackground: (decl, sourceFile, outputFile, options) ->
        if matches = decl.value.match(/(.*url\([\'\"]?)([^\'\"\)]+)([\'\"]?\).*)/)
            url = matches[2]
            url = @_getNewUrl(url, path.dirname(sourceFile), path.dirname(outputFile), options);
            decl.value = "#{matches[1]}#{url}#{matches[3]}"

    _replaceFilter: (decl, sourceFile, outputFile, options) ->
        if matches = decl.value.match(/(.*?src=[\'\"]?)([^\'\"\)]+)([\'\"]?.*)/)
            url = matches[2]
            url = @_getNewUrl(url, path.dirname(sourceFile), path.dirname(outputFile), options);
            decl.value = "#{matches[1]}#{url}#{matches[3]}"

module.exports = CssProcessor