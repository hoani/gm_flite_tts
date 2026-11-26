
function Button(x, y, _text, _onPressed, _font=fMono) {
    return new ButtonClass(x, y, _text, _onPressed, _font)
}

function ButtonClass(_x, _y, _text, _onPressed, _font) constructor {
    
    text = _text
    onPressed = _onPressed
    font = _font
    draw_set_font(_font)
    w = string_width(text)
    h = string_height(text)
    c = new Pos( _x + w/2, _y + h/2)
    b = new PositionedBox(c.x, c.y, w, h)
    cooldown = new Cooldown(15)
    hovered = false
    
    static StateIdle = 0
    static StateActive = 1
    
    state = new State(StateIdle)
    
    enableCondition = function() {
        return true
    }
    
    
    static HLeft = function() {
        b = new PositionedBox(c.x, b.y, w, h)
        return self
    }
    
    static HRight = function() {
        b = new PositionedBox(c.x - w, b.y, w, h)
        return self
    }
    
    static HCenter = function() {
        b = new PositionedBox(c.x - w/2, b.y, w, h)
        return self
    }
    
    static VTop = function() {
        b = new PositionedBox(b.x, c.y, w, h)
        return self
    }
    
    static VBottom = function() {
        b = new PositionedBox(b.x, c.y-h, w, h)
        return self
    }
    
    static VCenter = function() {
        b = new PositionedBox(b.x, c.y - h/2, w, h)
        return self
    }
    
    
    static Update = function() {

        if cooldown.Active() {
            cooldown.Update()
            if !cooldown.Active() {
                
                hovered = b.Inside(mouse_x, mouse_y)
            }
            return
        }
        
        var h = b.Inside(mouse_x, mouse_y)
        if hovered != h {
            hovered = h
        }
        if !hovered {
            return
        }
        
        if mouse_check_button_released(mb_left) {
            Trigger()
        }
    }
    
    static Trigger = function() {
        cooldown.Trigger()
        onPressed()
    }
    
    
    static Draw = function(_c=c_ltgray) {
        var alpha = hovered ? 1 : 0.75;
        
        SetFont(font, fa_center, fa_center, _c)
        
        if cooldown.Active() {
            var amt = 1 - clamp(w*h/(256*128), 0.0, 0.75)
            var sx = 1 + (1 - cooldown.Fraction())*amt
            var sy = 1 + (1 - cooldown.Fraction())*amt*2
            draw_set_alpha(cooldown.Fraction())
            draw_text_transformed(b.x, b.y, text, sx, sy, 0)
        }
        draw_set_alpha(alpha)
        draw_text(b.x, b.y, text)
        draw_set_alpha(1)
    }
}