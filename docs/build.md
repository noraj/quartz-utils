# Build

## Dynamic

Install dependencies:

```shell
shards install --production
```

Build with `shards`:

```shell
shards build --production --release --no-debug
```

Build with `crystal` (warning: binaries will be output in the current directory, not in `bin/`):

```shell
crystal build src/*.cr --release --no-debug
```

## Static

Install dependencies:

```shell
shards install --production
```

As the [Crystal documentations](https://crystal-lang.org/reference/1.12/man/crystal/index.html#creating-a-statically-linked-executable) says:

> Building fully statically linked executables is currently only supported on Alpine Linux.

For that purpose, the [documentation](https://crystal-lang.org/reference/1.12/guides/static_linking.html#musl-libc) recommends using `musl-libc`:

> Official [Docker Images based on Alpine Linux](https://crystal-lang.org/2020/02/02/alpine-based-docker-images.html) are available on Docker Hub at [crystallang/crystal](https://hub.docker.com/r/crystallang/crystal/). The latest release is tagged as crystallang/crystal:latest-alpine.

As an example replace the local build:

```shell
# With Shards (in bin/)
shards build --production --release --static --no-debug
# With Crystal (in ./)
crystal build src/*.cr --release --static --no-debug
```

with

```shell
# With Shards (in bin/)
docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:1.12.1-alpine \
    shards build --production --release --static --no-debug

# With Crystal (in ./)
docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:1.12.1-alpine \
    crystal build src/*.cr --release --static --no-debug
```

Since you are cross-compiling from a docker container, it would be wiser to ensure to provide the correct [cross compilation flags](https://crystal-lang.org/reference/1.12/syntax_and_semantics/cross-compilation.html).

Find your platform with `llvm-config --host-target` (examples: `x86_64-pc-linux-gnu` on a modern Linux host) on your host or the target (see [platform support](https://crystal-lang.org/reference/1.12/syntax_and_semantics/platform_support.html) and [LLVM - Cross-compilation using Clang](https://clang.llvm.org/docs/CrossCompilation.html)).

So change from (unfortunately `shards` doesn't support cross-compilation)

```shell
crystal build src/*.cr --release --static --no-debug --cross-compile --target x86_64-pc-linux-gnu

cc *.o -o * -rdynamic -static -L/usr/bin/../lib/crystal -lpcre2-8 -lgc -lpthread -ldl -lpthread -levent -lrt -lpthread -ldl
```

to

```shell
docker run --rm -it -v $PWD:/workspace -w /workspace crystallang/crystal:1.12.1-alpine \
    crystal build src/*.cr --release --static --no-debug \
   -o bin/*-x86_64-pc-linux-gnu --cross-compile --target x86_64-pc-linux-gnu

cc bin/*-x86_64-pc-linux-gnu.o -o bin/*-x86_64-pc-linux-gnu -rdynamic -static -L/usr/bin/../lib/crystal -lpcre -lm -lgc -lpthread -levent -lrt -lpthread -ldl
```

Note: the second line must be executed on the target platform.

Finally, check your binary is fully static:

```shell
ldd bin/*-x86_64-pc-linux-gnu
        not a dynamic executable
```

Note: of course, you need to replace `*` with the name of a utility. For more convenience, `cross_compile_objects.cr` (`crystal run cross_compile_objects.cr`) script will compile all pre-compiled objects for all tier 1 & 2 platforms.

## Release

With this we can compile a pre-compiled object without needing Crystal, Docker or managing the dependencies.

### 64-bit Linux (kernel 2.6.18+, GNU libc)

```shell
cc *-x86_64-linux-gnu.o -o *-x86_64-linux-gnu -rdynamic -static -L/usr/lib/crystal -lpcre -lm -lgc -lpthread -levent -lrt -lpthread -ldl
```

### ARM 64-bit Linux (GNU libc, hardfloat)

```shell
cc *-aarch64-linux-gnu.o -o *-aarch64-linux-gnu -rdynamic -static -L/usr/lib/crystal -lpcre -lm -lgc -lpthread -levent -lrt -lpthread -ldl
```

### ARM 64-bit Linux (MUSL libc, hardfloat)

```shell
cc *-aarch64-linux-musl.o -o *-aarch64-linux-musl -rdynamic -static -L/usr/lib/crystal -lpcre -lgc -levent
```

### ARM 32-bit Linux (GNU libc, hardfloat)

Dependencies Debian 11: `apt install libpcre3-dev libgc-dev libevent-dev`

```shell
cc *-arm-linux-gnueabihf.o -o *-arm-linux-gnueabihf -rdynamic -static -L/usr/lib/crystal -lpcre -lm -lgc -lpthread -levent -lpthread -ldl
```

### 32-bit Linux (kernel 2.6.18+, GNU libc)

```shell
cc *-i386-linux-gnu.o -o *-i386-linux-gnu -rdynamic -static -L/usr/lib/crystal -lpcre -lm -lgc -lpthread -levent -lrt -lpthread -ldl
```

### 32-bit Linux (MUSL libc)

```shell
cc *-i386-linux-musl.o -o *-i386-linux-musl -rdynamic -static -L/usr/lib/crystal -lpcre -lgc -levent
```

### 64-bit Linux (MUSL libc)

```shell
cc *-x86_64-linux-musl.o -o *-x86_64-linux-musl -rdynamic -static -L/usr/lib/crystal -lpcre -lgc -levent
```

### 64-bit OpenBSD (6.x)

```shell
cc *-x86_64-openbsd.o -o *-x86_64-openbsd -rdynamic -static -L/usr/lib/crystal -lpcre -lm -lgc -lpthread -levent_extra -levent_core -lc++abi -lpthread -liconv
```

### 64-bit FreeBSD (12.x)

```
cc *-x86_64-freebsd.o -o *-x86_64-freebsd -rdynamic -static -L/usr/lib/crystal -lpcre -lm -lgc-threaded -lpthread -levent -lpthread
```

### 64-bit OSX (10.7+, Lion+)

```shell
cc *-x86_64-darwin.o -o *-x86_64-darwin -rdynamic -static -L/usr/lib/crystal -lpcre -lgc -levent -liconv
```

### ARM 64-bit OSX (Apple Silicon)

```shell
cc *-aarch64-darwin.o -o *-aarch64-darwin -rdynamic -static -L/usr/lib/crystal -lpcre -lgc -levent -liconv
```
