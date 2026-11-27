#export flitetts_speak,flitetts_register_voice


/// @desc synthesize text to speech. Basic usage: `flitetts_speak("hello").Play()`.
/// @desc Will throw if platform is unsupported
/// @arg _text the text to synthesize to speech
/// @arg _voice (optional) a path to a voice `.flitevox` file. `""` will use default.
/// @returns {Struct.FliteTtsAudio}
function flitetts_speak(text, voice="") {
    if os_browser != browser_not_a_browser {
        return _flitetts_js_speak(text, voice)
    }
    
    switch os_type {
		case os_gxgames:
			return _flitetts_js_speak(text, voice)
		case os_windows:
			return _flitetts_win_speak(text, voice)
        case os_linux:
			return _flitetts_ubu_speak(text, voice)
		case os_macosx:
			return _flitetts_mac_speak(text, voice)
		default:
            
			show_error("unsupported operating system", true)
			return new FliteTtsAudio()
    }
}

/// @desc preregister a voice file to flitetts. The paths should point to files in GameMaker's Included Files
/// @arg path path to the voice file.
/// @returns {boolean}
function flitetts_register_voice(path) {
    if !variable_global_exists("flitettsVoiceRegistry") {
        global.flitettsVoiceRegistry = []
    }
    if array_contains(global.flitettsVoiceRegistry, path) {
        return true;
    }
    
    // Registering is only necessary for browsers who do not have filesystem access.
    // All other platforms will just load based on filename.
    if os_type == os_gxgames || os_browser != browser_not_a_browser {
        if !_flitetts_js_register_voice(path) {
            return false;
        }
    }
    
    array_push(global.flitettsVoiceRegistry, path)
    return true
}





