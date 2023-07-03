# Init

```
git clone https://github.com/adastreamer/wagent.git

git submodule update --init --recursive

```

# Build using Docker

```

#
# for static linked binaries
#
docker build . --tag wagent --target static

#
# for dynamic linked binaries
#
docker build . --tag wagent --target dynamic
```

# Build manually

```

#
# for static linked binaries (not working for MacOS)
#
export CFLAGS_EXTRA="-static -pthread"

make rebuild
```
