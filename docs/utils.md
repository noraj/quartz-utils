# Utilities

- `url2host`: Extract host from URL
- `stripansi`: Remove ANSI escape sequences

## url2host

URL as argument:

```text
➜ url2host https://pwn.by/noraj
pwn.by
```

URL from STDIN:

```text
➜ echo https://pwn.by/noraj | url2host
pwn.by
```

Multiple URLs as argument:

```text
➜ url2host https://pwn.by/noraj https://github.com/noraj
pwn.by
github.com
```

Multiple URLs from STDIN:

```text
➜ lynx -dump -listonly -nonumbers -hiddenlinks=merge https://pwn.by/noraj/profiles.html | url2host | sort -u
alternativeto.net
attackerkb.com
blackarch.org
ctftime.org
cxsecurity.com
fontawesome.com
github.com
gitlab.com
gulpjs.com
jenil.github.io
keybase.io
middlemanapp.com
noraj.artstation.com
odysee.com
packetstormsecurity.com
playeur.com
pwn.by
slim-lang.com
stackexchange.com
twitter.com
vincentgarreau.com
vizuaalog.github.io
www.exploit-db.com
www.offensive-security.com
www.reddit.com
www.youtube.com
```

Custom delimiter:

```text
➜ url2host "https://pwn.by/noraj|https://github.com/noraj" -d "|"
pwn.by
github.com

➜ echo "https://pwn.by/noraj,https://github.com/noraj" | url2host -d ","
pwn.by
github.com
```

## stripansi

Text as argument:

```
➜ stripansi $(echo -e "\e[0m\e[01;36mbin\e[0m,\e[01;34mboot\e[0m,\e[30;42mtmp\e[0m")
bin,boot,tmp
```

Text from STDIN:

```
➜ ls --color=always / | bin/stripansi
bin
boot
dev
efi
etc
home
lib
…
```
