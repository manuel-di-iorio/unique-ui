/// @desc Update UniqueUI
var W = window_get_width();
var H = window_get_height();
if (global.UI.width != W || global.UI.height != H) {
    global.UI.setSize(W, H);
    display_set_gui_size(W, H);
}
global.UI.update();
