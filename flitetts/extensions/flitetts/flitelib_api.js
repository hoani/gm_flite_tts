// Provides access to emcc compiled flitelib using methods which comply with Gamemaker extensions

var _flite = null;

function flitelib_init() {
  FliteModule().then(function (m) { _flite = m; m._flitelib_init(); });
  return 1;
}

// This is for gamemaker to check that flite is actually ready - I don't think this takes very long... but better than panicking as soon as the game starts.
function flitelib_ready() { 
    return _flite ? 1 : 0; 
}

// synthesizes and returns the waveform data encoded as base64 - this is necessary so gamemaker doesn't misinterpret the buffer as utf8 characters.
function flitelib_synth(text) {
  if (!_flite) {
    return "";
  }
  var n = _flite.ccall("flitelib_synth", "number", ["string"], [text]);
  if (!n) {
    return ""; // Synth failed, just return empty
  }
  var ptr = _flite._tts_samples_ptr();
  var bytes = _flite.HEAPU8.subarray(ptr, ptr + n * 2);

  var s = "";
  const chunkSize = 8192; // Copy to string in chunks to avoid browser limit issues.
  for (var i = 0; i < bytes.length; i += chunkSize) {
    s += String.fromCharCode.apply(null, bytes.subarray(i, i + chunkSize));
  }
    
  return btoa(s);
}

function flitelib_get_rate() {
  if (!_flite) {
    return 0;
  }
    return _flite._flitelib_get_rate(); 
}

function flitelib_select_voice(path) {
  if (!_flite) {
    return 0;
  }
  var full = "/" + path;
  return _flite.ccall("flitelib_select_voice", "number", ["string"], [full]);
}

// This method is called by gamemaker to save any flitevox voice files into the flitelib sandbox; otherwise we cannot access those files.
function flitelib_register_voice(path, b64content) {
  if (!_flite) {
    return 0;
  }
  
  try {
    var content = atob(b64content);
    var bytes = new Uint8Array(content.length);
    for (var i = 0; i < content.length; i++){
      bytes[i] = content.charCodeAt(i);
    }
    var full = "/" + path;
    var dir = full.substring(0, full.lastIndexOf("/"));
    // Make parent directories if needed
    if (dir) { 
      _flite.FS.mkdirTree(dir);
    }
    _flite.FS.writeFile(full, bytes);
    return 1.0;
  } catch (e) {
    console.error("flitelib_register_voice failed:", e);
    return 0.0;
  }
}

function flitelib_default_voice() { 
  if (!_flite) {
    return 0;
  }
  return _flite.ccall("flitelib_default_voice", "number", [], []);
}

