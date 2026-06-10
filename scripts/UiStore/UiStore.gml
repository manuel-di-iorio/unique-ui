/**
 * UiStore - Zustand-inspired state management for GameMaker
 * Minimal, fast, selector-based subscriptions with direct mutation
 * 
 * Core API:
 * - setState(partialState | updater) - Merge or replace state
 * - getState() - Get full state
 * - get(key, defaultValue) - Get single value
 * - has(key) - Check if key exists
 * - remove(key) - Delete key from state
 * - reset() - Reset to initial state
 * - subscribe(selector, callback, equalityFn) - Subscribe with optional custom equality
 * - use(middleware) - Add optional middleware
 */
function UiStore(initialState = {}) constructor {
    self.state = initialState;
    // Clone initialState to protect it from direct mutation via self.state
    var _keys = variable_struct_get_names(initialState);
    self.__initialState = {};
    for (var i = 0; i < array_length(_keys); i++) {
        self.__initialState[$ _keys[i]] = initialState[$ _keys[i]];
    }
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
        var _changedKeys = [];
        
        // Compute pending state in temp struct (no mutation of self.state yet)
        var _pending;
        if (is_callable(arg)) {
            var _result = arg(self.state);
            if (replace) {
                _pending = _result;
                _changedKeys = variable_struct_get_names(_pending);
            } else {
                var _curKeys = variable_struct_get_names(self.state);
                _pending = {};
                for (var i = 0, il = array_length(_curKeys); i < il; i++) {
                    _pending[$ _curKeys[i]] = self.state[$ _curKeys[i]];
                }
                var _keys = variable_struct_get_names(_result);
                for (var i = 0, il = array_length(_keys); i < il; i++) {
                    var _key = _keys[i];
                    _pending[$ _key] = _result[$ _key];
                    array_push(_changedKeys, _key);
                }
            }
        } else {
            if (replace) {
                _pending = arg;
                _changedKeys = variable_struct_get_names(_pending);
            } else {
                var _curKeys = variable_struct_get_names(self.state);
                _pending = {};
                for (var i = 0, il = array_length(_curKeys); i < il; i++) {
                    _pending[$ _curKeys[i]] = self.state[$ _curKeys[i]];
                }
                var _keys = variable_struct_get_names(arg);
                for (var i = 0, il = array_length(_keys); i < il; i++) {
                    var _key = _keys[i];
                    _pending[$ _key] = arg[$ _key];
                    array_push(_changedKeys, _key);
                }
            }
        }
        
        // Apply middleware - can transform or interrupt
        // Middleware receives (changedKeys, pendingState, store)
        var _finalState = _pending;
        for (var i = 0; i < array_length(self.__middleware); i++) {
            var _result = self.__middleware[i](_changedKeys, _finalState, self);
            if (_result == false) {
                return self;
            }
            if (_result != undefined) {
                _finalState = _result;
            }
        }
        
        // Assign final state (always replace to ensure reference-based != comparison works)
        self.state = _finalState;
        
        self.__notify(_changedKeys);
        return self;
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
            var _changedKeys = [key];
            
            // Clone current state excluding the key
            var _keys = variable_struct_get_names(self.state);
            var _pending = {};
            for (var i = 0; i < array_length(_keys); i++) {
                if (_keys[i] != key) {
                    _pending[$ _keys[i]] = self.state[$ _keys[i]];
                }
            }
            
            // Apply middleware - can transform or interrupt
            var _finalState = _pending;
            for (var i = 0; i < array_length(self.__middleware); i++) {
                var _result = self.__middleware[i](_changedKeys, _finalState, self);
                if (_result == false) {
                    return self;
                }
                if (_result != undefined) {
                    _finalState = _result;
                }
            }
            
            self.state = _finalState;
            self.__notify(_changedKeys);
        }
        return self;
    };
    
    /**
     * Reset state to the initial snapshot passed to the constructor and notify subscribers. Returns `self`.
     */
    self.reset = function() {
        var _changedKeys = variable_struct_get_names(self.__initialState);
        
        // Clone initial state into a fresh struct
        var _freshState = {};
        for (var i = 0; i < array_length(_changedKeys); i++) {
            _freshState[$ _changedKeys[i]] = self.__initialState[$ _changedKeys[i]];
        }
        
        // Apply middleware - can transform or interrupt
        var _finalState = _freshState;
        for (var i = 0; i < array_length(self.__middleware); i++) {
            var _result = self.__middleware[i](_changedKeys, _finalState, self);
            if (_result == false) {
                return self;
            }
            if (_result != undefined) {
                _finalState = _result;
            }
        }
        
        self.state = _finalState;
        self.__notify(_changedKeys);
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
     * @param {Function} callback Callback receiving the new selected value (and optional changedKeys)
     * @param {Function} equalityFn Optional custom equality function(a, b) -> bool
     * @returns {Function} Unsubscribe function
     */
    self._unsubscribeByRef = function(sub) {
        for (var i = array_length(self.__selectorListeners) - 1; i >= 0; i--) {
            if (self.__selectorListeners[i] == sub) {
                array_delete(self.__selectorListeners, i, 1);
                break;
            }
        }
    };
    
    self.subscribe = function(selector, callback, equalityFn = undefined) {
        var _initialValue = selector(self.state);
        var _subscriber = {
            id: self.__nextSubscriberId,
            selector: selector,
            callback: callback,
            lastValue: _initialValue,
            equalityFn: equalityFn
        };
        self.__nextSubscriberId++;
        array_push(self.__selectorListeners, _subscriber);
        
        var _storeRef = self;
        return method({sub: _subscriber, store: _storeRef}, function() {
            self.store._unsubscribeByRef(self.sub);
        });
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
     * @param {Array} changedKeys Array of keys that changed in this update
     */
    self.__notify = function(changedKeys = []) {
        // Notify selector-based subscribers - reverse iteration to safely handle unsubscribe during callback
        for (var i = array_length(self.__selectorListeners) - 1; i >= 0; i--) {
            var _sub = self.__selectorListeners[i];
            var _newValue = _sub.selector(self.state);
            var _hasChanged = false;
            
            // Use custom equality function if provided
            if (_sub.equalityFn != undefined) {
                _hasChanged = !_sub.equalityFn(_newValue, _sub.lastValue);
            } else {
                _hasChanged = (_newValue != _sub.lastValue);
            }
            
            if (_hasChanged) {
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
