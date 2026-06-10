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
    // One-time shallow clone so reset() always has the original values
    var _keys = variable_struct_get_names(initialState);
    self.__initialState = {};
    for (var i = 0; i < array_length(_keys); i++) {
        self.__initialState[$ _keys[i]] = initialState[$ _keys[i]];
    }
    self.__selectorListeners = [];
    self.__nextSubscriberId = 0;
    self.__middleware = [];
    
    self.setState = function(arg, replace = false) {
        var _changedKeys = [];
        
        if (is_callable(arg)) {
            var _result = arg(self.state);
            if (replace) {
                self.state = _result;
                _changedKeys = variable_struct_get_names(_result);
            } else {
                var _keys = variable_struct_get_names(_result);
                for (var i = 0; i < array_length(_keys); i++) {
                    var _key = _keys[i];
                    self.state[$ _key] = _result[$ _key];
                    array_push(_changedKeys, _key);
                }
            }
        } else {
            if (replace) {
                self.state = arg;
                _changedKeys = variable_struct_get_names(arg);
            } else {
                var _keys = variable_struct_get_names(arg);
                for (var i = 0; i < array_length(_keys); i++) {
                    var _key = _keys[i];
                    self.state[$ _key] = arg[$ _key];
                    array_push(_changedKeys, _key);
                }
            }
        }
        
        for (var i = 0; i < array_length(self.__middleware); i++) {
            var _mResult = self.__middleware[i](_changedKeys, self.state, self);
            if (is_struct(_mResult)) {
                self.state = _mResult;
            }
        }
        
        self.__notify(_changedKeys);
        return self;
    };
    
    self.getState = function() {
        return self.state;
    };
    
    self.has = function(key) {
        return variable_struct_exists(self.state, key);
    };
    
    self.remove = function(key) {
        if (variable_struct_exists(self.state, key)) {
            variable_struct_remove(self.state, key);
            self.__notify([key]);
        }
        return self;
    };
    
    self.reset = function() {
        var _keys = variable_struct_get_names(self.__initialState);
        self.state = {};
        for (var i = 0; i < array_length(_keys); i++) {
            self.state[$ _keys[i]] = self.__initialState[$ _keys[i]];
        }
        self.__notify(_keys);
        return self;
    };
    
    self.get = function(key, defaultValue = undefined) {
        return self.state[$ key] ?? defaultValue;
    };
    
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
    
    self.use = function(middleware) {
        array_push(self.__middleware, middleware);
        return self;
    };
    
    self.__notify = function(changedKeys = []) {
        for (var i = array_length(self.__selectorListeners) - 1; i >= 0; i--) {
            var _sub = self.__selectorListeners[i];
            var _newValue = _sub.selector(self.state);
            var _hasChanged = false;
            
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
    
    self.destroy = function() {
        self.__selectorListeners = [];
        self.__middleware = [];
    };
}
