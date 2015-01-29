# Web-NoCache

重命名所有静态资源，并替换相应的引用路径，用于解决web上线后浏览器缓存静态资源的问题。

## Install

```
npm install web-nocache
```

## Usage

```coffeescript
NoCache = require('web-nocache').NoCache

noCache = new NoCache(
    sourceContext: './web' # 如果静态文件引用存在绝对路径，则必须指定webroot是什么
    outputContext: './build' # 同上，编译后的webroot是什么
)

noCache.processMedia('./web/edit.png', './build/[name].[hash:6].[ext]') # 处理图片
    .then ->
        noCache.processCss('./web/main.css', './build/[name].[hash:6].css') # 处理css
    .then ->
        noCache.processJs('./web/main.js', './build/[name].[hash:6].[ext]') # 处理js
    .then ->
        noCache.processTpl('./web/index.html', './build/[path][name].[ext]') # 最后处理模板
```

根据文件的依赖关系，处理顺序为：`image` -> `css` -> `js` -> `tpl`

如果传入数组则进行批量处理

编译后文件路径命名参考： [loader-utils](https://github.com/webpack/loader-utils)

### 给路径添加cdn

```coffeescript
NoCache = require('web-nocache').NoCache

noCache = new NoCache(
    sourceContext: './web' # 如果静态文件引用存在绝对路径，则必须指定webroot是什么
    outputContext: './build' # 同上，编译后的webroot是什么
    cdn: ['//s1.static.com', '//s2.static.com'] # 指定cdn列表, 静态资源将按一定的规律平均分配到各个cdn节点上
)

noCache.processMedia('./web/edit.png', './build/[name].[hash:6].[ext]') # 处理图片
    .then ->
        noCache.processCss('./web/main.css', './build/[name].[hash:6].css') # 处理css
    .then ->
        noCache.processJs('./web/main.js', './build/[name].[hash:6].[ext]') # 处理js
    .then ->
        noCache.processTpl('./web/index.html', './build/[path][name].[ext]') # 最后处理模板
```
