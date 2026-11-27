
function _flitetts_js_register_voice(path) {
    var _b = buffer_load(path);
    var _s = buffer_base64_encode(_b, 0, buffer_get_size(_b));
    buffer_delete(_b);
    if flitetts_js_register_voice(path, _s) == 0.0 {
        return false;
    }
    return true;
}


function _flitetts_js_speak(_text, _voice) {
    if !flitetts_js_ready() {
        return new FliteTtsAudio();
    }
    if _voice == "" {
        flitetts_js_default_voice()
    } else {
        if flitetts_register_voice(_voice) == false {
            show_debug_message("register voice failed")
        }

        if flitetts_js_select_voice(_voice) == 0.0 {
            show_debug_message("select voice failed")
        }
    }
    
    var _b64 = flitetts_js_synth(_text);
    if (_b64 == "") return undefined;
    var _tmp  = buffer_base64_decode(_b64);
    var _size = buffer_get_size(_tmp);
    var _buf = buffer_create(_size, buffer_fixed, 1);
    buffer_copy(_tmp, 0, _size, _buf, 0);
    buffer_delete(_tmp);
    
    return new FliteTtsAudio(_buf, flitetts_js_get_rate())
}


function _flitetts_win_speak(_text, _voice) {
    if _voice == "" {
        flitetts_win_default_voice()
    } else {
        flitetts_win_select_voice(working_directory +_voice)
    }
    var _n    = flitetts_win_synth(_text);
    var _rate = flitetts_win_get_rate();
    var _buf  = buffer_create(_n * 2, buffer_fixed, 1);
    var _size = flitetts_win_copy(buffer_get_address(_buf));
    buffer_set_used_size(_buf, _size);
    
    return new FliteTtsAudio(_buf, _rate);
}

function _flitetts_ubu_speak(_text, _voice) {
    if _voice == "" {
        flitetts_ubu_default_voice()
    } else {
        flitetts_ubu_select_voice(working_directory +_voice)
    }
    var _n    = flitetts_ubu_synth(_text);
    var _rate = flitetts_ubu_get_rate();
    var _buf  = buffer_create(_n * 2, buffer_fixed, 1);
    var _size = flitetts_ubu_copy(buffer_get_address(_buf));
    buffer_set_used_size(_buf, _size);
    
    return new FliteTtsAudio(_buf, _rate);
}

function _flitetts_mac_speak(_text, _voice) {
    if _voice == "" {
        flitetts_mac_default_voice()
    } else {
        flitetts_mac_select_voice(working_directory +_voice)
    }
    var _n    = flitetts_mac_synth(_text);
    var _rate = flitetts_mac_get_rate();
    var _buf  = buffer_create(_n * 2, buffer_fixed, 1);
    var _size = flitetts_mac_copy(buffer_get_address(_buf));
    buffer_set_used_size(_buf, _size);
    
    return new FliteTtsAudio(_buf, _rate);
}




