require=(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({"+7HrWD":[function(require,module,exports){
module.exports = {
  init: function() {
    var loader;
    loader = require('./loader');
    return console.warn('init');
  }
};

module.exports.init();


},{"./loader":"m6rLeB"}],"core":[function(require,module,exports){
module.exports=require('+7HrWD');
},{}],"m6rLeB":[function(require,module,exports){
module.exports = {
  load: function(moduleName) {
    return require(moduleName);
  }
};


},{}]},{},["+7HrWD"])
//# sourceMappingURL=data:application/json;base64,eyJ2ZXJzaW9uIjozLCJmaWxlIjoiZ2VuZXJhdGVkLmpzIiwic291cmNlcyI6WyIvVXNlcnMvbWF0dGRlYW4vZGV2L3ZhbnRhZ2UvYmFua2luZy9zdWJtb2R1bGVzL3RyYWJpYW4td2ViYXBwLWNvcmUvbm9kZV9tb2R1bGVzL3dhdGNoaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyaWZ5L25vZGVfbW9kdWxlcy9icm93c2VyLXBhY2svX3ByZWx1ZGUuanMiLCIvVXNlcnMvbWF0dGRlYW4vZGV2L3ZhbnRhZ2UvYmFua2luZy9zdWJtb2R1bGVzL3RyYWJpYW4td2ViYXBwLWNvcmUvYXBwL2luZGV4LmNvZmZlZSIsIi9Vc2Vycy9tYXR0ZGVhbi9kZXYvdmFudGFnZS9iYW5raW5nL3N1Ym1vZHVsZXMvdHJhYmlhbi13ZWJhcHAtY29yZS9hcHAvbG9hZGVyLmNvZmZlZSJdLCJuYW1lcyI6W10sIm1hcHBpbmdzIjoiQUFBQTtBQ0FBLE1BQU0sQ0FBQyxPQUFQLEdBRUU7QUFBQSxFQUFBLElBQUEsRUFBTSxTQUFBLEdBQUE7QUFFSixRQUFBLE1BQUE7QUFBQSxJQUFBLE1BQUEsR0FBUyxPQUFBLENBQVEsVUFBUixDQUFULENBQUE7V0FFQSxPQUFPLENBQUMsSUFBUixDQUFhLE1BQWIsRUFKSTtFQUFBLENBQU47Q0FGRixDQUFBOztBQUFBLE1Bc0JNLENBQUMsT0FBTyxDQUFDLElBQWYsQ0FBQSxDQXRCQSxDQUFBOzs7Ozs7QUNBQSxNQUFNLENBQUMsT0FBUCxHQUVFO0FBQUEsRUFBQSxJQUFBLEVBQU0sU0FBQyxVQUFELEdBQUE7V0FJSixPQUFBLENBQVEsVUFBUixFQUpJO0VBQUEsQ0FBTjtDQUZGLENBQUEiLCJzb3VyY2VzQ29udGVudCI6WyIoZnVuY3Rpb24gZSh0LG4scil7ZnVuY3Rpb24gcyhvLHUpe2lmKCFuW29dKXtpZighdFtvXSl7dmFyIGE9dHlwZW9mIHJlcXVpcmU9PVwiZnVuY3Rpb25cIiYmcmVxdWlyZTtpZighdSYmYSlyZXR1cm4gYShvLCEwKTtpZihpKXJldHVybiBpKG8sITApO3Rocm93IG5ldyBFcnJvcihcIkNhbm5vdCBmaW5kIG1vZHVsZSAnXCIrbytcIidcIil9dmFyIGY9bltvXT17ZXhwb3J0czp7fX07dFtvXVswXS5jYWxsKGYuZXhwb3J0cyxmdW5jdGlvbihlKXt2YXIgbj10W29dWzFdW2VdO3JldHVybiBzKG4/bjplKX0sZixmLmV4cG9ydHMsZSx0LG4scil9cmV0dXJuIG5bb10uZXhwb3J0c312YXIgaT10eXBlb2YgcmVxdWlyZT09XCJmdW5jdGlvblwiJiZyZXF1aXJlO2Zvcih2YXIgbz0wO288ci5sZW5ndGg7bysrKXMocltvXSk7cmV0dXJuIHN9KSIsIm1vZHVsZS5leHBvcnRzID1cblxuICBpbml0OiAtPlxuXG4gICAgbG9hZGVyID0gcmVxdWlyZSAnLi9sb2FkZXInXG5cbiAgICBjb25zb2xlLndhcm4gJ2luaXQnXG5cbiAgICAjIGdsb2JhbC5fID0gcmVxdWlyZSAndW5kZXJzY29yZSdcblxuICAgICMgZ2xvYmFsLiQgPSBnbG9iYWwualF1ZXJ5ID0gcmVxdWlyZSAnanF1ZXJ5J1xuXG4gICAgIyBnbG9iYWwuQmFja2JvbmUgPSByZXF1aXJlICdiYWNrYm9uZSdcblxuICAgICMgZ2xvYmFsLkJhY2tib25lLiQgPSBnbG9iYWwuJFxuXG4gICAgIyBnbG9iYWwubW9tZW50ID0gcmVxdWlyZSAnbW9tZW50J1xuXG4gICAgIyByZXF1aXJlICdzZWxlY3QyJ1xuXG4gICAgIyByZXF1aXJlKCdjb3JlL2NvbXBvbmVudHMvcmVhY3QnKS5pbml0KClcblxubW9kdWxlLmV4cG9ydHMuaW5pdCgpXG4iLCJtb2R1bGUuZXhwb3J0cyA9XG5cbiAgbG9hZDogKG1vZHVsZU5hbWUpIC0+XG5cbiAgICAjIHJlcXVpcmUgJy4vaW5kZXgnXG5cbiAgICByZXF1aXJlIG1vZHVsZU5hbWVcbiJdfQ==
