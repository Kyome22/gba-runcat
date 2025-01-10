#!/bin/zsh
/Library/Developer/Toolchains/swift-latest.xctoolchain/usr/bin/swiftc \
  -o RunCat.elf Sources/runcat/*.swift \
  -wmo -enable-experimental-feature Embedded \
  -target armv4t-none-none-eabi \
  -Xfrontend -internalize-at-link \
  -lto=llvm-thin \
  -Xcc -mthumb \
  -Xcc -mfpu=none \
  -Xcc -fno-exceptions \
  -Xcc -fno-rtti \
  -Xcc -D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT \
  -Xcc -fshort-enums \
  -Xlinker -lcrt0-gba \
  -Xclang-linker -T \
  -Xclang-linker gba_cart.ld \
  -Xclang-linker --sysroot \
  -Xclang-linker ../gba-llvm-devkit-1-Darwin-arm64/lib/clang-runtimes/arm-none-eabi/armv4t
