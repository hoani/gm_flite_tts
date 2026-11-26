function Pos(_x, _y) constructor {
	x = _x
    y = _y
}

/// Box geometry
function Box(_width, _height) constructor {
	w = _width
    h = _height
    
    static Pad = function(hpad, vpad) {
        return new Box(max(0, w - 2 * hpad), max(0, h - 2 *vpad))
    }
    
    static Contains = function(o) {
        return Inside(o.w, o.h)
    }
    
    static Inside = function(x, y) {
        return x >= 0 && x <= w && y >= 0 && y <= h;
    }
}


function PositionedBox(_x, _y, _w, _h) : Box(_w, _h) constructor {
    x = _x;
    y = _y;
    x0 = _x - w/2;
    x1 = _x + w/2;
    y0 = _y - h/2;
    y1 = _y + h/2;
    
    static SetX = function(_x) {
        x = _x;
        _Refresh();
    }
    
    static SetY = function(_y) {
        y = _y;
        _Refresh();
    }
    
    static _Refresh = function() {
        x0 = x - w/2;
        x1 = x + w/2;
        y0 = y - h/2;
        y1 = y + h/2;
    }
    
    static Inside = function(x, y) {
        return x >= x0 && x <= x1 && y >= y0 && y <= y1;
    }
}