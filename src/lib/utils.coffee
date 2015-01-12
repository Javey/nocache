# @fileoverview
# @author javey
# @date 14-12-16

Promise = require 'bluebird'
fs = Promise.promisifyAll(require 'fs-extra')
path = require 'path'

utils = module.exports =

    writeFile: (file, content) ->
        dirname = path.dirname file
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
