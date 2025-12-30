ifeq ($(strip $(GBA_LLVM_PATH)),)
$(error "Please set GBA_LLVM_PATH in your environment. export GBA_LLVM_PATH=<path to>/gba-llvm-devkit-1-Darwin-arm64")
endif

NAME = RunCat
BIN = $(GBA_LLVM_PATH)/bin
SWIFT_FILES = $(wildcard Sources/$(NAME)/*.swift)
SWIFT_FLAGS = -wmo \
	-enable-experimental-feature Embedded \
	-enable-experimental-feature Volatile \
	-target armv4t-none-none-eabi \
	-parse-as-library \
	-Xfrontend -internalize-at-link \
	-Xfrontend -disable-stack-protector \
	-Xfrontend -disable-objc-interop \
	-lto=llvm-thin
CFLAGS = -O3 \
	-mthumb \
	-mfpu=none \
	-fno-exceptions \
	-fno-rtti \
	-D_LIBCPP_AVAILABILITY_HAS_NO_VERBOSE_ABORT \
	-fshort-enums
LFLAGS = -lcrt0-gba
LINKER_FLAGS = -T \
	gba_cart.ld \
	--sysroot \
	$(GBA_LLVM_PATH)/lib/clang-runtimes/arm-none-eabi/armv4t \
	-fuse-ld=lld

all: $(NAME).gba

$(NAME).gba: $(NAME).elf
	$(BIN)/llvm-objcopy -O binary $^ $@
	$(BIN)/gbafix $@

$(NAME).elf: $(SWIFT_FILES)
	swiftc -o $@ $(SWIFT_FILES) \
		$(SWIFT_FLAGS) \
		$(addprefix -Xcc ,$(CFLAGS)) \
		$(addprefix -Xlinker ,$(LFLAGS)) \
		$(addprefix -Xclang-linker ,$(LINKER_FLAGS))

run: $(NAME).gba
	mGBA $<

.PHONY: all clean run
clean:
	rm -f *.o *.elf *.gba *.bc *.sav
