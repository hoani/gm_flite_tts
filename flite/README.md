This directory builds gamemaker compatable libraries. The built libraries are then included in the flitetts gamemaker project.

The instructions below explain how to build for each supported platform.

## Build for Windows

Using wsl, install `x86_64-w64-mingw32-gcc`

```
sudo apt install gcc-mingw-w64-x86-64
```

Then compile the dll:

```
x86_64-w64-mingw32-gcc -shared -O2 -s -o build/flitelib.dll lib.c -Ilib/include -Llib/build/x86_64-mingw32/lib -lflite_cmu_us_kal -lflite_usenglish -lflite_cmulex -lflite -lm -static-libgcc -Wl,--gc-sections
```


## Build for HTML5

We need to install emscripten - https://emscripten.org/docs/getting_started/downloads.html tools for this.

Then compile:

```
emcc -O2 lib.c -Ilib/include -Llib/build/emcc/lib -lflite_cmu_us_kal -lflite_usenglish -lflite_cmulex -lflite -lm -sMODULARIZE=1 -sEXPORT_NAME=FliteModule -sSINGLE_FILE=1 -sENVIRONMENT=web -sALLOW_MEMORY_GROWTH=1 -sFORCE_FILESYSTEM=1 -sEXPORTED_RUNTIME_METHODS=ccall,HEAPU8,FS -o build/flitelib.js
```

## Build for MacOS

Probably need some xcode setup, like:
```
xcode-select --install
```

Then compile:

```
clang -dynamiclib -O2 -o build/flitelib.dylib lib.c -Ilib/include -Llib/build/aarch64-darwin24.1.0/lib -lflite_cmu_us_kal -lflite_usenglish -lflite_cmulex -lflite -lm -Wl,-dead_strip 
```

## Build for ubuntu

Tested on Ubuntu 24.04 setup following https://gamemaker.io/en/help/articles/setting-up-for-ubuntu.

```
gcc -shared -fPIC -O2 -o build/flitelib.so lib.c -s -fvisibility=hidden -Ilib/include -Llib/build/x86_64-linux-gnu/lib -lflite_cmu_us_kal -lflite_usenglish -lflite_cmulex -lflite -lm -static-libgcc -Wl,--no-undefined
```