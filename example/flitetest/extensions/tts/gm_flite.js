var _flite = null;

function tts_init() {
  FliteModule().then(function (m) { _flite = m; m._tts_init(); });
  return 1;
}

function tts_ready() { 
    return _flite ? 1 : 0; 
}

function tts_synth_b64(text) {
  if (!_flite) {
    return "";
  }
  var n = _flite.ccall("tts_synth", "number", ["string"], [text]);
  if (!n) return "";
  var ptr = _flite._tts_samples_ptr();
  var bytes = _flite.HEAPU8.subarray(ptr, ptr + n * 2);
  var s = "";
  for (var i = 0; i < bytes.length; i += 8192) {
    s += String.fromCharCode.apply(null, bytes.subarray(i, i + 8192));
  }
    
  return btoa(s);
}

function tts_get_rate() {
  if (!_flite) {
    return 0;
  }
    return _flite._tts_get_rate(); 
}

function tts_select_voice(path) {
  if (!_flite) {
    return 0;
  }
  console.log("FS root:", _flite.FS.readdir("/"));
  var full = "/" + path;
  return _flite.ccall("tts_select_voice", "number", ["string"], [full]);
}

function tts_register_voice(path, b64) {
  console.log("register called:", path, "b64 length:", b64 ? b64.length : b64, "same module:", _flite === window._fliteDebug);
  if (!_flite) {
    return 0;
  }
  
  try {
    var bin = atob(b64);
    var bytes = new Uint8Array(bin.length);
    for (var i = 0; i < bin.length; i++){
      bytes[i] = bin.charCodeAt(i);
    }
    var full = "/" + path;
    var dir = full.substring(0, full.lastIndexOf("/"));
    if (dir) _flite.FS.mkdirTree(dir);
    _flite.FS.writeFile(full, bytes);
    console.log("after write:", _flite.FS.readdir("/"));
    return 1;
  } catch (e) {
    console.error("tts_register_voice failed:", e);
    return 0;
  }
}

function tts_default_voice() { 
  if (!_flite) {
    return 0;
  }
  return _flite._tts_default_voice(); 
}

