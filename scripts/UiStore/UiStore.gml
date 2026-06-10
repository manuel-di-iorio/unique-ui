/**
 * UiStore - Simple push-based state management for GameMaker
 * No selectors, no equality checks — just set and notify.
 * 
 * Core API:
 * - setState(partialState, replace?) - Update state (merge or replace)
 * - getState() - Get full state
 * - get(key, defaultValue) - Get single value
 * - has(key) - Check if key exists
 * - remove(key) - Delete key from state
 * - reset() - Reset to initial state
 * - subscribe(callback) - Subscribe to state changes
 * - use(middleware) - Add optional middleware
 */
function UiStore(initialState = {}) constructor {
    self.state = initialState;
    var _keys = variable_struct_get_names(initialState);
    self.__initialState = {};
    for (var i = 0; i < array_length(_keys); i++) {
        self.__initialState[$ _keys[i]] = initialState[$ _keys[i]];
    }
    self.__listeners = [];
    self.__nextSubscriberId = 0;
    self.__middleware = [];
    
    self.setState = function(arg, replace = false) {
        if (replace) {
            self.state = arg;
        } else {
            var _keys = variable_struct_get_names(arg);
            for (var i = 0; i < array_length(_keys); i++) {
                self.state[$ _keys[i]] = arg[$ _keys[i]];
            }
        }
        
        for (var i = 0; i < array_length(self.__middleware); i++) {
            var _mResult = self.__middleware[i](self.state, self);
            if (is_struct(_mResult)) {
                self.state = _mResult;
            }
        }
        
        self.__notify();
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
            self.__notify();
        }
        return self;
    };
    
    self.reset = function() {
        var _keys = variable_struct_get_names(self.__initialState);
        self.state = {};
        for (var i = 0; i < array_length(_keys); i++) {
            self.state[$ _keys[i]] = self.__initialState[$ _keys[i]];
        }
        self.__notify();
        return self;
    };
    
    self.get = function(key, defaultValue = undefined) {
        return self.state[$ key] ?? defaultValue;
    };
    
    self._unsubscribeByRef = function(sub) {
        for (var i = array_length(self.__listeners) - 1; i >= 0; i--) {
            if (self.__listeners[i] == sub) {
                array_delete(self.__listeners, i, 1);
                break;
            }
        }
    };
    
    self.subscribe = function(callback) {
        var _subscriber = {
            id: self.__nextSubscriberId,
            callback: callback
        };
        self.__nextSubscriberId++;
        array_push(self.__listeners, _subscriber);
        
        var _storeRef = self;
        return method({sub: _subscriber, store: _storeRef}, function() {
            self.store._unsubscribeByRef(self.sub);
        });
    };
    
    self.use = function(middleware) {
        array_push(self.__middleware, middleware);
        return self;
    };
    
    self.__notify = function() {
        for (var i = array_length(self.__listeners) - 1; i >= 0; i--) {
            self.__listeners[i].callback(self.state);
        }
    };
    
    self.destroy = function() {
        self.__listeners = [];
        self.__middleware = [];
    };
}
