# Project internal
require "./version"
# Crystal internal
require "uri"
require "colorize"
# External
require "docopt"

doc = <<-DOCOPT
#{"url2host".colorize.light_magenta} (quartz-utils) #{QuartzUtils::VERSION} - #{"Extract host from URL".colorize.bold}

#{"Usage:".colorize.light_cyan.toggle(false)}
  url2host [-d CHAR] [<url>...]
  url2host -h | --help
  url2host --version

#{"Options:".colorize.light_cyan}
  -d CHAR --delimiter=CHAR  Set delimiter.
  -h --help                 Show this screen.
  --version                 Show version.

#{"Examples:".colorize.light_cyan}
  url2host https://pwn.by/noraj
  echo https://pwn.by/noraj | url2host

#{"Project:".colorize.light_cyan}
  #{"author".colorize.underline} (https://pwn.by/noraj / https://twitter.com/noraj_rawsec)
  #{"source".colorize.underline} (https://github.com/noraj/quartz-utils)
  #{"documentation".colorize.underline} (https://noraj.github.io/quartz-utils)
DOCOPT
args = Docopt.docopt(doc, version: QuartzUtils::VERSION)

DEFAULT_DELIMITER = "\n"
sources = [] of String
# if no args, read from STDIN
case urls_vartype = args["<url>"] # (Array(String) | Bool | Int32 | String | Nil)
when Nil, Bool, Int32
  sources = STDIN.gets_to_end
when Array(String)
  if urls_vartype.empty?
    sources = STDIN.gets_to_end
  else
    sources = urls_vartype.join(DEFAULT_DELIMITER)
  end
when String
  sources = urls_vartype
end
delimiter = args["--delimiter"].nil? ? DEFAULT_DELIMITER : args["--delimiter"].to_s
sources.as(String).split(delimiter, remove_empty: true).each do |source|
  host = URI.parse(source).host
  puts host unless host.nil?
end
