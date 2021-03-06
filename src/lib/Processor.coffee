# @fileoverview 处理器父类
# @author javey
# @date 14-12-16

Promise = require 'bluebird'
fs = require 'fs'
_ = require 'lodash'
loaderUtils = require 'loader-utils'
utils = require './utils'
path = require 'path'

class Processor
    constructor: (files, @map = {}) ->
        @setFiles(files)

    ###*
     * 写入处理后的文件
    ###
    write: (filename, options = {sourceContext: '', outputContext: ''}) ->
        Promise.map(@files, (file) =>
            @_readFile(file)
            .then (content) =>
                sourceFile = path.resolve file
                outputFile = path.resolve @_getFilename(filename, file, options.sourceContext, content || 'nocache') # 没有文本内容不会去求hash值,所以给个默认值

                @map[sourceFile] = outputFile

                Promise.join(@process(content, sourceFile, outputFile, options), outputFile)
            .then ([content, outputFile]) ->
                utils.writeFile(outputFile, content)
        )

    ###*
     * 处理文本
    ###
    process: (content, sourceFile, outputFile, options) ->
        content

    _readFile: (file) ->
        Promise.promisify(fs.readFile)(file, 'utf-8')

    ###*
     * 根据文件路径pattern，生成相应路径
    ###
    _getFilename: (filePattern, file, context, content) ->
        loaderUtils.interpolateName({ resourcePath: file }, filePattern, {
            content: content
            context: context
        }).replace(/_\//g, '../')

    ###*
     * 获取替换路径
    ###
    _getNewUrl: (url, sourcePath = '.', outputPath = '.', options) ->
        ## 替换后面的问号
        sufix = ''
        if ~(index = url.indexOf('?'))
            sufix = url.substring(index)
            url = url.substring(0, index)
        if utils.isPathUrl(url)
            if utils.isAbsolute url
                if _.isObject(sourcePath)
                    options = sourcePath
                throw new Error("#{url} is an absolute path. You must provide `sourceContext` and `outputContext` ") if !options.outputContext || !options.sourceContext
                urlAbs = path.join path.resolve(options.sourceContext), url
                if urlAbs = @map[urlAbs]
                    url = urlAbs.replace(path.resolve(options.outputContext), '').replace(/\\/g, '/')
                    url = utils.addCdn(url, @cdn)
            else
                urlAbs = path.resolve sourcePath, url
                if urlAbs = @map[urlAbs]
                    if _.isEmpty(@cdn)
                        url = path.relative(outputPath, urlAbs).replace(/\\/g, '/')
                    else
                        # 如果需要添加cdn, 则需要转为绝对路径
                        throw new Error("'#{url}' is a relative path. But you will add cdn, so you must provide `outputContext` to convert it to an absolute path") if !options.outputContext
                        url = urlAbs.replace(path.resolve(options.outputContext), '').replace(/\\/g, '/')
                        url = utils.addCdn(url, @cdn)
        "#{url}#{sufix}"

    ###*
     * 获取map
    ###
    getMap: ->
        @map

    ###*
    * 设置map
    ###
    setMap: (map, value) ->
        if value
            @map[map] = value
        else
            _.extend(@map, map)
        @

    ###*
     * 设置要处理的文件
    ###
    setFiles: (files) ->
        @files = if _.isString(files) then [files] else files
        @

    setCdn: (cdn) ->
        @cdn = if _.isString(cdn) then [cdn] else cdn
        @

###*
 * 单例
###
instance = {};
Processor.getInstance = (type) ->
    Processor = require("./#{utils.ucfirst(type)}Processor")
    instance[type] ?= new Processor

module.exports = Processor
