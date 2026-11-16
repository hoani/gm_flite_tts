function tts_register(path) {
    if !variable_global_exists("ttsVoiceRegistry") {
        global.ttsVoiceRegistry = []
    }
    if array_contains(global.ttsVoiceRegistry, path) {
        return true;
    }
    
    if os_type == os_gxgames {
        var _b = buffer_load(path);
        var _s = buffer_base64_encode(_b, 0, buffer_get_size(_b));
        buffer_delete(_b);
        if tts_js_register_voice(path, _s) == 0.0 {
            return false;
        }
        show_debug_message($"registered {path}")
    }
    array_push(global.ttsVoiceRegistry, path)
    return true
}



function tts_speak(_text, _voice="") {
    
    if os_type == os_gxgames {
        if !jtts_ready() {
            return;
        }
        if _voice == "" {
            tts_js_default_voice()
        } else {
            if tts_register(_voice) == false {
                show_debug_message("register voice failed")
            }

            if jtts_select_voice(_voice) == 0.0 {
                show_debug_message("select voice failed")
            }
        }
        
        var _b64 = jtts_synth(_text);
        if (_b64 == "") return undefined;
        var _tmp  = buffer_base64_decode(_b64);
        var _size = buffer_get_size(_tmp);
        var _buf = buffer_create(_size, buffer_fixed, 1);
        buffer_copy(_tmp, 0, _size, _buf, 0);
        buffer_delete(_tmp);
        
        
        var _snd = audio_create_buffer_sound(_buf, buffer_s16, jtts_get_rate(), 0, buffer_get_size(_buf), audio_mono);
        return { sound: _snd, buffer: _buf }; // caller frees the sound, then deletes the buffer
    } else {
        if _voice == "" {
            tts_default_voice()
        } else {
            tts_select_voice(working_directory +_voice)
        }
        var _n    = tts_synth(_text);
        var _rate = tts_get_rate();
        var _buf  = buffer_create(_n * 4, buffer_fixed, 1);
        var _size = tts_copy(buffer_get_address(_buf));
        buffer_set_used_size(_buf, _size);
        var _snd  = audio_create_buffer_sound(_buf, buffer_s16, _rate, 0, _n*2, audio_mono);
        return { sound: _snd, buffer: _buf }; // caller frees the sound, then deletes the buffer
    }
    
}