/// @desc Audio handler returned by flitetts_speak
function FliteTtsAudio(_buffer=undefined, _rate=0) constructor {
    sound = noone
    if !is_undefined(_buffer) && _rate > 0 {
        sound = audio_create_buffer_sound(_buffer, buffer_s16, _rate, 0, buffer_get_size(_buffer), audio_mono);
    }
    playing = undefined
    handle = undefined
    
    /// @desc Call this method if the audio isn't invoked via `Play`.
    function Cleanup() {
        if is_undefined(handle) {
            _Cleanup()
        }
    }
    
    function _Cleanup() {
        if (sound == noone) {
            return
        }
        audio_stop_sound(sound) // Kill all currently active sounds.
        audio_free_buffer_sound(sound)
        sound = noone
    }
    
    /// @desc Get the sound asset. Use this if you wish to play sounds using your own emitters.
    /// @returns {Asset.GMSound}
    function Sound() {
        return sound
    }
    
    /// @desc Play the sythesized audio this may only be called once. Will cleanup automatically after the audio has played.
    /// @arg {real} gain (optional) default = 1, set the volume gain of the audio
    /// @arg {real} pitch (optional) default = 1, adjust the pitch of the playback
    function Play(gain=1, pitch=1) {
        if (sound == noone && is_undefined(playing) && is_undefined(handle)) {
            return
        }
        playing = audio_play_sound(sound, 0, false, gain, 0, pitch)
        
        handle = call_later(1, time_source_units_frames, method(self, function() {
            if (!audio_is_playing(playing)) {
                call_cancel(handle);
                _Cleanup()
            }
        }), true);
    }
}