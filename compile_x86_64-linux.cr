require "yaml"

platforms = %w[x86_64-linux-gnu x86_64-linux-musl]

shard = {} of YAML::Any => YAML::Any
File.open("shard.yml") do |file|
  shard = YAML.parse(file)
end
executables = shard["executables"].as_a

executables.each do |executable|
  platforms.each do |platform|
    puts "[+] #{executable}-#{platform}"
    build_cmd = "crystal build src/#{executable}.cr --release --static --no-debug -o bin/#{executable}-#{platform} --cross-compile --target #{platform}"
    puts "  [+] #{build_cmd}"
    cc = `#{build_cmd}`
    puts "  [+] #{cc}"
    system(cc)
  end
end
