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
        @_processRules(obj.stylesheet.rules, sourceFile, outputFile, options)
        css.stringify(obj)

    _processRules: (rules, sourceFile, outputFile, options) ->
        _.each rules, (rule) =>
            if rule.rules
                @_processRules(rule.rules, sourceFile, outputFile, options)
            else
                @_replace(rule, sourceFile, outputFile, options)

    _replace: (rule, sourceFile, outputFile, options) ->
        _.each rule.declarations, (decl) =>
            property = decl.property
            return unless property
            if ~property.indexOf('background') || ~property.indexOf('src')
                @_replaceUrl(decl, sourceFile, outputFile, options)
            else if ~property.indexOf('filter')
                @_replaceFilter(decl, sourceFile, outputFile, options)

    _replaceUrl: (decl, sourceFile, outputFile, options) ->
        if matches = decl.value.match(/(url\([\'\"]?)([^\'\"\)]+)([\'\"]?\))/g)
            _.each matches, (value) =>
                if _matches = value.match(/(url\([\'\"]?)([^\'\"\)]+)([\'\"]?\))/)
                    url = _matches[2]
                    url = @_getNewUrl(url, path.dirname(sourceFile), path.dirname(outputFile), options);
                    url = "#{_matches[1]}#{url}#{_matches[3]}"
                    decl.value = decl.value.replace(value, url)

    _replaceFilter: (decl, sourceFile, outputFile, options) ->
        if matches = decl.value.match(/(.*?src=[\'\"]?)([^\'\"\)]+)([\'\"]?.*)/)
            url = matches[2]
            url = @_getNewUrl(url, path.dirname(sourceFile), path.dirname(outputFile), options);
            decl.value = "#{matches[1]}#{url}#{matches[3]}"

module.exports = CssProcessor
