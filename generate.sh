#!/usr/bin/env ysh
# Ysh help: <https://www.oilshell.org/release/latest/doc/ysh-tour.html>

var SCRIPT_DIR = $(cd "$_this_dir" { pwd })

const targets = [
  {
    name: "x86_64-apple-darwin",
    image: "x86_64-apple-darwin-cross"
  },
  {
    name: "x86_64-pc-windows-gnu",
    image: "x86_64-pc-windows-gnu"
  },
  {
    name: "x86_64-unknown-linux-gnu",
    image: "x86_64-unknown-linux-gnu"
  },
  {
    name: "x86_64-unknown-linux-musl",
    image: "x86_64-unknown-linux-musl"
  },
  {
    name: "aarch64-unknown-linux-gnu",
    image: "aarch64-unknown-linux-gnu"
  },
  {
    name: "aarch64-apple-darwin",
    image: "aarch64-apple-darwin-cross"
  },
]

for target in (targets) {
  var name = target["name"]
  var image = target["image"]
  echo "generating $name"
  cd $SCRIPT_DIR {
    cd cross {
      if (name === "x86_64-apple-darwin" || name === "aarch64-apple-darwin") {
        cargo build-docker-image "${image}" --tag local --engine docker --build-arg "MACOS_SDK_URL=https://github.com/joseluisq/macosx-sdks/releases/download/10.15/MacOSX10.15.sdk.tar.xz"
      } else {
        cargo build-docker-image "${image}" --tag local --engine docker
      }
      var workaround = ""
      if (name === "x86_64-apple-darwin") {
        setvar workaround = """
        # Workaround for <https://github.com/cross-rs/cross-toolchains/issues/31>
        ENV AR_x86_64_apple_darwin=x86_64-apple-darwin19-ar
        ENV CC_x86_64_apple_darwin=x86_64-apple-darwin19-clang
        ENV CXX_x86_64_apple_darwin="x86_64-apple-darwin19-clang++"
        ENV CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER=x86_64-apple-darwin19-clang
        """
      }
      if (name === "aarch64-apple-darwin") {
        # TODO: which env vars are needed, if any?
      }
    }
    mkdir -p "guest-${name}"
    cd "guest-${name}" {
      cat >build.sh <<< """
      #!/usr/bin/env ysh
      var SCRIPT_DIR = \$(cd "\$_this_dir" { pwd })

      cd \$SCRIPT_DIR {
        var tag = \$(cat ../tag.txt)
        docker build --tag="demurgos/rust-cross-guest-${name}:\${tag}" .
      }
      """
      cat >publish.sh <<< """
      #!/usr/bin/env ysh
      var SCRIPT_DIR = \$(cd "\$_this_dir" { pwd })

      cd \$SCRIPT_DIR {
        ./build.sh
        var tag = \$(cat ../tag.txt)
        docker push "demurgos/rust-cross-guest-${name}:\${tag}"
      }
      """
      # https://stackoverflow.com/questions/61388002/how-to-avoid-question-during-the-docker-build
      cat >Dockerfile <<< """
      FROM ghcr.io/cross-rs/${image}:local
      LABEL org.opencontainers.image.authors="Charles Samborski <demurgos@demurgos.net>"
      ARG DEBIAN_FRONTEND=noninteractive
      RUN apt-get update && apt-get install --assume-yes --quiet \\
        yarnpkg \\
        && rm -rf /var/lib/apt/lists/* \\
        && ln -s ./yarnpkg /usr/bin/yarn
      ${workaround}
      CMD ["/bin/sh"]
      """
      echo "*" >.dockerignore
      chmod +x build.sh
      chmod +x publish.sh
    }
  }
}
