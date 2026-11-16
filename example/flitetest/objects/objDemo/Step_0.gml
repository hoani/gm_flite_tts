if s != noone {
    if !audio_is_playing(s) {
        audio_free_buffer_sound(w.sound)
        s = noone
    }
}