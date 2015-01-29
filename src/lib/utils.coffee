# @fileoverview
# @author javey
# @date 14-12-16

Promise = require 'bluebird'
fs = Promise.promisifyAll(require 'fs-extra')
Path = require 'path'
_ = require 'lodash'

utils = module.exports =

    writeFile: (file, content) ->
        dirname = Path.dirname file
        utils.fileExists dirname
        .then (exists) ->
            if !exists
                fs.mkdirpAsync dirname
        .then ->
            fs.writeFileAsync file, content

    fileExists: (file) ->
        new Promise((resolve) ->
            fs.exists file, (exists) ->
                resolve exists
        )

    ucfirst: (str) ->
        str += ''
        str.charAt(0).toUpperCase() + str.substring(1)

    isPathUrl: (url) ->
        url && !~url.indexOf('data:') && !~url.indexOf('about:') && !~url.indexOf('://')

    isAbsolute: (pathName) ->
        pathName.charAt(0) == '/'

    addCdn: (path, cdn) ->
        if !_.isEmpty(cdn)
            fileName = Path.basename(path, Path.extname(path))
            index = (fileName.charCodeAt(0) + fileName.charCodeAt(fileName.length - 1)) % cdn.length
            path = cdn[index] + path
        path
