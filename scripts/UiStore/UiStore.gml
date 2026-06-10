/**
 * UiStore - Simple push-based state management for GameMaker.
 * 
 * Core API:
 * - set(partialState, replace?) - Update state (merge or replace)
 * - get(key, defaultValue) - Get single value
 * - has(key) - Check if key exists
 * - remove(key) - Delete key from state
 * - reset() - Reset to initial state
 * - subscribe(callback) - Subscribe to state changes
 * - use(middleware) - Add custom middleware
 * - .state - The live state struct reference (read-only)
 */
function UiStore(initialState = {}) constructor {
    // Store the initial state snapshot and create a mutable state reference
    self.state = initialState;
    var _keys = variable_struct_get_names(initialState);
    self.__initialState = {};
    for (var i = 0, _keysLen = array_length(_keys); i < _keysLen; i++) {
        self.__initialState[$ _keys[i]] = initialState[$ _keys[i]];
    }

    self.__listeners = [];
    self.__nextSubscriberId = 0;
    self.__middleware = [];
    
    /**
     * Update the state and notify subscribers.
     * @param {struct} arg - Partial state to merge or full state to replace
     * @param {boolean} replace - If true, replace the entire state instead of merging
     * @returns 
     */
    self.set = function(arg, replace = false) {
        if (replace) {
            self.state = arg;
        } else {
            var _keys = variable_struct_get_names(arg);
            for (var i = 0; i < array_length(_keys); i++) {
                self.state[$ _keys[i]] = arg[$ _keys[i]];
            }
        }
        
        for (var i = 0, _middlewareLen = array_length(self.__middleware); i < _middlewareLen; i++) {
            var _mResult = self.__middleware[i](self.state, self);
            if (is_struct(_mResult)) {
                self.state = _mResult;
            }
        }
        
        self.__notify();
        return self;
    };
    
    /**
     * Check if a key exists in the state.
     * @param {string} key - The key to check
     * @returns {boolean} Whether the key exists
     */
    self.has = function(key) {
        return variable_struct_exists(self.state, key);
    };
        
    /**
     * Delete a key from the state.
     * @param {string} key - The key to delete
     * @returns {UiStore} The UiStore instance.
     */
    self.remove = function(key) {
        if (variable_struct_exists(self.state, key)) {
            variable_struct_remove(self.state, key);
            self.__notify();
        }
        return self;
    };
    
    /**
     * Reset the state to its initial value.
     * @returns {UiStore} The UiStore instance.
     */
    self.reset = function() {
        var _keys = variable_struct_get_names(self.__initialState);
        self.state = {};
        for (var i = 0, _keysLen = array_length(_keys); i < _keysLen; i++) {
            self.state[$ _keys[i]] = self.__initialState[$ _keys[i]];
        }
        self.__notify();
        return self;
    };
    
    /**
     * Get a value from the state.
     * @param {string} key - The key to get
     * @param {*} defaultValue - The default value to return if the key is not found
     * @returns {*} The value associated with the key, or the default value if not found
     */
    self.get = function(key, defaultValue = undefined) {
        return self.state[$ key] ?? defaultValue;
    };
        
    /**
     * Unsubscribe a callback from state changes.
     * @param {function} callback - The subscriber callback function
     * @returns {void}
     */
    self._unsubscribeByRef = function(sub) {
        for (var i = array_length(self.__listeners) - 1; i >= 0; i--) {
            if (self.__listeners[i] == sub) {
                array_delete(self.__listeners, i, 1);
                break;
            }
        }
    };
    
    /**
     * Subscribe to state changes.
     * @param {function} callback - The callback function to invoke when state changes
     * @returns {function} A method to unsubscribe the callback
     */
    self.subscribe = function(callback) {
        var _subscriber = {
            id: self.__nextSubscriberId,
            callback: callback
        };
        self.__nextSubscriberId++;
        array_push(self.__listeners, _subscriber);
        
        var _storeRef = self;
        return method({ sub: _subscriber, store: _storeRef }, function() {
            self.store._unsubscribeByRef(self.sub);
        });
    };
        
    /**
     * Add custom middleware to the store.
     * @param {function} middleware - The middleware function to add
     * @returns {UiStore} The UiStore instance.
     */
    self.use = function(middleware) {
        array_push(self.__middleware, middleware);
        return self;
    };
        
    /**
     * Notify all subscribers about a state change.
     * @returns {void}
     */
    self.__notify = function() {
        for (var i = array_length(self.__listeners) - 1; i >= 0; i--) {
            self.__listeners[i].callback(self.state);
        }
    };
        
    /**
     * Destroy the store and clean up resources.
     * @returns {void}
     */
    self.destroy = function() {
        self.__listeners = [];
        self.__middleware = [];
    };
}
