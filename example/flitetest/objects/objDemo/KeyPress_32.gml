if s != noone {
    return
}
w = tts_speak("hello everyone please be my friend", voices[voiceIndex])
s = audio_play_sound(w.sound, 0, false)


