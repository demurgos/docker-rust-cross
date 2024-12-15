# Docker image for Rust cross compilation

This is my custom image for Rust cross compilation.

```
# pacman -S docker-buildx docker
git submodule update --init --recursive
./generate.sh
./host/publish.sh
./guest-x86_64-apple-darwin/publish.sh
./guest-x86_64-pc-windows-gnu/publish.sh
./guest-x86_64-unknown-linux-gnu/publish.sh
./guest-x86_64-unknown-linux-musl/publish.sh
./guest-aarch64-unknown-linux-gnu/publish.sh
./guest-aarch64-apple-darwin/publish.sh
```

Images:
- `rust-cross-host`: Host image
- `rust-cross-guest-x86_64-apple-darwin`: Guest image for `x86_64-apple-darwin`
- `rust-cross-guest-x86_64-pc-windows-gnu`: Guest image for `x86_64-pc-windows-gnu`
- `rust-cross-guest-x86_64-unknown-linux-gnu`: Guest image for `x86_64-unknown-linux-gnu`
- `rust-cross-guest-x86_64-unknown-linux-musl`: Guest image for `x86_64-unknown-linux-musl`
- `rust-cross-guest-aarch64-unknown-linux-gnu`: Guest image for `aarch64-unknown-linux-gnu`
- `rust-cross-guest-aarch64-apple-darwin`: Guest image for `aarch64-apple-darwin`
