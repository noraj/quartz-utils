# Project internal
require "./version"
# Crystal internal
require "colorize"
# External
require "docopt"

doc = <<-DOCOPT
#{"crlf2lf".colorize.light_magenta} (quartz-utils) #{QuartzUtils::VERSION} - #{"Convert CRLF to LF".colorize.bold}

#{"Usage:".colorize.light_cyan.toggle(false)}
  crlf2lf [<text>]
  crlf2lf -h | --help
  crlf2lf --version

#{"Options:".colorize.light_cyan}
  -h --help                 Show this screen.
  --version                 Show version.

#{"Examples:".colorize.light_cyan}
  crlf2lf "$(echo -n "saut\r\nde\r\nligne")"
  echo -n "saut\r\nde\r\nligne" | crlf2lf

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

print text.gsub("\r\n", "\n") unless text.nil?
