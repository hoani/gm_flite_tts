#include "flite.h"
#include <string.h>

#if defined(__EMSCRIPTEN__)
  #include <emscripten.h>
  #define LIB_EXPORT EMSCRIPTEN_KEEPALIVE
#elif defined(_WIN32)
#define LIB_EXPORT __declspec(dllexport)
#elif defined(__GNUC__) || defined(__clang__)
  #define LIB_EXPORT __attribute__((visibility("default")))
#else
#error("Unsupported architecture")
#endif

// Exported methods we use that are not in flite.h
cst_voice *register_cmu_us_kal(const char *voxdir);
void usenglish_init(cst_voice *v);
cst_lexicon *cmu_lex_init(void);

// voice holds the active voice for use at any give time.
static cst_voice* voice;

// the fallback/default voice. The default requires no additional files
static cst_voice* defaultVoice;

// the current loaded waveform
cst_wave * wave;

// Instantiate flitelib - must be called first.
// Currently, only registers english. 
LIB_EXPORT double flitelib_init(void) {
    flite_init();
    flite_add_lang("eng", usenglish_init, cmu_lex_init);
    flite_add_lang("usenglish", usenglish_init, cmu_lex_init);
    // Using kal keeps the flitelib around 3Mb.
    defaultVoice = register_cmu_us_kal(NULL);
    voice = defaultVoice;
    return 1.0;
}

// Set the voice back to the default
LIB_EXPORT double flitelib_default_voice() {
    voice = defaultVoice;
    return 1.0;
}

// Selects a voice based on a path. If we fail to load the voice, we keep the currently active voice instead.
LIB_EXPORT double flitelib_select_voice(const char *path) {
    cst_voice* v = flite_voice_select(path);
    voice = (v == NULL) ? voice : v;
    return (v == NULL) ? 0.0 : 1.0;
}

// Synthesize audio from text. Frees previously synthesized audio first.
LIB_EXPORT double flitelib_synth(const char* text) {
    if (wave) { 
        delete_wave(wave); 
        wave = NULL; 
    }
    wave = flite_text_to_wave(text, voice);
    return wave ? (double)wave->num_samples : 0.0;
}

// Get the sample rate of the current audio. This depends on which voice is used.
LIB_EXPORT double flitelib_get_rate(void) {
    if (wave == NULL) {
        return 0.0;
    }
    return (double)wave->sample_rate;
}

// Copy lib data to a buffer. We expect that the buffer is sized appropriately based on the samples returned by synth.
LIB_EXPORT double flitelib_copy(char* buffer) {
    if (wave == NULL) {
        return 0.0;
    }
    const int _n = wave->num_samples*2; // each sample is int16, so must copy twice that many bytes.
    memcpy(buffer, wave->samples, _n);

    return (double) _n;
}

// Get the samples pointer to copy from. Returns null if no audio has been synthesized.
LIB_EXPORT short *tts_samples_ptr(void) { 
    return wave ? wave->samples : NULL; 
}
