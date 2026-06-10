/**
 * UiStore - Lightweight reactive UI state management store
 * Allows component state sharing and reactive UI binding
 * 
 * Performance features:
 * - Selector-based subscriptions
 * - Mutations (update)
 * - Snapshot/undo-redo support
 * - Actions system for state mutations
 */
function UiStore(initialState = {}) constructor {
    self.state = initialState;
    self.__initialState = variable_clone(initialState);
    self.__selectorListeners = []; // Selector-based subscribers: { id, selector, callback, lastValue }
    self.__nextSubscriberId = 0; // For robust unsubscribe
    self.__snapshotStack = []; // For undo/redo
    self.__redoStack = [];
    self.__autoSnapshot = false;
    self.actions = {}; // Actions object for state mutations
    self.__changeListeners = []; // General change listeners (lib-agnostic)
    
    /**
     * Set state
     * Two signatures:
     * - set(partialState) - Merge partial state struct
     * - set(updater) - Function that receives state and returns partial state
     * @param {Any} arg Either a partial state struct or an updater function
     */
    self.set = function(arg) {
        // Save state for undo/redo BEFORE modification
        if (self.__autoSnapshot) {
            self.__saveState();
        }
        
        // Check if arg is a function (updater) or struct (partial state)
        if (is_callable(arg)) {
            // Updater function: call it and merge result
            var _partialState = arg(self.state);
            var _keys = variable_struct_get_names(_partialState);
            for (var i = 0, il = array_length(_keys); i < il; i++) {
                var _key = _keys[i];
                self.state[$ _key] = _partialState[$ _key];
            }
        } else {
            // Partial state struct: merge directly
            var _keys = variable_struct_get_names(arg);
            for (var i = 0, il = array_length(_keys); i < il; i++) {
                var _key = _keys[i];
                self.state[$ _key] = arg[$ _key];
            }
        }
        
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
            // Save state for undo/redo BEFORE modification
            if (self.__autoSnapshot) {
                self.__saveState();
            }
            
            variable_struct_remove(self.state, key);
            self.__notify();
        }
        return self;
    };
    
    /**
     * Reset state to the initial snapshot passed to the constructor and notify subscribers. Returns `self`.
     */
    self.reset = function() {
        // Save state for undo/redo BEFORE modification
        if (self.__autoSnapshot) {
            self.__saveState();
        }
        
        self.state = variable_clone(self.__initialState);
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
     * Create a snapshot of the current state for undo/redo.
     * @returns {Struct} Snapshot of current state
     */
    self.snapshot = function() {
        return variable_clone(self.state);
    };
    
    /**
     * Save current state to undo stack.
     */
    self.__saveState = function() {
        array_push(self.__snapshotStack, variable_clone(self.state));
        self.__redoStack = []; // Clear redo stack on new action
        // Limit stack size
        if (array_length(self.__snapshotStack) > 50) {
            array_delete(self.__snapshotStack, 0, 1);
        }
    };
    
    /**
     * Undo the last state change.
     */
    self.undo = function() {
        if (array_length(self.__snapshotStack) == 0) return;
        
        // Save current state to redo stack
        array_push(self.__redoStack, variable_clone(self.state));
        
        // Restore previous state
        var _previousState = array_pop(self.__snapshotStack);
        self.state = _previousState;
        self.__notify();
    };
    
    /**
     * Redo the last undone state change.
     */
    self.redo = function() {
        if (array_length(self.__redoStack) == 0) return;
        
        // Save current state to undo stack
        array_push(self.__snapshotStack, variable_clone(self.state));
        
        // Restore redo state
        var _redoState = array_pop(self.__redoStack);
        self.state = _redoState;
        self.__notify();
    };
    
    /**
     * Enable auto-snapshot for undo/redo on every state change.
     */
    self.enableUndoRedo = function() {
        self.__autoSnapshot = true;
    };
    
    /**
     * Disable auto-snapshot.
     */
    self.disableUndoRedo = function() {
        self.__autoSnapshot = false;
    };
    
    /**
     * Define actions for state mutations.
     * Actions provide a clean API for state changes and enable middleware/logging.
     * Actions are bound to the store, no need to pass store parameter.
     * @param {Struct} actions Object of action functions
     */
    self.setActions = function(actions) {
        var _actionNames = variable_struct_get_names(actions);
        for (var i = 0; i < array_length(_actionNames); i++) {
            var _name = _actionNames[i];
            var _action = actions[$ _name];
            // Bind action to store
            self.actions[$ _name] = method(self, _action);
        }
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
        
        // Notify general change listeners (lib-agnostic)
        for (var i = 0; i < array_length(self.__changeListeners); i++) {
            self.__changeListeners[i](self.state);
        }
    };
    
    /**
     * Subscribe to general state changes (lib-agnostic).
     * Use this to integrate with UI frameworks or other systems.
     * @param {Function} callback Callback receiving the full state
     * @returns {Function} Unsubscribe function
     */
    self.subscribeChanged = function(callback) {
        array_push(self.__changeListeners, callback);
        return function() {
            var _index = array_find_index(self.__changeListeners, callback);
            if (_index != -1) array_delete(self.__changeListeners, _index, 1);
        };
    };
    
    /**
     * Destroy the store and cleanup all listeners.
     */
    self.destroy = function() {
        self.__selectorListeners = [];
        self.__changeListeners = [];
        self.actions = {};
        self.__snapshotStack = [];
        self.__redoStack = [];
    };
}
