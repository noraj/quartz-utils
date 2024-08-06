# Project internal
require "./version"
# Crystal internal
require "colorize"
# External
require "docopt"

doc = <<-DOCOPT
#{"lf2crlf".colorize.light_magenta} (quartz-utils) #{QuartzUtils::VERSION} - #{"Convert LF to CRLF".colorize.bold}

#{"Usage:".colorize.light_cyan.toggle(false)}
  lf2crlf [<text>]
  lf2crlf -h | --help
  lf2crlf --version

#{"Options:".colorize.light_cyan}
  -h --help                 Show this screen.
  --version                 Show version.

#{"Examples:".colorize.light_cyan}
  lf2crlf  "$(echo -n "saut\nde\nligne")"
  echo -n "saut\nde\nligne" | lf2crlf

#{"Project:".colorize.light_cyan}
  #{"author".colorize.underline} (https://pwn.by/noraj / https://twitter.com/noraj_rawsec)
  #{"source".colorize.underline} (https://github.com/noraj/quartz-utils)
  #{"documentation".colorize.underline} (https://noraj.github.io/quartz-utils)
DOCOPT
args = Docopt.docopt(doc, version: QuartzUtils::VERSION)

text = ""
# if no args, read from STDIN
case input = args["<text>"]
when String
  text = input
else
  text = STDIN.gets_to_end
end

print text.gsub("\n", "\r\n") unless text.nil?
