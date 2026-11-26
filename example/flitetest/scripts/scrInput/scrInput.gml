function Cooldown(_amount) constructor {
    amount = floor(max(1, _amount));
    value = 0; 
    
    static Trigger = function(fract=1) {
        value = amount*fract;
    } 
    
    static Active = function() {
        return value > 0;
    }
    
    static Fraction = function() {
        return value/amount;
    }
    
    static Update = function() {
        if value > 0 {
            value--;
        }
    }
    
    static Cancel = function() {
        value = 0;
    }
}

function Within(v, vmin, vmax){
    return (v >= vmin && v <= vmax);
}

#macro SpecialCharacters "?.,;! '\""

function Input(_maxLength = 32) constructor {
    input = ""
    maxLength = _maxLength
    
    backspaceHold = new Cooldown(20)
    
    static _Backspace = function() {
        if string_length(input) == 0 {
            return
        }
        input = string_delete(input, string_length(input), 1);
    }
    
    static Update = function() {
        if keyboard_check_pressed(vk_backspace) {
            _Backspace()
            backspaceHold.Trigger()
        }
        
        if keyboard_check_released(vk_backspace) {
            backspaceHold.Cancel()
        }
        
        if backspaceHold.Active() {
            backspaceHold.Update()
            if !backspaceHold.Active() {
                backspaceHold.Trigger(0.25)
                _Backspace()
            }
        }
        
        if string_length(input) > maxLength {
            return
        }
        
        var c = keyboard_lastchar;
        if c != "" {
            keyboard_lastchar = "";
            var o = ord(c);
            if (Within(o, 48, 57) || Within(o, 65, 90) || Within(o, 97, 122) || string_pos(c, SpecialCharacters) != 0 )  && string_length(input) < maxLength {
                input += c;
            }
        }
    }
    
    static Set = function(value) {
        input = value
    }

    
    static Get = function() {
        return input
    }
}