/**
 * UiStore - Zustand-inspired state management for GameMaker
 * Minimal, fast, selector-based subscriptions
 * 
 * Core API:
 * - setState(partialState | updater)
 * - getState()
 * - subscribe(selector, callback)
 * - use(middleware) - Add optional middleware
 */
function UiStore(initialState = {}) constructor {
    self.state = initialState;
    self.__initialState = variable_clone(initialState);
    self.__selectorListeners = []; // Selector-based subscribers: { id, selector, callback, lastValue }
    self.__nextSubscriberId = 0; // For robust unsubscribe
    self.__middleware = []; // Middleware chain
    
    /**
     * Set state
     * Three signatures:
     * - setState(partialState) - Merge partial state struct
     * - setState(partialState, true) - Replace entire state
     * - setState(updater) - Function that receives state and returns partial state
     * - setState(updater, true) - Function that receives state and replaces entire state
     * @param {Any} arg Either a partial state struct or an updater function
     * @param {Bool} replace If true, replace entire state instead of merging
     */
    self.setState = function(arg, replace = false) {
        // Track changed keys for middleware (no clone, just keys)
        var _changedKeys = [];
        
        // Calculate new state
        var _newState;
        if (is_callable(arg)) {
            // Updater function: call it
            var _result = arg(self.state);
            if (replace) {
                _newState = _result;
                _changedKeys = variable_struct_get_names(_newState);
            } else {
                // Merge result into current state
                _newState = variable_clone(self.state);
                var _keys = variable_struct_get_names(_result);
                for (var i = 0, il = array_length(_keys); i < il; i++) {
                    var _key = _keys[i];
                    _newState[$ _key] = _result[$ _key];
                    array_push(_changedKeys, _key);
                }
            }
        } else {
            // Partial state struct
            if (replace) {
                _newState = arg;
                _changedKeys = variable_struct_get_names(_newState);
            } else {
                // Merge into current state
                _newState = variable_clone(self.state);
                var _keys = variable_struct_get_names(arg);
                for (var i = 0, il = array_length(_keys); i < il; i++) {
                    var _key = _keys[i];
                    _newState[$ _key] = arg[$ _key];
                    array_push(_changedKeys, _key);
                }
            }
        }
        
        // Apply middleware - can transform or interrupt
        // Middleware receives (changedKeys, newState, store)
        var _finalState = _newState;
        for (var i = 0; i < array_length(self.__middleware); i++) {
            var _result = self.__middleware[i](_changedKeys, _finalState, self);
            if (_result == false) {
                // Middleware interrupted the update
                return;
            }
            if (_result != undefined) {
                // Middleware transformed the state
                _finalState = _result;
            }
        }
        
        // Apply final state
        self.state = _finalState;
        self.__notify();
    };
    
    /**
     * Return the full state struct (live reference).
     * Does not include computed values.
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
            var _newState = variable_clone(self.state);
            variable_struct_remove(_newState, key);
            var _changedKeys = [key];
            
            // Apply middleware - can transform or interrupt
            var _finalState = _newState;
            for (var i = 0; i < array_length(self.__middleware); i++) {
                var _result = self.__middleware[i](_changedKeys, _finalState, self);
                if (_result == false) {
                    // Middleware interrupted the update
                    return self;
                }
                if (_result != undefined) {
                    // Middleware transformed the state
                    _finalState = _result;
                }
            }
            
            self.state = _finalState;
            self.__notify();
        }
        return self;
    };
    
    /**
     * Reset state to the initial snapshot passed to the constructor and notify subscribers. Returns `self`.
     */
    self.reset = function() {
        var _newState = variable_clone(self.__initialState);
        var _changedKeys = variable_struct_get_names(_newState);
        
        // Apply middleware - can transform or interrupt
        var _finalState = _newState;
        for (var i = 0; i < array_length(self.__middleware); i++) {
            var _result = self.__middleware[i](_changedKeys, _finalState, self);
            if (_result == false) {
                // Middleware interrupted the update
                return self;
            }
            if (_result != undefined) {
                // Middleware transformed the state
                _finalState = _result;
            }
        }
        
        self.state = _finalState;
        self.__notify();
        return self;
    };
    
    /**
     * Get a value from state.
     * @param {String} key The key to retrieve
     * @param {Any} defaultValue The default value if key is not found
     */
    self.get = function(key, defaultValue = undefined) {
        return self.state[$ key] ?? defaultValue;
    };
    
    /**
     * Subscribe to state updates using a selector function.
     * Only notifies when the selected value changes.
     * @param {Function} selector Function(state) -> value
     * @param {Function} callback Callback receiving the new selected value
     * @returns {Function} Unsubscribe function
     */
    self.subscribe = function(selector, callback) {
        var _initialValue = selector(self.state);
        var _id = self.__nextSubscriberId++;
        var _subscriber = {
            id: _id,
            selector: selector,
            callback: callback,
            lastValue: _initialValue
        };
        array_push(self.__selectorListeners, _subscriber);
        
        return function() {
            var _index = array_find_index(self.__selectorListeners, function(s) {
                return s.id == _id;
            });
            if (_index != -1) array_delete(self.__selectorListeners, _index, 1);
        };
    };
    
    /**
     * Apply middleware to the store.
     * Middleware receives (changedKeys, newState, store) and can:
     * - Return undefined to use newState as-is
     * - Return a new state to transform it
     * - Return false to interrupt the update
     * @param {Function} middleware Function(changedKeys, newState, store) -> newState | false | undefined
     * @returns {Struct} self for chaining
     */
    self.use = function(middleware) {
        array_push(self.__middleware, middleware);
        return self;
    };
    
    /**
     * Internal: notify all listeners.
     */
    self.__notify = function() {
        // Notify selector-based subscribers
        for (var i = 0; i < array_length(self.__selectorListeners); i++) {
            var _sub = self.__selectorListeners[i];
            var _newValue = _sub.selector(self.state);
            if (_newValue != _sub.lastValue) {
                _sub.callback(_newValue);
                _sub.lastValue = _newValue;
            }
        }
    };
    
    /**
     * Destroy the store and cleanup all listeners.
     */
    self.destroy = function() {
        self.__selectorListeners = [];
        self.__middleware = [];
    };
}
