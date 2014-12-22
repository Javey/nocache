# @fileoverview
# @author javey
# @date 14-12-16

Processor = require './Processor'
Promise = require 'bluebird'
fs = require 'fs'
path = require 'path'
_ = require 'lodash'

class MediaProcessor extends Processor
    constructor: () ->
        super arguments...
        @types = {};

    _readFile: (file) ->
        Promise.promisify(fs.readFile)(file)

    ###*
     * 设置要处理的文件，记录处理过的文件类型
    ###
    setFiles: (files) ->
        super files
        _.each(@files, (file) =>
            ext = path.extname file
            @types[ext.substring(1)] = true if ext
        )
        @

    getTypes: () ->
        _.keys(@types)

module.exports = MediaProcessor