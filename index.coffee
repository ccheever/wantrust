
acorn = require 'acorn'
walk = require 'acorn/util/walk'
walkall = require 'walkall'

BLACKLIST = [
  'BreakStatement'
  'ContinueStatement'
  'DoWhileStatement'
  'DebuggerStatement'
  'ForStatement'
  'ForInStatement'
  'FunctionDeclaration'
  'FunctionExpression'
  'ReturnStatement'
  'ThisExpression' # Hmm... what to do with this
  'ThrowStatement'
  'TryStatement'
  'WhileStatement'
  'WithStatement'
  ]


validate = (program) ->
  err = null
  try
    ast = acorn.parse program
  catch e
    return ['ParseError', e]
  try
    walk.simple ast, (walkall.makeVisitors (node) ->
        #console.log "Found node type #{ node.type }"),
        if node.type in BLACKLIST
          err = new Error "Node type not allowed: #{ node.type }"
          err.type = node.type
          err.start = node.start
          err.end = node.end
          throw err
      ),
      walkall.traversers
  catch e
    return ['IllegalConstructError', e]
  err

module.exports = validate

###
# Examples
module.exports.prog1 = "for (var i = 0; i < 10; i++) { console.log(i); }"
module.exports.prog2 = "while (true) console.log"
module.exports.prog3 = "))(((syntax''ERROR"
module.exports.prog4 = "x = 1; y = 2; z = x + y;"
###
