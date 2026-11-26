function FliteTtsAudio(_buffer, _rate) constructor {
    sound = audio_create_buffer_sound(_buffer, buffer_s16, _rate, 0, buffer_get_size(_buffer), audio_mono);
    playing = undefined
    handle = undefined
    
    function Cleanup() {
        if is_undefined(handle) {
            _Cleanup()
        }
    }
    
    function Cleanup() {
        if (sound == noone) {
            return
        }
        audio_free_buffer_sound(sound)
        sound = noone
    }
    
    function Sound() {
        return sound
    }
    
    function Play(gain=1, pitch=1) {
        if (sound == noone && is_undefined(playing) && is_undefined(handle)) {
            return
        }
        playing = audio_play_sound(sound, 0, false, gain, 0, pitch)
        
        handle = call_later(1, time_source_units_frames, method(self, function() {
            if (!audio_is_playing(playing)) {
                call_cancel(handle);
                Cleanup()
            }
        }), true);
    }
}