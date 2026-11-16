## Build for Windows

Using wsl, install `x86_64-w64-mingw32-gcc`

```
sudo apt install gcc-mingw-w64-x86-64
```

Then compile the dll:

```
x86_64-w64-mingw32-gcc -shared -O2 -s -o build/flitelib.dll lib.c -Ilib/include -Llib/build/x86_64-mingw32/lib -lflite_cmu_us_kal -lflite_usenglish -lflite_cmulex -lflite -lm -static-libgcc -Wl,--gc-sections
```