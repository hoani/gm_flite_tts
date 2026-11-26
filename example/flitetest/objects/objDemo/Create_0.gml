
voices = [
    "",
    "cmu_us_aew.flitevox",
    "cmu_us_ahw.flitevox",
    "cmu_us_aup.flitevox",
    "cmu_us_awb.flitevox",
    "cmu_us_axb.flitevox",
    "cmu_us_bdl.flitevox",
    "cmu_us_clb.flitevox",
    "cmu_us_eey.flitevox",
    "cmu_us_fem.flitevox",
    "cmu_us_gka.flitevox",
    "cmu_us_jmk.flitevox",
    "cmu_us_ksp.flitevox",
    "cmu_us_ljm.flitevox",
    "cmu_us_lnh.flitevox",
    "cmu_us_rms.flitevox",
    "cmu_us_rxr.flitevox",
    "cmu_us_slp.flitevox",
    "cmu_us_slt.flitevox",
]
voiceIndex = 0

phrases = [
    "She sells sea shells at the sea shore",
    "Peter piper picked a peck of pickled peppers",
    "The quick brown fox jumps over the lazy dog",
    "You fell victim to one of the classic blunders - the most famous of which is 'never get involved in a land war in Asia' - but only slightly less well-known is this: 'Never go in against a Sicilian when death is on the line'!",
    "Ride now!... Ride now!... Ride! Ride to ruin and the world's ending! Death!",
    "I found this badass store called Dan Flashes, that's my exact style.",
    "55 burgers, 55 fries, 55 tacos, 55 pies, 55 Cokes, 100 tater tots, 100 pizzas, 100 tenders, 100 meatballs, 100 coffees, 55 wings, 55 shakes, 55 pancakes, 55 pastas, 55 peppers, and 155 taters."
]

phraseIndex = 0


input = new Input(240);
input.Set("Hello World")

mono = 0
pitch = 1

 DoSpeak = function() {
    audio_stop_all()
    var w = flitetts_speak(input.Get(), voices[voiceIndex])
    w.Play(1, pitch)
}

function VoiceName(_index) {
    var name = voices[_index]
    if name == "" {
        return "default"
    } else {
        return string_trim_end(name, [".flitevox"])
    }
}

function VoiceButton(_index) {
    var name = VoiceName(_index)
    var demo = self
    var ctx = {
        index: _index,
        demo: demo,
        execute: function(){
            demo.voiceIndex = index
            demo.playButton.Trigger()
        }
    }
    return Button(room_width-32, 64 + _index*32, name, ctx.execute).HRight()
}

playButton = Button(room_width*0.25, room_height-128, "< Play >", DoSpeak, fButton).HCenter()

buttons = []

for (var i = 0; i<array_length(voices); i++) {
    array_push(buttons, VoiceButton(i))
}

RandomText = function() {
    var phrase = phrases[phraseIndex];
    phraseIndex = (phraseIndex + 1) % array_length(phrases)
    input.Set(phrase)
    DoSpeak()
}

array_push(buttons, playButton)
array_push(buttons, Button(room_width*0.75, room_height-128, "< Random >", RandomText, fButton).HRight())