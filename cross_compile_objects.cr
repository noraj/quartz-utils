require "yaml"

tiers_1 = %w[x86_64-linux-gnu x86_64-linux-musl x86_64-darwin]
tiers_2 = %w[aarch64-linux-gnu aarch64-linux-musl arm-linux-gnueabihf i386-linux-gnu i386-linux-musl x86_64-openbsd x86_64-freebsd aarch64-darwin]
platforms = tiers_1 + tiers_2

shard = {} of YAML::Any => YAML::Any
File.open("shard.yml") do |file|
  shard = YAML.parse(file)
end
executables = shard["executables"].as_a

executables.each do |executable|
  platforms.each do |platform|
    puts "[+] #{executable}-#{platform}"
    system("docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:1.13.1-alpine crystal build src/#{executable}.cr --release --static --no-debug -o bin/#{executable}-#{platform} --cross-compile --target #{platform}")
  end
end
