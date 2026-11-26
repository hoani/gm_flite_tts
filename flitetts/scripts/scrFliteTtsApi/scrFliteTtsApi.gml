#export flitetts_speak,flitetts_register_voice



function flitetts_speak(_text, _voice="") {
    if os_browser != browser_not_a_browser {
        return _flitetts_js_speak(_text, _voice)
    }
    
    switch os_type {
		case os_gxgames:
			return _flitetts_js_speak(_text, _voice)
		case os_windows:
			return _flitetts_win_speak(_text, _voice)
        case os_linux:
			return _flitetts_ubu_speak(_text, _voice)
		case os_macosx:
			return _flitetts_mac_speak(_text, _voice)
		default:
            
			show_error("unsupported operating system", true)
			return {}
    }
}

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





