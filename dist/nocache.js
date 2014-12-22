// Generated by CoffeeScript 1.8.0
var NoCache, Processor;

Processor = require('./lib/Processor');

NoCache = (function() {
  function NoCache(options) {
    this.options = options != null ? options : {
      sourceContext: '',
      outputContext: ''
    };
  }

  NoCache.prototype.processMedia = function(pattern) {
    return Processor.getInstance('media').write(pattern, this.options);
  };

  NoCache.prototype.processCss = function(pattern) {
    return Processor.getInstance('css').write(pattern, this.options);
  };

  NoCache.prototype.processJs = function(pattern) {
    return Processor.getInstance('js').write(pattern, this.options);
  };

  NoCache.prototype.processTpl = function(pattern) {
    return Processor.getInstance('tpl').write(pattern, this.options);
  };

  return NoCache;

})();

module.exports = {
  NoCache: NoCache,
  Processor: Processor
};