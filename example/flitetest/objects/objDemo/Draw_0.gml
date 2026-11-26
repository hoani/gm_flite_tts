SetFont(fMono, fa_left, fa_top, c_gray)
draw_text(room_width - 256, 16, "Voice Select")

draw_text(32, 16, "Current Voice")

SetFont(fRubik, fa_left, fa_top, c_ltgray)
draw_text(64, 48, VoiceName(voiceIndex))

var ypos = room_height*0.25

SetFont(fMono, fa_left, fa_bottom, c_gray)
draw_text(32, room_height*0.25, "Input")




SetFont(fRubik, fa_left, fa_top)
var text = input.Get() + ((mono % 60) < 30 ? " " : "|")

draw_text_ext(64, room_height*0.25, text, 64, room_width*0.75)

for (var i = 0; i < array_length(buttons); i++) {
    var _c = (i == voiceIndex) ? c_white : c_ltgray
    buttons[i].Draw(_c)
}