# Project internal
require "./version"
# Crystal internal
require "colorize"
# External
require "docopt"

doc = <<-DOCOPT
#{"stripansi".colorize.light_magenta} (quartz-utils) #{QuartzUtils::VERSION} - #{"Remove ANSI escape sequences".colorize.bold}

#{"Usage:".colorize.light_cyan.toggle(false)}
  stripansi [<text>]
  stripansi -h | --help
  stripansi --version

#{"Options:".colorize.light_cyan}
  -h --help                 Show this screen.
  --version                 Show version.

#{"Examples:".colorize.light_cyan}
  stripansi $(echo -e "\e[0m\e[01;36mbin\e[0m,\e[01;34mboot\e[0m,\e[30;42mtmp\e[0m")
  ls --color=always / | stripansi

#{"Project:".colorize.light_cyan}
  #{"author".colorize.underline} (https://pwn.by/noraj / https://twitter.com/noraj_rawsec)
  #{"source".colorize.underline} (https://github.com/noraj/quartz-utils)
  #{"documentation".colorize.underline} (https://noraj.github.io/quartz-utils)
DOCOPT
args = Docopt.docopt(doc, version: QuartzUtils::VERSION)

# This is nor authoritative nor exhaustive, but it's the most complete regexp I found
# cf. https://github.com/chalk/ansi-regex/blob/main/index.js
ANSI_REGEXP = "[\\x{001B}\\x{009B}][[\\]()#;?]*(?:(?:(?:(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]+)*|[a-zA-Z\\d]+(?:;[-a-zA-Z\\d\\/#&.:=?%@~_]*)*)?\\x{0007})|(?:(?:\\d{1,4}(?:;\\d{0,4})*)?[\\dA-PR-TZcf-nq-uy=><~]))"
text = ""
# if no args, read from STDIN
case input = args["<text>"]
when String
  text = input
else
  text = STDIN.gets_to_end
end

puts text.gsub(Regex.new(ANSI_REGEXP), "") unless text.nil?
