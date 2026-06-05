/**
 * UiStore - Lightweight reactive UI state management store
 * Allows component state sharing and reactive UI binding
 */
function UiStore(initialState = {}) constructor {
    self.state = initialState;
    self.__initialState = variable_clone(initialState);
    self.listeners = [];
    
    /**
     * Set a state key to a new value and notify subscribers.
     * @param {String} key The key to modify
     * @param {Any} value The new value
     */
    self.set = function(key, value) {
        self.state[$ key] = value;
        self.__notify();
    };
    
    /**
     * Batch-update multiple keys at once with a single notification.
     * @param {Struct} partialState A struct of key/value pairs to merge into state
     */
    self.setState = function(partialState) {
        var _keys = variable_struct_get_names(partialState);
        for (var i = 0, il = array_length(_keys); i < il; i++) {
            self.state[$ _keys[i]] = partialState[$ _keys[i]];
        }
        self.__notify();
    };
    
    /**
     * Get a state key's value.
     * @param {String} key The key to retrieve
     * @param {Any} defaultValue The default value if key is not found
     */
    self.get = function(key, defaultValue = undefined) {
        return self.state[$ key] ?? defaultValue;
    };
    
    /**
     * Return the full state struct (live reference).
     */
    self.getState = function() {
        return self.state;
    };
    
    /**
     * Check whether a key exists in the state.
     * @param {String} key The key to check
     */
    self.has = function(key) {
        return variable_struct_exists(self.state, key);
    };
    
    /**
     * Delete a key from state and notify subscribers.
     * @param {String} key The key to remove
     */
    self.remove = function(key) {
        if (variable_struct_exists(self.state, key)) {
            variable_struct_remove(self.state, key);
            self.__notify();
        }
        return self;
    };
    
    /**
     * Reset state to its initial values and notify subscribers.
     */
    self.reset = function() {
        self.state = variable_clone(self.__initialState);
        self.__notify();
        return self;
    };
    
    /**
     * Subscribe to state updates.
     * @param {Function} callback Callback receiving the new state struct
     * @returns {Struct} self - for chaining
     */
    self.subscribe = function(callback) {
        array_push(self.listeners, callback);
        return self;
    };
    
    /**
     * Remove a previously registered subscriber callback.
     * @param {Function} callback The exact callback reference to remove
     * @returns {Struct} self - for chaining
     */
    self.unsubscribe = function(callback) {
        for (var i = array_length(self.listeners) - 1; i >= 0; i--) {
            if (self.listeners[i] == callback) {
                array_delete(self.listeners, i, 1);
                break;
            }
        }
        return self;
    };
    
    /**
     * Internal: notify all listeners and request a redraw.
     */
    self.__notify = function() {
        for (var i = 0; i < array_length(self.listeners); i++) {
            self.listeners[i](self.state);
        }
        if (variable_global_exists("UI") && global.UI != undefined) {
            global.UI.requestRedraw();
        }
    };
}
