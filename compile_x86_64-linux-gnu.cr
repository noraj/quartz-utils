require "yaml"

platforms = %w[x86_64-linux-gnu]

shard = {} of YAML::Any => YAML::Any
File.open("shard.yml") do |file|
  shard = YAML.parse(file)
end
executables = shard["executables"].as_a

executables.each do |executable|
  platforms.each do |platform|
    puts "[+] #{executable}-#{platform}"
    cc = `docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:1.12.1-alpine crystal build src/#{executable}.cr --release --static --no-debug -o bin/#{executable}-#{platform} --cross-compile --target #{platform}`
    system(cc)
  end
end
