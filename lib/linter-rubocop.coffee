linterPath = atom.packages.getLoadedPackage("linter").path
Linter = require "#{linterPath}/lib/linter"
findFile = require "#{linterPath}/lib/util"

class LinterRubocop extends Linter
  # The syntax that the linter handles. May be a string or
  # list/tuple of strings. Names should be all lowercase.
  @syntax: ['source.ruby', 'source.ruby.rails', 'source.ruby.rspec']

  # A string, list, tuple or callable that returns a string, list or tuple,
  # containing the command line (with arguments) used to lint.
  cmd: atom.config.get 'linter-rubocop.cmd'

  linterName: 'rubocop'

  # A regex pattern used to extract information from the executable's output.
  regex:
    '.+?:(?<line>\\d+):(?<col>\\d+): ' +
    '((?<warning>[RCW])|(?<error>[EF])): ' +
    '(?<message>.+)'

  options: ['executablePath']

  constructor: (editor)->
    super(editor)

    if editor.getGrammar().scopeName == 'source.ruby.rails'
      @cmd += " --rails"

    config = findFile(@cwd, '.rubocop.yml')
    if config
      @cmd += " --config #{config}"

module.exports = LinterRubocop
