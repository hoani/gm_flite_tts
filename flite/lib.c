#include "flite.h"
#include <string.h>

#define LIB_EXPORT __declspec(dllexport)

// Exported methods we use that are not in flite.h
cst_voice *register_cmu_us_kal(const char *voxdir);
void usenglish_init(cst_voice *v);
cst_lexicon *cmu_lex_init(void);

// voice holds the active voice for use at any give time.
static cst_voice* voice;

// the fallback/default voice
static cst_voice* defaultVoice;

// the current loaded waveform
cst_wave * wave;

LIB_EXPORT double flitelib_init(void) {
    flite_init();
    flite_add_lang("eng", usenglish_init, cmu_lex_init);
    flite_add_lang("usenglish", usenglish_init, cmu_lex_init);
    defaultVoice = register_cmu_us_kal(NULL);
    voice = defaultVoice;
    return 1.0;
}

LIB_EXPORT double flitelib_default_voice() {
    voice = defaultVoice;
    return 1.0;
}

LIB_EXPORT double flitelib_select_voice(const char *path) {
    cst_voice* v = flite_voice_select(path);
    voice = (v == NULL) ? voice : v;
    return (v == NULL) ? 0.0 : 1.0;
}

LIB_EXPORT double flitelib_synth(const char* text) {
    if (wave) { 
        delete_wave(wave); 
        wave = NULL; 
    }
    wave = flite_text_to_wave(text, voice);
    return wave ? (double)wave->num_samples : 0.0;
}

LIB_EXPORT double flitelib_get_rate(void) {
    if (wave == NULL) {
        return 0.0;
    }
    return (double)wave->sample_rate;
}

LIB_EXPORT double flitelib_copy(char* buffer) {
    if (wave == NULL) {
        return 0.0;
    }
    memcpy(buffer, wave->samples, wave->num_samples*2);
    int res = wave->num_samples * 2;

    return (double) res;
}