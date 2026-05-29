/// @desc Update UniqueUI
var winWNew = window_get_width();
var winHNew = window_get_height();

// Detect runtime window resize and keep UI + GUI space in sync.
if ((winW != winWNew || winH != winHNew) && winWNew != 0 && winHNew != 0) {
    winW = winWNew;
    winH = winHNew;

    global.UI.setSize(winW, winH);
    display_set_gui_size(winW, winH);
}
global.UI.update();
