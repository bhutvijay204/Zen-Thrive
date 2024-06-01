"use strict";

var extendStatics = function(e, t) {
return (extendStatics = Object.setPrototypeOf || {
__proto__: []
} instanceof Array && function(e, t) {
e.__proto__ = t;
} || function(e, t) {
for (var r in t) t.hasOwnProperty(r) && (e[r] = t[r]);
})(e, t);
};

function __extends(e, t) {
extendStatics(e, t);
function r() {
this.constructor = e;
}
e.prototype = null === t ? Object.create(t) : (r.prototype = t.prototype, new r());
}

var __assign = function() {
return (__assign = Object.assign || function(e) {
for (var t, r = 1, n = arguments.length; r < n; r++) {
t = arguments[r];
for (var a in t) Object.prototype.hasOwnProperty.call(t, a) && (e[a] = t[a]);
}
return e;
}).apply(this, arguments);
};

function __values(e) {
var t = "function" == typeof Symbol && e[Symbol.iterator], r = 0;
return t ? t.call(e) : {
next: function() {
e && r >= e.length && (e = void 0);
return {
value: e && e[r++],
done: !e
};
}
};
}

function __read(e, t) {
var r = "function" == typeof Symbol && e[Symbol.iterator];
if (!r) return e;
var n, a, o = r.call(e), i = [];
try {
for (;(void 0 === t || t-- > 0) && !(n = o.next()).done; ) i.push(n.value);
} catch (e) {
a = {
error: e
};
} finally {
try {
n && !n.done && (r = o.return) && r.call(o);
} finally {
if (a) throw a.error;
}
}
return i;
}

function __spread() {
for (var e = [], t = 0; t < arguments.length; t++) e = e.concat(__read(arguments[t]));
return e;
}

var OBFUSCATED_ERROR = "An invariant failed, however the error is obfuscated because this is a production build.", EMPTY_ARRAY = [];

Object.freeze(EMPTY_ARRAY);

var EMPTY_OBJECT = {};

Object.freeze(EMPTY_OBJECT);

function getNextId() {
return ++globalState.mobxGuid;
}

function fail(e) {
invariant(!1, e);
throw "X";
}

function invariant(e, t) {
if (!e) throw new Error("[mobx] " + (t || OBFUSCATED_ERROR));
}

var deprecatedMessages = [];

function deprecated(e, t) {
if (t) return deprecated("'" + e + "', use '" + t + "' instead.");
if (-1 !== deprecatedMessages.indexOf(e)) return !1;
deprecatedMessages.push(e);
console.error("[mobx] Deprecated: " + e);
return !0;
}

function once(e) {
var t = !1;
return function() {
if (!t) {
t = !0;
return e.apply(this, arguments);
}
};
}

var noop = function() {};

function unique(e) {
var t = [];
e.forEach(function(e) {
-1 === t.indexOf(e) && t.push(e);
});
return t;
}

function isObject(e) {
return null !== e && "object" == typeof e;
}

function isPlainObject(e) {
if (null === e || "object" != typeof e) return !1;
var t = Object.getPrototypeOf(e);
return t === Object.prototype || null === t;
}

function addHiddenProp(e, t, r) {
Object.defineProperty(e, t, {
enumerable: !1,
writable: !0,
configurable: !0,
value: r
});
}

function addHiddenFinalProp(e, t, r) {
Object.defineProperty(e, t, {
enumerable: !1,
writable: !1,
configurable: !0,
value: r
});
}

function isPropertyConfigurable(e, t) {
var r = Object.getOwnPropertyDescriptor(e, t);
return !r || !1 !== r.configurable && !1 !== r.writable;
}

function assertPropertyConfigurable(e, t) {
isPropertyConfigurable(e, t) || fail("Cannot make property '" + t.toString() + "' observable, it is not configurable and writable in the target object");
}

function createInstanceofPredicate(e, t) {
var r = "isMobX" + e;
t.prototype[r] = !0;
return function(e) {
return isObject(e) && !0 === e[r];
};
}

function isArrayLike(e) {
return Array.isArray(e) || isObservableArray(e);
}

function isES6Map(e) {
return e instanceof Map;
}

function isES6Set(e) {
return e instanceof Set;
}

function getPlainObjectKeys(e) {
var t = new Set();
for (var r in e) t.add(r);
Object.getOwnPropertySymbols(e).forEach(function(r) {
Object.getOwnPropertyDescriptor(e, r).enumerable && t.add(r);
});
return Array.from(t);
}

function stringifyKey(e) {
return e && e.toString ? e.toString() : new String(e).toString();
}

function getMapLikeKeys(e) {
return isPlainObject(e) ? Object.keys(e) : Array.isArray(e) ? e.map(function(e) {
return __read(e, 1)[0];
}) : isES6Map(e) || isObservableMap(e) ? Array.from(e.keys()) : fail("Cannot get keys from '" + e + "'");
}

function toPrimitive(e) {
return null === e ? null : "object" == typeof e ? "" + e : e;
}

var $mobx = Symbol("mobx administration"), Atom = function() {
function e(e) {
void 0 === e && (e = "Atom@" + getNextId());
this.name = e;
this.isPendingUnobservation = !1;
this.isBeingObserved = !1;
this.observers = new Set();
this.diffValue = 0;
this.lastAccessedBy = 0;
this.lowestObserverState = IDerivationState.NOT_TRACKING;
}
e.prototype.onBecomeObserved = function() {
this.onBecomeObservedListeners && this.onBecomeObservedListeners.forEach(function(e) {
return e();
});
};
e.prototype.onBecomeUnobserved = function() {
this.onBecomeUnobservedListeners && this.onBecomeUnobservedListeners.forEach(function(e) {
return e();
});
};
e.prototype.reportObserved = function() {
return reportObserved(this);
};
e.prototype.reportChanged = function() {
startBatch();
propagateChanged(this);
endBatch();
};
e.prototype.toString = function() {
return this.name;
};
return e;
}(), isAtom = createInstanceofPredicate("Atom", Atom);

function createAtom(e, t, r) {
void 0 === t && (t = noop);
void 0 === r && (r = noop);
var n = new Atom(e);
t !== noop && onBecomeObserved(n, t);
r !== noop && onBecomeUnobserved(n, r);
return n;
}

function identityComparer(e, t) {
return e === t;
}

function structuralComparer(e, t) {
return deepEqual(e, t);
}

function shallowComparer(e, t) {
return deepEqual(e, t, 1);
}

function defaultComparer(e, t) {
return Object.is(e, t);
}

var comparer = {
identity: identityComparer,
structural: structuralComparer,
default: defaultComparer,
shallow: shallowComparer
}, mobxDidRunLazyInitializersSymbol = Symbol("mobx did run lazy initializers"), mobxPendingDecorators = Symbol("mobx pending decorators"), enumerableDescriptorCache = {}, nonEnumerableDescriptorCache = {};

function createPropertyInitializerDescriptor(e, t) {
var r = t ? enumerableDescriptorCache : nonEnumerableDescriptorCache;
return r[e] || (r[e] = {
configurable: !0,
enumerable: t,
get: function() {
initializeInstance(this);
return this[e];
},
set: function(t) {
initializeInstance(this);
this[e] = t;
}
});
}

function initializeInstance(e) {
var t, r;
if (!0 !== e[mobxDidRunLazyInitializersSymbol]) {
var n = e[mobxPendingDecorators];
if (n) {
addHiddenProp(e, mobxDidRunLazyInitializersSymbol, !0);
var a = __spread(Object.getOwnPropertySymbols(n), Object.keys(n));
try {
for (var o = __values(a), i = o.next(); !i.done; i = o.next()) {
var s = n[i.value];
s.propertyCreator(e, s.prop, s.descriptor, s.decoratorTarget, s.decoratorArguments);
}
} catch (e) {
t = {
error: e
};
} finally {
try {
i && !i.done && (r = o.return) && r.call(o);
} finally {
if (t) throw t.error;
}
}
}
}
}

function createPropDecorator(e, t) {
return function() {
var r, n = function(n, a, o, i) {
if (!0 === i) {
t(n, a, o, n, r);
return null;
}
quacksLikeADecorator(arguments) || fail("This function is a decorator, but it wasn't invoked like a decorator");
if (!Object.prototype.hasOwnProperty.call(n, mobxPendingDecorators)) {
var s = n[mobxPendingDecorators];
addHiddenProp(n, mobxPendingDecorators, __assign({}, s));
}
n[mobxPendingDecorators][a] = {
prop: a,
propertyCreator: t,
descriptor: o,
decoratorTarget: n,
decoratorArguments: r
};
return createPropertyInitializerDescriptor(a, e);
};
if (quacksLikeADecorator(arguments)) {
r = EMPTY_ARRAY;
return n.apply(null, arguments);
}
r = Array.prototype.slice.call(arguments);
return n;
};
}

function quacksLikeADecorator(e) {
return (2 === e.length || 3 === e.length) && ("string" == typeof e[1] || "symbol" == typeof e[1]) || 4 === e.length && !0 === e[3];
}

function deepEnhancer(e, t, r) {
return isObservable(e) ? e : Array.isArray(e) ? observable.array(e, {
name: r
}) : isPlainObject(e) ? observable.object(e, void 0, {
name: r
}) : isES6Map(e) ? observable.map(e, {
name: r
}) : isES6Set(e) ? observable.set(e, {
name: r
}) : e;
}

function shallowEnhancer(e, t, r) {
return null == e ? e : isObservableObject(e) || isObservableArray(e) || isObservableMap(e) || isObservableSet(e) ? e : Array.isArray(e) ? observable.array(e, {
name: r,
deep: !1
}) : isPlainObject(e) ? observable.object(e, void 0, {
name: r,
deep: !1
}) : isES6Map(e) ? observable.map(e, {
name: r,
deep: !1
}) : isES6Set(e) ? observable.set(e, {
name: r,
deep: !1
}) : fail("The shallow modifier / decorator can only used in combination with arrays, objects, maps and sets");
}

function referenceEnhancer(e) {
return e;
}

function refStructEnhancer(e, t) {
if (isObservable(e)) throw "observable.struct should not be used with observable values";
return deepEqual(e, t) ? t : e;
}

function createDecoratorForEnhancer(e) {
invariant(e);
var t = createPropDecorator(!0, function(t, r, n) {
invariant(!n || !n.get, '@observable cannot be used on getter (property "' + stringifyKey(r) + '"), use @computed instead.');
var a = n ? n.initializer ? n.initializer.call(t) : n.value : void 0;
asObservableObject(t).addObservableProp(r, a, e);
}), r = "undefined" != typeof process && process.env ? function() {
return arguments.length < 2 ? fail("Incorrect decorator invocation. @observable decorator doesn't expect any arguments") : t.apply(null, arguments);
} : t;
r.enhancer = e;
return r;
}

var defaultCreateObservableOptions = {
deep: !0,
name: void 0,
defaultDecorator: void 0,
proxy: !0
};

Object.freeze(defaultCreateObservableOptions);

function assertValidOption(e) {
/^(deep|name|equals|defaultDecorator|proxy)$/.test(e) || fail("invalid option for (extend)observable: " + e);
}

function asCreateObservableOptions(e) {
if (null == e) return defaultCreateObservableOptions;
if ("string" == typeof e) return {
name: e,
deep: !0,
proxy: !0
};
if ("object" != typeof e) return fail("expected options object");
Object.keys(e).forEach(assertValidOption);
return e;
}

var deepDecorator = createDecoratorForEnhancer(deepEnhancer), shallowDecorator = createDecoratorForEnhancer(shallowEnhancer), refDecorator = createDecoratorForEnhancer(referenceEnhancer), refStructDecorator = createDecoratorForEnhancer(refStructEnhancer);

function getEnhancerFromOptions(e) {
return e.defaultDecorator ? e.defaultDecorator.enhancer : !1 === e.deep ? referenceEnhancer : deepEnhancer;
}

function createObservable(e, t, r) {
if ("string" == typeof arguments[1] || "symbol" == typeof arguments[1]) return deepDecorator.apply(null, arguments);
if (isObservable(e)) return e;
var n = isPlainObject(e) ? observable.object(e, t, r) : Array.isArray(e) ? observable.array(e, t) : isES6Map(e) ? observable.map(e, t) : isES6Set(e) ? observable.set(e, t) : e;
if (n !== e) return n;
fail("The provided value could not be converted into an observable. If you want just create an observable reference to the object use 'observable.box(value)'");
}

var observableFactories = {
box: function(e, t) {
arguments.length > 2 && incorrectlyUsedAsDecorator("box");
var r = asCreateObservableOptions(t);
return new ObservableValue(e, getEnhancerFromOptions(r), r.name, !0, r.equals);
},
array: function(e, t) {
arguments.length > 2 && incorrectlyUsedAsDecorator("array");
var r = asCreateObservableOptions(t);
return createObservableArray(e, getEnhancerFromOptions(r), r.name);
},
map: function(e, t) {
arguments.length > 2 && incorrectlyUsedAsDecorator("map");
var r = asCreateObservableOptions(t);
return new ObservableMap(e, getEnhancerFromOptions(r), r.name);
},
set: function(e, t) {
arguments.length > 2 && incorrectlyUsedAsDecorator("set");
var r = asCreateObservableOptions(t);
return new ObservableSet(e, getEnhancerFromOptions(r), r.name);
},
object: function(e, t, r) {
"string" == typeof arguments[1] && incorrectlyUsedAsDecorator("object");
var n = asCreateObservableOptions(r);
if (!1 === n.proxy) return extendObservable({}, e, t, n);
var a = getDefaultDecoratorFromObjectOptions(n), o = extendObservable({}, void 0, void 0, n), i = createDynamicObservableObject(o);
extendObservableObjectWithProperties(i, e, t, a);
return i;
},
ref: refDecorator,
shallow: shallowDecorator,
deep: deepDecorator,
struct: refStructDecorator
}, observable = createObservable;

Object.keys(observableFactories).forEach(function(e) {
return observable[e] = observableFactories[e];
});

function incorrectlyUsedAsDecorator(e) {
fail("Expected one or two arguments to observable." + e + ". Did you accidentally try to use observable." + e + " as decorator?");
}

var computedDecorator = createPropDecorator(!1, function(e, t, r, n, a) {
var o = r.get, i = r.set, s = a[0] || {};
asObservableObject(e).addComputedProp(e, t, __assign({
get: o,
set: i,
context: e
}, s));
}), computedStructDecorator = computedDecorator({
equals: comparer.structural
}), computed = function(e, t) {
if ("string" == typeof t) return computedDecorator.apply(null, arguments);
if (null !== e && "object" == typeof e && 1 === arguments.length) return computedDecorator.apply(null, arguments);
invariant("function" == typeof e, "First argument to `computed` should be an expression.");
invariant(arguments.length < 3, "Computed takes one or two arguments if used as function");
var r = "object" == typeof t ? t : {};
r.get = e;
r.set = "function" == typeof t ? t : r.set;
r.name = r.name || e.name || "";
return new ComputedValue(r);
};

computed.struct = computedStructDecorator;

var TraceMode, IDerivationState = IDerivationState || {};

(function(e) {
e[e.NOT_TRACKING = -1] = "NOT_TRACKING";
e[e.UP_TO_DATE = 0] = "UP_TO_DATE";
e[e.POSSIBLY_STALE = 1] = "POSSIBLY_STALE";
e[e.STALE = 2] = "STALE";
})(IDerivationState || (exports.IDerivationState = {}));

(function(e) {
e[e.NONE = 0] = "NONE";
e[e.LOG = 1] = "LOG";
e[e.BREAK = 2] = "BREAK";
})(TraceMode || (TraceMode = {}));

var CaughtException = function(e) {
this.cause = e;
};

function isCaughtException(e) {
return e instanceof CaughtException;
}

function shouldCompute(e) {
switch (e.dependenciesState) {
case IDerivationState.UP_TO_DATE:
return !1;

case IDerivationState.NOT_TRACKING:
case IDerivationState.STALE:
return !0;

case IDerivationState.POSSIBLY_STALE:
for (var t = allowStateReadsStart(!0), r = untrackedStart(), n = e.observing, a = n.length, o = 0; o < a; o++) {
var i = n[o];
if (isComputedValue(i)) {
if (globalState.disableErrorBoundaries) i.get(); else try {
i.get();
} catch (e) {
untrackedEnd(r);
allowStateReadsEnd(t);
return !0;
}
if (e.dependenciesState === IDerivationState.STALE) {
untrackedEnd(r);
allowStateReadsEnd(t);
return !0;
}
}
}
changeDependenciesStateTo0(e);
untrackedEnd(r);
allowStateReadsEnd(t);
return !1;
}
}

function isComputingDerivation() {
return null !== globalState.trackingDerivation;
}

function checkIfStateModificationsAreAllowed(e) {
var t = e.observers.size > 0;
globalState.computationDepth > 0 && t && fail("Computed values are not allowed to cause side effects by changing observables that are already being observed. Tried to modify: " + e.name);
globalState.allowStateChanges || !t && "strict" !== globalState.enforceActions || fail((globalState.enforceActions ? "Since strict-mode is enabled, changing observed observable values outside actions is not allowed. Please wrap the code in an `action` if this change is intended. Tried to modify: " : "Side effects like changing state are not allowed at this point. Are you trying to modify state from, for example, the render function of a React component? Tried to modify: ") + e.name);
}

function checkIfStateReadsAreAllowed(e) {
!globalState.allowStateReads && globalState.observableRequiresReaction && console.warn("[mobx] Observable " + e.name + " being read outside a reactive context");
}

function trackDerivedFunction(e, t, r) {
var n = allowStateReadsStart(!0);
changeDependenciesStateTo0(e);
e.newObserving = new Array(e.observing.length + 100);
e.unboundDepsCount = 0;
e.runId = ++globalState.runId;
var a, o = globalState.trackingDerivation;
globalState.trackingDerivation = e;
if (!0 === globalState.disableErrorBoundaries) a = t.call(r); else try {
a = t.call(r);
} catch (e) {
a = new CaughtException(e);
}
globalState.trackingDerivation = o;
bindDependencies(e);
warnAboutDerivationWithoutDependencies(e);
allowStateReadsEnd(n);
return a;
}

function warnAboutDerivationWithoutDependencies(e) {
0 === e.observing.length && (globalState.reactionRequiresObservable || e.requiresObservable) && console.warn("[mobx] Derivation " + e.name + " is created/updated without reading any observable value");
}

function bindDependencies(e) {
for (var t = e.observing, r = e.observing = e.newObserving, n = IDerivationState.UP_TO_DATE, a = 0, o = e.unboundDepsCount, i = 0; i < o; i++) {
if (0 === (s = r[i]).diffValue) {
s.diffValue = 1;
a !== i && (r[a] = s);
a++;
}
s.dependenciesState > n && (n = s.dependenciesState);
}
r.length = a;
e.newObserving = null;
o = t.length;
for (;o--; ) {
0 === (s = t[o]).diffValue && removeObserver(s, e);
s.diffValue = 0;
}
for (;a--; ) {
var s;
if (1 === (s = r[a]).diffValue) {
s.diffValue = 0;
addObserver(s, e);
}
}
if (n !== IDerivationState.UP_TO_DATE) {
e.dependenciesState = n;
e.onBecomeStale();
}
}

function clearObserving(e) {
var t = e.observing;
e.observing = [];
for (var r = t.length; r--; ) removeObserver(t[r], e);
e.dependenciesState = IDerivationState.NOT_TRACKING;
}

function untracked(e) {
var t = untrackedStart();
try {
return e();
} finally {
untrackedEnd(t);
}
}

function untrackedStart() {
var e = globalState.trackingDerivation;
globalState.trackingDerivation = null;
return e;
}

function untrackedEnd(e) {
globalState.trackingDerivation = e;
}

function allowStateReadsStart(e) {
var t = globalState.allowStateReads;
globalState.allowStateReads = e;
return t;
}

function allowStateReadsEnd(e) {
globalState.allowStateReads = e;
}

function changeDependenciesStateTo0(e) {
if (e.dependenciesState !== IDerivationState.UP_TO_DATE) {
e.dependenciesState = IDerivationState.UP_TO_DATE;
for (var t = e.observing, r = t.length; r--; ) t[r].lowestObserverState = IDerivationState.UP_TO_DATE;
}
}

var currentActionId = 0, nextActionId = 1, functionNameDescriptor = Object.getOwnPropertyDescriptor(function() {}, "name"), isFunctionNameConfigurable = functionNameDescriptor && functionNameDescriptor.configurable;

function createAction(e, t, r) {
invariant("function" == typeof t, "`action` can only be invoked on functions");
"string" == typeof e && e || fail("actions should have valid names, got: '" + e + "'");
var n = function() {
return executeAction(e, t, r || this, arguments);
};
n.isMobxAction = !0;
isFunctionNameConfigurable && Object.defineProperty(n, "name", {
value: e
});
return n;
}

function executeAction(e, t, r, n) {
var a = _startAction(e, r, n);
try {
return t.apply(r, n);
} catch (e) {
a.error = e;
throw e;
} finally {
_endAction(a);
}
}

function _startAction(e, t, r) {
var n = isSpyEnabled() && !!e, a = 0;
if (n) {
a = Date.now();
var o = r && r.length || 0, i = new Array(o);
if (o > 0) for (var s = 0; s < o; s++) i[s] = r[s];
spyReportStart({
type: "action",
name: e,
object: t,
arguments: i
});
}
var c = untrackedStart();
startBatch();
var l = {
prevDerivation: c,
prevAllowStateChanges: allowStateChangesStart(!0),
prevAllowStateReads: allowStateReadsStart(!0),
notifySpy: n,
startTime: a,
actionId: nextActionId++,
parentActionId: currentActionId
};
currentActionId = l.actionId;
return l;
}

function _endAction(e) {
currentActionId !== e.actionId && fail("invalid action stack. did you forget to finish an action?");
currentActionId = e.parentActionId;
void 0 !== e.error && (globalState.suppressReactionErrors = !0);
allowStateChangesEnd(e.prevAllowStateChanges);
allowStateReadsEnd(e.prevAllowStateReads);
endBatch();
untrackedEnd(e.prevDerivation);
e.notifySpy && spyReportEnd({
time: Date.now() - e.startTime
});
globalState.suppressReactionErrors = !1;
}

function allowStateChanges(e, t) {
var r, n = allowStateChangesStart(e);
try {
r = t();
} finally {
allowStateChangesEnd(n);
}
return r;
}

function allowStateChangesStart(e) {
var t = globalState.allowStateChanges;
globalState.allowStateChanges = e;
return t;
}

function allowStateChangesEnd(e) {
globalState.allowStateChanges = e;
}

function allowStateChangesInsideComputed(e) {
var t, r = globalState.computationDepth;
globalState.computationDepth = 0;
try {
t = e();
} finally {
globalState.computationDepth = r;
}
return t;
}

var ObservableValue = function(e) {
__extends(t, e);
function t(t, r, n, a, o) {
void 0 === n && (n = "ObservableValue@" + getNextId());
void 0 === a && (a = !0);
void 0 === o && (o = comparer.default);
var i = e.call(this, n) || this;
i.enhancer = r;
i.name = n;
i.equals = o;
i.hasUnreportedChange = !1;
i.value = r(t, void 0, n);
a && isSpyEnabled() && spyReport({
type: "create",
name: i.name,
newValue: "" + i.value
});
return i;
}
t.prototype.dehanceValue = function(e) {
return void 0 !== this.dehancer ? this.dehancer(e) : e;
};
t.prototype.set = function(e) {
var t = this.value;
if ((e = this.prepareNewValue(e)) !== globalState.UNCHANGED) {
var r = isSpyEnabled();
r && spyReportStart({
type: "update",
name: this.name,
newValue: e,
oldValue: t
});
this.setNewValue(e);
r && spyReportEnd();
}
};
t.prototype.prepareNewValue = function(e) {
checkIfStateModificationsAreAllowed(this);
if (hasInterceptors(this)) {
var t = interceptChange(this, {
object: this,
type: "update",
newValue: e
});
if (!t) return globalState.UNCHANGED;
e = t.newValue;
}
e = this.enhancer(e, this.value, this.name);
return this.equals(this.value, e) ? globalState.UNCHANGED : e;
};
t.prototype.setNewValue = function(e) {
var t = this.value;
this.value = e;
this.reportChanged();
hasListeners(this) && notifyListeners(this, {
type: "update",
object: this,
newValue: e,
oldValue: t
});
};
t.prototype.get = function() {
this.reportObserved();
return this.dehanceValue(this.value);
};
t.prototype.intercept = function(e) {
return registerInterceptor(this, e);
};
t.prototype.observe = function(e, t) {
t && e({
object: this,
type: "update",
newValue: this.value,
oldValue: void 0
});
return registerListener(this, e);
};
t.prototype.toJSON = function() {
return this.get();
};
t.prototype.toString = function() {
return this.name + "[" + this.value + "]";
};
t.prototype.valueOf = function() {
return toPrimitive(this.get());
};
t.prototype[Symbol.toPrimitive] = function() {
return this.valueOf();
};
return t;
}(Atom), isObservableValue = createInstanceofPredicate("ObservableValue", ObservableValue), ComputedValue = function() {
function e(e) {
this.dependenciesState = IDerivationState.NOT_TRACKING;
this.observing = [];
this.newObserving = null;
this.isBeingObserved = !1;
this.isPendingUnobservation = !1;
this.observers = new Set();
this.diffValue = 0;
this.runId = 0;
this.lastAccessedBy = 0;
this.lowestObserverState = IDerivationState.UP_TO_DATE;
this.unboundDepsCount = 0;
this.__mapid = "#" + getNextId();
this.value = new CaughtException(null);
this.isComputing = !1;
this.isRunningSetter = !1;
this.isTracing = TraceMode.NONE;
invariant(e.get, "missing option for computed: get");
this.derivation = e.get;
this.name = e.name || "ComputedValue@" + getNextId();
e.set && (this.setter = createAction(this.name + "-setter", e.set));
this.equals = e.equals || (e.compareStructural || e.struct ? comparer.structural : comparer.default);
this.scope = e.context;
this.requiresReaction = !!e.requiresReaction;
this.keepAlive = !!e.keepAlive;
}
e.prototype.onBecomeStale = function() {
propagateMaybeChanged(this);
};
e.prototype.onBecomeObserved = function() {
this.onBecomeObservedListeners && this.onBecomeObservedListeners.forEach(function(e) {
return e();
});
};
e.prototype.onBecomeUnobserved = function() {
this.onBecomeUnobservedListeners && this.onBecomeUnobservedListeners.forEach(function(e) {
return e();
});
};
e.prototype.get = function() {
this.isComputing && fail("Cycle detected in computation " + this.name + ": " + this.derivation);
if (0 !== globalState.inBatch || 0 !== this.observers.size || this.keepAlive) {
reportObserved(this);
shouldCompute(this) && this.trackAndCompute() && propagateChangeConfirmed(this);
} else if (shouldCompute(this)) {
this.warnAboutUntrackedRead();
startBatch();
this.value = this.computeValue(!1);
endBatch();
}
var e = this.value;
if (isCaughtException(e)) throw e.cause;
return e;
};
e.prototype.peek = function() {
var e = this.computeValue(!1);
if (isCaughtException(e)) throw e.cause;
return e;
};
e.prototype.set = function(e) {
if (this.setter) {
invariant(!this.isRunningSetter, "The setter of computed value '" + this.name + "' is trying to update itself. Did you intend to update an _observable_ value, instead of the computed property?");
this.isRunningSetter = !0;
try {
this.setter.call(this.scope, e);
} finally {
this.isRunningSetter = !1;
}
} else invariant(!1, "[ComputedValue '" + this.name + "'] It is not possible to assign a new value to a computed value.");
};
e.prototype.trackAndCompute = function() {
isSpyEnabled() && spyReport({
object: this.scope,
type: "compute",
name: this.name
});
var e = this.value, t = this.dependenciesState === IDerivationState.NOT_TRACKING, r = this.computeValue(!0), n = t || isCaughtException(e) || isCaughtException(r) || !this.equals(e, r);
n && (this.value = r);
return n;
};
e.prototype.computeValue = function(e) {
this.isComputing = !0;
globalState.computationDepth++;
var t;
if (e) t = trackDerivedFunction(this, this.derivation, this.scope); else if (!0 === globalState.disableErrorBoundaries) t = this.derivation.call(this.scope); else try {
t = this.derivation.call(this.scope);
} catch (e) {
t = new CaughtException(e);
}
globalState.computationDepth--;
this.isComputing = !1;
return t;
};
e.prototype.suspend = function() {
if (!this.keepAlive) {
clearObserving(this);
this.value = void 0;
}
};
e.prototype.observe = function(e, t) {
var r = this, n = !0, a = void 0;
return autorun(function() {
var o = r.get();
if (!n || t) {
var i = untrackedStart();
e({
type: "update",
object: r,
newValue: o,
oldValue: a
});
untrackedEnd(i);
}
n = !1;
a = o;
});
};
e.prototype.warnAboutUntrackedRead = function() {
!0 === this.requiresReaction && fail("[mobx] Computed value " + this.name + " is read outside a reactive context");
this.isTracing !== TraceMode.NONE && console.log("[mobx.trace] '" + this.name + "' is being read outside a reactive context. Doing a full recompute");
globalState.computedRequiresReaction && console.warn("[mobx] Computed value " + this.name + " is being read outside a reactive context. Doing a full recompute");
};
e.prototype.toJSON = function() {
return this.get();
};
e.prototype.toString = function() {
return this.name + "[" + this.derivation.toString() + "]";
};
e.prototype.valueOf = function() {
return toPrimitive(this.get());
};
e.prototype[Symbol.toPrimitive] = function() {
return this.valueOf();
};
return e;
}(), isComputedValue = createInstanceofPredicate("ComputedValue", ComputedValue), persistentKeys = [ "mobxGuid", "spyListeners", "enforceActions", "computedRequiresReaction", "reactionRequiresObservable", "observableRequiresReaction", "allowStateReads", "disableErrorBoundaries", "runId", "UNCHANGED" ], MobXGlobals = function() {
this.version = 5;
this.UNCHANGED = {};
this.trackingDerivation = null;
this.computationDepth = 0;
this.runId = 0;
this.mobxGuid = 0;
this.inBatch = 0;
this.pendingUnobservations = [];
this.pendingReactions = [];
this.isRunningReactions = !1;
this.allowStateChanges = !0;
this.allowStateReads = !0;
this.enforceActions = !1;
this.spyListeners = [];
this.globalReactionErrorHandlers = [];
this.computedRequiresReaction = !1;
this.reactionRequiresObservable = !1;
this.observableRequiresReaction = !1;
this.computedConfigurable = !1;
this.disableErrorBoundaries = !1;
this.suppressReactionErrors = !1;
}, mockGlobal = {};

function getGlobal() {
return "undefined" != typeof window ? window : "undefined" != typeof global ? global : "undefined" != typeof self ? self : mockGlobal;
}

var canMergeGlobalState = !0, isolateCalled = !1, globalState = function() {
var e = getGlobal();
e.__mobxInstanceCount > 0 && !e.__mobxGlobals && (canMergeGlobalState = !1);
e.__mobxGlobals && e.__mobxGlobals.version !== new MobXGlobals().version && (canMergeGlobalState = !1);
if (canMergeGlobalState) {
if (e.__mobxGlobals) {
e.__mobxInstanceCount += 1;
e.__mobxGlobals.UNCHANGED || (e.__mobxGlobals.UNCHANGED = {});
return e.__mobxGlobals;
}
e.__mobxInstanceCount = 1;
return e.__mobxGlobals = new MobXGlobals();
}
setTimeout(function() {
isolateCalled || fail("There are multiple, different versions of MobX active. Make sure MobX is loaded only once or use `configure({ isolateGlobalState: true })`");
}, 1);
return new MobXGlobals();
}();

function isolateGlobalState() {
(globalState.pendingReactions.length || globalState.inBatch || globalState.isRunningReactions) && fail("isolateGlobalState should be called before MobX is running any reactions");
isolateCalled = !0;
if (canMergeGlobalState) {
0 == --getGlobal().__mobxInstanceCount && (getGlobal().__mobxGlobals = void 0);
globalState = new MobXGlobals();
}
}

function getGlobalState() {
return globalState;
}

function resetGlobalState() {
var e = new MobXGlobals();
for (var t in e) -1 === persistentKeys.indexOf(t) && (globalState[t] = e[t]);
globalState.allowStateChanges = !globalState.enforceActions;
}

function hasObservers(e) {
return e.observers && e.observers.size > 0;
}

function getObservers(e) {
return e.observers;
}

function addObserver(e, t) {
e.observers.add(t);
e.lowestObserverState > t.dependenciesState && (e.lowestObserverState = t.dependenciesState);
}

function removeObserver(e, t) {
e.observers.delete(t);
0 === e.observers.size && queueForUnobservation(e);
}

function queueForUnobservation(e) {
if (!1 === e.isPendingUnobservation) {
e.isPendingUnobservation = !0;
globalState.pendingUnobservations.push(e);
}
}

function startBatch() {
globalState.inBatch++;
}

function endBatch() {
if (0 == --globalState.inBatch) {
runReactions();
for (var e = globalState.pendingUnobservations, t = 0; t < e.length; t++) {
var r = e[t];
r.isPendingUnobservation = !1;
if (0 === r.observers.size) {
if (r.isBeingObserved) {
r.isBeingObserved = !1;
r.onBecomeUnobserved();
}
r instanceof ComputedValue && r.suspend();
}
}
globalState.pendingUnobservations = [];
}
}

function reportObserved(e) {
checkIfStateReadsAreAllowed(e);
var t = globalState.trackingDerivation;
if (null !== t) {
if (t.runId !== e.lastAccessedBy) {
e.lastAccessedBy = t.runId;
t.newObserving[t.unboundDepsCount++] = e;
if (!e.isBeingObserved) {
e.isBeingObserved = !0;
e.onBecomeObserved();
}
}
return !0;
}
0 === e.observers.size && globalState.inBatch > 0 && queueForUnobservation(e);
return !1;
}

function propagateChanged(e) {
if (e.lowestObserverState !== IDerivationState.STALE) {
e.lowestObserverState = IDerivationState.STALE;
e.observers.forEach(function(t) {
if (t.dependenciesState === IDerivationState.UP_TO_DATE) {
t.isTracing !== TraceMode.NONE && logTraceInfo(t, e);
t.onBecomeStale();
}
t.dependenciesState = IDerivationState.STALE;
});
}
}

function propagateChangeConfirmed(e) {
if (e.lowestObserverState !== IDerivationState.STALE) {
e.lowestObserverState = IDerivationState.STALE;
e.observers.forEach(function(t) {
t.dependenciesState === IDerivationState.POSSIBLY_STALE ? t.dependenciesState = IDerivationState.STALE : t.dependenciesState === IDerivationState.UP_TO_DATE && (e.lowestObserverState = IDerivationState.UP_TO_DATE);
});
}
}

function propagateMaybeChanged(e) {
if (e.lowestObserverState === IDerivationState.UP_TO_DATE) {
e.lowestObserverState = IDerivationState.POSSIBLY_STALE;
e.observers.forEach(function(t) {
if (t.dependenciesState === IDerivationState.UP_TO_DATE) {
t.dependenciesState = IDerivationState.POSSIBLY_STALE;
t.isTracing !== TraceMode.NONE && logTraceInfo(t, e);
t.onBecomeStale();
}
});
}
}

function logTraceInfo(e, t) {
console.log("[mobx.trace] '" + e.name + "' is invalidated due to a change in: '" + t.name + "'");
if (e.isTracing === TraceMode.BREAK) {
var r = [];
printDepTree(getDependencyTree(e), r, 1);
new Function("debugger;\n/*\nTracing '" + e.name + "'\n\nYou are entering this break point because derivation '" + e.name + "' is being traced and '" + t.name + "' is now forcing it to update.\nJust follow the stacktrace you should now see in the devtools to see precisely what piece of your code is causing this update\nThe stackframe you are looking for is at least ~6-8 stack-frames up.\n\n" + (e instanceof ComputedValue ? e.derivation.toString().replace(/[*]\//g, "/") : "") + "\n\nThe dependencies for this derivation are:\n\n" + r.join("\n") + "\n*/\n    ")();
}
}

function printDepTree(e, t, r) {
if (t.length >= 1e3) t.push("(and many more)"); else {
t.push("" + new Array(r).join("\t") + e.name);
e.dependencies && e.dependencies.forEach(function(e) {
return printDepTree(e, t, r + 1);
});
}
}

var Reaction = function() {
function e(e, t, r, n) {
void 0 === e && (e = "Reaction@" + getNextId());
void 0 === n && (n = !1);
this.name = e;
this.onInvalidate = t;
this.errorHandler = r;
this.requiresObservable = n;
this.observing = [];
this.newObserving = [];
this.dependenciesState = IDerivationState.NOT_TRACKING;
this.diffValue = 0;
this.runId = 0;
this.unboundDepsCount = 0;
this.__mapid = "#" + getNextId();
this.isDisposed = !1;
this._isScheduled = !1;
this._isTrackPending = !1;
this._isRunning = !1;
this.isTracing = TraceMode.NONE;
}
e.prototype.onBecomeStale = function() {
this.schedule();
};
e.prototype.schedule = function() {
if (!this._isScheduled) {
this._isScheduled = !0;
globalState.pendingReactions.push(this);
runReactions();
}
};
e.prototype.isScheduled = function() {
return this._isScheduled;
};
e.prototype.runReaction = function() {
if (!this.isDisposed) {
startBatch();
this._isScheduled = !1;
if (shouldCompute(this)) {
this._isTrackPending = !0;
try {
this.onInvalidate();
this._isTrackPending && isSpyEnabled() && spyReport({
name: this.name,
type: "scheduled-reaction"
});
} catch (e) {
this.reportExceptionInDerivation(e);
}
}
endBatch();
}
};
e.prototype.track = function(e) {
if (!this.isDisposed) {
startBatch();
var t, r = isSpyEnabled();
if (r) {
t = Date.now();
spyReportStart({
name: this.name,
type: "reaction"
});
}
this._isRunning = !0;
var n = trackDerivedFunction(this, e, void 0);
this._isRunning = !1;
this._isTrackPending = !1;
this.isDisposed && clearObserving(this);
isCaughtException(n) && this.reportExceptionInDerivation(n.cause);
r && spyReportEnd({
time: Date.now() - t
});
endBatch();
}
};
e.prototype.reportExceptionInDerivation = function(e) {
var t = this;
if (this.errorHandler) this.errorHandler(e, this); else {
if (globalState.disableErrorBoundaries) throw e;
var r = "[mobx] Encountered an uncaught exception that was thrown by a reaction or observer component, in: '" + this + "'";
globalState.suppressReactionErrors ? console.warn("[mobx] (error in reaction '" + this.name + "' suppressed, fix error of causing action below)") : console.error(r, e);
isSpyEnabled() && spyReport({
type: "error",
name: this.name,
message: r,
error: "" + e
});
globalState.globalReactionErrorHandlers.forEach(function(r) {
return r(e, t);
});
}
};
e.prototype.dispose = function() {
if (!this.isDisposed) {
this.isDisposed = !0;
if (!this._isRunning) {
startBatch();
clearObserving(this);
endBatch();
}
}
};
e.prototype.getDisposer = function() {
var e = this.dispose.bind(this);
e[$mobx] = this;
return e;
};
e.prototype.toString = function() {
return "Reaction[" + this.name + "]";
};
e.prototype.trace = function(e) {
void 0 === e && (e = !1);
trace(this, e);
};
return e;
}();

function onReactionError(e) {
globalState.globalReactionErrorHandlers.push(e);
return function() {
var t = globalState.globalReactionErrorHandlers.indexOf(e);
t >= 0 && globalState.globalReactionErrorHandlers.splice(t, 1);
};
}

var MAX_REACTION_ITERATIONS = 100, reactionScheduler = function(e) {
return e();
};

function runReactions() {
globalState.inBatch > 0 || globalState.isRunningReactions || reactionScheduler(runReactionsHelper);
}

function runReactionsHelper() {
globalState.isRunningReactions = !0;
for (var e = globalState.pendingReactions, t = 0; e.length > 0; ) {
if (++t === MAX_REACTION_ITERATIONS) {
console.error("Reaction doesn't converge to a stable state after " + MAX_REACTION_ITERATIONS + " iterations. Probably there is a cycle in the reactive function: " + e[0]);
e.splice(0);
}
for (var r = e.splice(0), n = 0, a = r.length; n < a; n++) r[n].runReaction();
}
globalState.isRunningReactions = !1;
}

var isReaction = createInstanceofPredicate("Reaction", Reaction);

function setReactionScheduler(e) {
var t = reactionScheduler;
reactionScheduler = function(r) {
return e(function() {
return t(r);
});
};
}

function isSpyEnabled() {
return !!globalState.spyListeners.length;
}

function spyReport(e) {
if (globalState.spyListeners.length) for (var t = globalState.spyListeners, r = 0, n = t.length; r < n; r++) t[r](e);
}

function spyReportStart(e) {
spyReport(__assign(__assign({}, e), {
spyReportStart: !0
}));
}

var END_EVENT = {
spyReportEnd: !0
};

function spyReportEnd(e) {
spyReport(e ? __assign(__assign({}, e), {
spyReportEnd: !0
}) : END_EVENT);
}

function spy(e) {
globalState.spyListeners.push(e);
return once(function() {
globalState.spyListeners = globalState.spyListeners.filter(function(t) {
return t !== e;
});
});
}

function dontReassignFields() {
fail("@action fields are not reassignable");
}

function namedActionDecorator(e) {
return function(t, r, n) {
if (n) {
if (void 0 !== n.get) return fail("@action cannot be used with getters");
if (n.value) return {
value: createAction(e, n.value),
enumerable: !1,
configurable: !0,
writable: !0
};
var a = n.initializer;
return {
enumerable: !1,
configurable: !0,
writable: !0,
initializer: function() {
return createAction(e, a.call(this));
}
};
}
return actionFieldDecorator(e).apply(this, arguments);
};
}

function actionFieldDecorator(e) {
return function(t, r) {
Object.defineProperty(t, r, {
configurable: !0,
enumerable: !1,
get: function() {},
set: function(t) {
addHiddenProp(this, r, action(e, t));
}
});
};
}

function boundActionDecorator(e, t, r, n) {
if (!0 === n) {
defineBoundAction(e, t, r.value);
return null;
}
return r ? {
configurable: !0,
enumerable: !1,
get: function() {
defineBoundAction(this, t, r.value || r.initializer.call(this));
return this[t];
},
set: dontReassignFields
} : {
enumerable: !1,
configurable: !0,
set: function(e) {
defineBoundAction(this, t, e);
},
get: function() {}
};
}

var action = function(e, t, r, n) {
if (1 === arguments.length && "function" == typeof e) return createAction(e.name || "<unnamed action>", e);
if (2 === arguments.length && "function" == typeof t) return createAction(e, t);
if (1 === arguments.length && "string" == typeof e) return namedActionDecorator(e);
if (!0 !== n) return namedActionDecorator(t).apply(null, arguments);
addHiddenProp(e, t, createAction(e.name || t, r.value, this));
};

action.bound = boundActionDecorator;

function runInAction(e, t) {
var r = "string" == typeof e ? e : e.name || "<unnamed action>", n = "function" == typeof e ? e : t;
invariant("function" == typeof n && 0 === n.length, "`runInAction` expects a function without arguments");
"string" == typeof r && r || fail("actions should have valid names, got: '" + r + "'");
return executeAction(r, n, this, void 0);
}

function isAction(e) {
return "function" == typeof e && !0 === e.isMobxAction;
}

function defineBoundAction(e, t, r) {
addHiddenProp(e, t, createAction(t, r.bind(e)));
}

function autorun(e, t) {
void 0 === t && (t = EMPTY_OBJECT);
invariant("function" == typeof e, "Autorun expects a function as first argument");
invariant(!1 === isAction(e), "Autorun does not accept actions since actions are untrackable");
var r, n = t && t.name || e.name || "Autorun@" + getNextId();
if (t.scheduler || t.delay) {
var a = createSchedulerFromOptions(t), o = !1;
r = new Reaction(n, function() {
if (!o) {
o = !0;
a(function() {
o = !1;
r.isDisposed || r.track(i);
});
}
}, t.onError, t.requiresObservable);
} else r = new Reaction(n, function() {
this.track(i);
}, t.onError, t.requiresObservable);
function i() {
e(r);
}
r.schedule();
return r.getDisposer();
}

var run = function(e) {
return e();
};

function createSchedulerFromOptions(e) {
return e.scheduler ? e.scheduler : e.delay ? function(t) {
return setTimeout(t, e.delay);
} : run;
}

function reaction(e, t, r) {
void 0 === r && (r = EMPTY_OBJECT);
invariant("function" == typeof e, "First argument to reaction should be a function");
invariant("object" == typeof r, "Third argument of reactions should be an object");
var n, a = r.name || "Reaction@" + getNextId(), o = action(a, r.onError ? wrapErrorHandler(r.onError, t) : t), i = !r.scheduler && !r.delay, s = createSchedulerFromOptions(r), c = !0, l = !1, u = r.compareStructural ? comparer.structural : r.equals || comparer.default, p = new Reaction(a, function() {
if (c || i) d(); else if (!l) {
l = !0;
s(d);
}
}, r.onError, r.requiresObservable);
function d() {
l = !1;
if (!p.isDisposed) {
var t = !1;
p.track(function() {
var r = e(p);
t = c || !u(n, r);
n = r;
});
c && r.fireImmediately && o(n, p);
c || !0 !== t || o(n, p);
c && (c = !1);
}
}
p.schedule();
return p.getDisposer();
}

function wrapErrorHandler(e, t) {
return function() {
try {
return t.apply(this, arguments);
} catch (t) {
e.call(this, t);
}
};
}

function onBecomeObserved(e, t, r) {
return interceptHook("onBecomeObserved", e, t, r);
}

function onBecomeUnobserved(e, t, r) {
return interceptHook("onBecomeUnobserved", e, t, r);
}

function interceptHook(e, t, r, n) {
var a = "function" == typeof n ? getAtom(t, r) : getAtom(t), o = "function" == typeof n ? n : r, i = e + "Listeners";
a[i] ? a[i].add(o) : a[i] = new Set([ o ]);
return "function" != typeof a[e] ? fail("Not an atom that can be (un)observed") : function() {
var e = a[i];
if (e) {
e.delete(o);
0 === e.size && delete a[i];
}
};
}

function configure(e) {
var t = e.enforceActions, r = e.computedRequiresReaction, n = e.computedConfigurable, a = e.disableErrorBoundaries, o = e.reactionScheduler, i = e.reactionRequiresObservable, s = e.observableRequiresReaction;
!0 === e.isolateGlobalState && isolateGlobalState();
if (void 0 !== t) {
"boolean" != typeof t && "strict" !== t || deprecated("Deprecated value for 'enforceActions', use 'false' => '\"never\"', 'true' => '\"observed\"', '\"strict\"' => \"'always'\" instead");
var c = void 0;
switch (t) {
case !0:
case "observed":
c = !0;
break;

case !1:
case "never":
c = !1;
break;

case "strict":
case "always":
c = "strict";
break;

default:
fail("Invalid value for 'enforceActions': '" + t + "', expected 'never', 'always' or 'observed'");
}
globalState.enforceActions = c;
globalState.allowStateChanges = !0 !== c && "strict" !== c;
}
void 0 !== r && (globalState.computedRequiresReaction = !!r);
void 0 !== i && (globalState.reactionRequiresObservable = !!i);
if (void 0 !== s) {
globalState.observableRequiresReaction = !!s;
globalState.allowStateReads = !globalState.observableRequiresReaction;
}
void 0 !== n && (globalState.computedConfigurable = !!n);
if (void 0 !== a) {
!0 === a && console.warn("WARNING: Debug feature only. MobX will NOT recover from errors when `disableErrorBoundaries` is enabled.");
globalState.disableErrorBoundaries = !!a;
}
o && setReactionScheduler(o);
}

function decorate(e, t) {
invariant(isPlainObject(t), "Decorators should be a key value map");
var r = "function" == typeof e ? e.prototype : e, n = function(e) {
var n = t[e];
Array.isArray(n) || (n = [ n ]);
invariant(n.every(function(e) {
return "function" == typeof e;
}), "Decorate: expected a decorator function or array of decorator functions for '" + e + "'");
var a = Object.getOwnPropertyDescriptor(r, e), o = n.reduce(function(t, n) {
return n(r, e, t);
}, a);
o && Object.defineProperty(r, e, o);
};
for (var a in t) n(a);
return e;
}

function extendObservable(e, t, r, n) {
invariant(arguments.length >= 2 && arguments.length <= 4, "'extendObservable' expected 2-4 arguments");
invariant("object" == typeof e, "'extendObservable' expects an object as first argument");
invariant(!isObservableMap(e), "'extendObservable' should not be used on maps, use map.merge instead");
var a = getDefaultDecoratorFromObjectOptions(n = asCreateObservableOptions(n));
initializeInstance(e);
asObservableObject(e, n.name, a.enhancer);
t && extendObservableObjectWithProperties(e, t, r, a);
return e;
}

function getDefaultDecoratorFromObjectOptions(e) {
return e.defaultDecorator || (!1 === e.deep ? refDecorator : deepDecorator);
}

function extendObservableObjectWithProperties(e, t, r, n) {
var a, o, i, s;
invariant(!isObservable(t), "Extending an object with another observable (object) is not supported. Please construct an explicit propertymap, using `toJS` if need. See issue #540");
if (r) {
var c = getPlainObjectKeys(r);
try {
for (var l = __values(c), u = l.next(); !u.done; u = l.next()) (b = u.value) in t || fail("Trying to declare a decorator for unspecified property '" + stringifyKey(b) + "'");
} catch (e) {
a = {
error: e
};
} finally {
try {
u && !u.done && (o = l.return) && o.call(l);
} finally {
if (a) throw a.error;
}
}
}
startBatch();
try {
c = getPlainObjectKeys(t);
try {
for (var p = __values(c), d = p.next(); !d.done; d = p.next()) {
var b = d.value, f = Object.getOwnPropertyDescriptor(t, b);
isPlainObject(t) || fail("'extendObservabe' only accepts plain objects as second argument");
isComputed(f.value) && fail("Passing a 'computed' as initial property value is no longer supported by extendObservable. Use a getter or decorator instead");
var h = r && b in r ? r[b] : f.get ? computedDecorator : n;
"function" != typeof h && fail("Not a valid decorator for '" + stringifyKey(b) + "', got: " + h);
var v = h(e, b, f, !0);
v && Object.defineProperty(e, b, v);
}
} catch (e) {
i = {
error: e
};
} finally {
try {
d && !d.done && (s = p.return) && s.call(p);
} finally {
if (i) throw i.error;
}
}
} finally {
endBatch();
}
}

function getDependencyTree(e, t) {
return nodeToDependencyTree(getAtom(e, t));
}

function nodeToDependencyTree(e) {
var t = {
name: e.name
};
e.observing && e.observing.length > 0 && (t.dependencies = unique(e.observing).map(nodeToDependencyTree));
return t;
}

function getObserverTree(e, t) {
return nodeToObserverTree(getAtom(e, t));
}

function nodeToObserverTree(e) {
var t = {
name: e.name
};
hasObservers(e) && (t.observers = Array.from(getObservers(e)).map(nodeToObserverTree));
return t;
}

var generatorId = 0;

function FlowCancellationError() {
this.message = "FLOW_CANCELLED";
}

FlowCancellationError.prototype = Object.create(Error.prototype);

function isFlowCancellationError(e) {
return e instanceof FlowCancellationError;
}

function flow(e) {
1 !== arguments.length && fail("Flow expects 1 argument and cannot be used as decorator");
var t = e.name || "<unnamed flow>";
return function() {
var r, n = this, a = arguments, o = ++generatorId, i = action(t + " - runid: " + o + " - init", e).apply(n, a), s = void 0, c = new Promise(function(e, n) {
var a = 0;
r = n;
function c(e) {
s = void 0;
var r;
try {
r = action(t + " - runid: " + o + " - yield " + a++, i.next).call(i, e);
} catch (e) {
return n(e);
}
u(r);
}
function l(e) {
s = void 0;
var r;
try {
r = action(t + " - runid: " + o + " - yield " + a++, i.throw).call(i, e);
} catch (e) {
return n(e);
}
u(r);
}
function u(t) {
if (!t || "function" != typeof t.then) return t.done ? e(t.value) : (s = Promise.resolve(t.value)).then(c, l);
t.then(u, n);
}
c(void 0);
});
c.cancel = action(t + " - runid: " + o + " - cancel", function() {
try {
s && cancelPromise(s);
var e = i.return(void 0), t = Promise.resolve(e.value);
t.then(noop, noop);
cancelPromise(t);
r(new FlowCancellationError());
} catch (e) {
r(e);
}
});
return c;
};
}

function cancelPromise(e) {
"function" == typeof e.cancel && e.cancel();
}

function interceptReads(e, t, r) {
var n;
if (isObservableMap(e) || isObservableArray(e) || isObservableValue(e)) n = getAdministration(e); else {
if (!isObservableObject(e)) return fail("Expected observable map, object or array as first array");
if ("string" != typeof t) return fail("InterceptReads can only be used with a specific property, not with an object in general");
n = getAdministration(e, t);
}
if (void 0 !== n.dehancer) return fail("An intercept reader was already established");
n.dehancer = "function" == typeof t ? t : r;
return function() {
n.dehancer = void 0;
};
}

function intercept(e, t, r) {
return "function" == typeof r ? interceptProperty(e, t, r) : interceptInterceptable(e, t);
}

function interceptInterceptable(e, t) {
return getAdministration(e).intercept(t);
}

function interceptProperty(e, t, r) {
return getAdministration(e, t).intercept(r);
}

function _isComputed(e, t) {
if (null == e) return !1;
if (void 0 !== t) {
if (!1 === isObservableObject(e)) return !1;
if (!e[$mobx].values.has(t)) return !1;
var r = getAtom(e, t);
return isComputedValue(r);
}
return isComputedValue(e);
}

function isComputed(e) {
return arguments.length > 1 ? fail("isComputed expects only 1 argument. Use isObservableProp to inspect the observability of a property") : _isComputed(e);
}

function isComputedProp(e, t) {
return "string" != typeof t ? fail("isComputed expected a property name as second argument") : _isComputed(e, t);
}

function _isObservable(e, t) {
return null != e && (void 0 !== t ? isObservableMap(e) || isObservableArray(e) ? fail("isObservable(object, propertyName) is not supported for arrays and maps. Use map.has or array.length instead.") : !!isObservableObject(e) && e[$mobx].values.has(t) : isObservableObject(e) || !!e[$mobx] || isAtom(e) || isReaction(e) || isComputedValue(e));
}

function isObservable(e) {
1 !== arguments.length && fail("isObservable expects only 1 argument. Use isObservableProp to inspect the observability of a property");
return _isObservable(e);
}

function isObservableProp(e, t) {
return "string" != typeof t ? fail("expected a property name as second argument") : _isObservable(e, t);
}

function keys(e) {
return isObservableObject(e) ? e[$mobx].getKeys() : isObservableMap(e) ? Array.from(e.keys()) : isObservableSet(e) ? Array.from(e.keys()) : isObservableArray(e) ? e.map(function(e, t) {
return t;
}) : fail("'keys()' can only be used on observable objects, arrays, sets and maps");
}

function values(e) {
return isObservableObject(e) ? keys(e).map(function(t) {
return e[t];
}) : isObservableMap(e) ? keys(e).map(function(t) {
return e.get(t);
}) : isObservableSet(e) ? Array.from(e.values()) : isObservableArray(e) ? e.slice() : fail("'values()' can only be used on observable objects, arrays, sets and maps");
}

function entries(e) {
return isObservableObject(e) ? keys(e).map(function(t) {
return [ t, e[t] ];
}) : isObservableMap(e) ? keys(e).map(function(t) {
return [ t, e.get(t) ];
}) : isObservableSet(e) ? Array.from(e.entries()) : isObservableArray(e) ? e.map(function(e, t) {
return [ t, e ];
}) : fail("'entries()' can only be used on observable objects, arrays and maps");
}

function set(e, t, r) {
if (2 !== arguments.length || isObservableSet(e)) if (isObservableObject(e)) {
var n = e[$mobx];
n.values.get(t) ? n.write(t, r) : n.addObservableProp(t, r, n.defaultEnhancer);
} else if (isObservableMap(e)) e.set(t, r); else if (isObservableSet(e)) e.add(t); else {
if (!isObservableArray(e)) return fail("'set()' can only be used on observable objects, arrays and maps");
"number" != typeof t && (t = parseInt(t, 10));
invariant(t >= 0, "Not a valid index: '" + t + "'");
startBatch();
t >= e.length && (e.length = t + 1);
e[t] = r;
endBatch();
} else {
startBatch();
var a = t;
try {
for (var o in a) set(e, o, a[o]);
} finally {
endBatch();
}
}
}

function remove(e, t) {
if (isObservableObject(e)) e[$mobx].remove(t); else if (isObservableMap(e)) e.delete(t); else if (isObservableSet(e)) e.delete(t); else {
if (!isObservableArray(e)) return fail("'remove()' can only be used on observable objects, arrays and maps");
"number" != typeof t && (t = parseInt(t, 10));
invariant(t >= 0, "Not a valid index: '" + t + "'");
e.splice(t, 1);
}
}

function has(e, t) {
return isObservableObject(e) ? getAdministration(e).has(t) : isObservableMap(e) ? e.has(t) : isObservableSet(e) ? e.has(t) : isObservableArray(e) ? t >= 0 && t < e.length : fail("'has()' can only be used on observable objects, arrays and maps");
}

function get(e, t) {
if (has(e, t)) return isObservableObject(e) ? e[t] : isObservableMap(e) ? e.get(t) : isObservableArray(e) ? e[t] : fail("'get()' can only be used on observable objects, arrays and maps");
}

function observe(e, t, r, n) {
return "function" == typeof r ? observeObservableProperty(e, t, r, n) : observeObservable(e, t, r);
}

function observeObservable(e, t, r) {
return getAdministration(e).observe(t, r);
}

function observeObservableProperty(e, t, r, n) {
return getAdministration(e, t).observe(r, n);
}

var defaultOptions = {
detectCycles: !0,
exportMapsAsObjects: !0,
recurseEverything: !1
};

function cache(e, t, r, n) {
n.detectCycles && e.set(t, r);
return r;
}

function toJSHelper(e, t, r) {
if (!t.recurseEverything && !isObservable(e)) return e;
if ("object" != typeof e) return e;
if (null === e) return null;
if (e instanceof Date) return e;
if (isObservableValue(e)) return toJSHelper(e.get(), t, r);
isObservable(e) && keys(e);
if (!0 === t.detectCycles && null !== e && r.has(e)) return r.get(e);
if (isObservableArray(e) || Array.isArray(e)) {
var n = cache(r, e, [], t), a = e.map(function(e) {
return toJSHelper(e, t, r);
});
n.length = a.length;
for (var o = 0, i = a.length; o < i; o++) n[o] = a[o];
return n;
}
if (isObservableSet(e) || Object.getPrototypeOf(e) === Set.prototype) {
if (!1 === t.exportMapsAsObjects) {
var s = cache(r, e, new Set(), t);
e.forEach(function(e) {
s.add(toJSHelper(e, t, r));
});
return s;
}
var c = cache(r, e, [], t);
e.forEach(function(e) {
c.push(toJSHelper(e, t, r));
});
return c;
}
if (isObservableMap(e) || Object.getPrototypeOf(e) === Map.prototype) {
if (!1 === t.exportMapsAsObjects) {
var l = cache(r, e, new Map(), t);
e.forEach(function(e, n) {
l.set(n, toJSHelper(e, t, r));
});
return l;
}
var u = cache(r, e, {}, t);
e.forEach(function(e, n) {
u[n] = toJSHelper(e, t, r);
});
return u;
}
var p = cache(r, e, {}, t);
getPlainObjectKeys(e).forEach(function(n) {
p[n] = toJSHelper(e[n], t, r);
});
return p;
}

function toJS(e, t) {
"boolean" == typeof t && (t = {
detectCycles: t
});
t || (t = defaultOptions);
t.detectCycles = void 0 === t.detectCycles ? !0 === t.recurseEverything : !0 === t.detectCycles;
var r;
t.detectCycles && (r = new Map());
return toJSHelper(e, t, r);
}

function trace() {
for (var e = [], t = 0; t < arguments.length; t++) e[t] = arguments[t];
var r = !1;
"boolean" == typeof e[e.length - 1] && (r = e.pop());
var n = getAtomFromArgs(e);
if (!n) return fail("'trace(break?)' can only be used inside a tracked computed value or a Reaction. Consider passing in the computed value or reaction explicitly");
n.isTracing === TraceMode.NONE && console.log("[mobx.trace] '" + n.name + "' tracing enabled");
n.isTracing = r ? TraceMode.BREAK : TraceMode.LOG;
}

function getAtomFromArgs(e) {
switch (e.length) {
case 0:
return globalState.trackingDerivation;

case 1:
return getAtom(e[0]);

case 2:
return getAtom(e[0], e[1]);
}
}

function transaction(e, t) {
void 0 === t && (t = void 0);
startBatch();
try {
return e.apply(t);
} finally {
endBatch();
}
}

function when(e, t, r) {
return 1 === arguments.length || t && "object" == typeof t ? whenPromise(e, t) : _when(e, t, r || {});
}

function _when(e, t, r) {
var n;
"number" == typeof r.timeout && (n = setTimeout(function() {
if (!o[$mobx].isDisposed) {
o();
var e = new Error("WHEN_TIMEOUT");
if (!r.onError) throw e;
r.onError(e);
}
}, r.timeout));
r.name = r.name || "When@" + getNextId();
var a = createAction(r.name + "-effect", t), o = autorun(function(t) {
if (e()) {
t.dispose();
n && clearTimeout(n);
a();
}
}, r);
return o;
}

function whenPromise(e, t) {
if (t && t.onError) return fail("the options 'onError' and 'promise' cannot be combined");
var r, n = new Promise(function(n, a) {
var o = _when(e, n, __assign(__assign({}, t), {
onError: a
}));
r = function() {
o();
a("WHEN_CANCELLED");
};
});
n.cancel = r;
return n;
}

function getAdm(e) {
return e[$mobx];
}

function isPropertyKey(e) {
return "string" == typeof e || "number" == typeof e || "symbol" == typeof e;
}

var objectProxyTraps = {
has: function(e, t) {
if (t === $mobx || "constructor" === t || t === mobxDidRunLazyInitializersSymbol) return !0;
var r = getAdm(e);
return isPropertyKey(t) ? r.has(t) : t in e;
},
get: function(e, t) {
if (t === $mobx || "constructor" === t || t === mobxDidRunLazyInitializersSymbol) return e[t];
var r = getAdm(e), n = r.values.get(t);
if (n instanceof Atom) {
var a = n.get();
void 0 === a && r.has(t);
return a;
}
isPropertyKey(t) && r.has(t);
return e[t];
},
set: function(e, t, r) {
if (!isPropertyKey(t)) return !1;
set(e, t, r);
return !0;
},
deleteProperty: function(e, t) {
if (!isPropertyKey(t)) return !1;
getAdm(e).remove(t);
return !0;
},
ownKeys: function(e) {
getAdm(e).keysAtom.reportObserved();
return Reflect.ownKeys(e);
},
preventExtensions: function() {
fail("Dynamic observable objects cannot be frozen");
return !1;
}
};

function createDynamicObservableObject(e) {
var t = new Proxy(e, objectProxyTraps);
e[$mobx].proxy = t;
return t;
}

function hasInterceptors(e) {
return void 0 !== e.interceptors && e.interceptors.length > 0;
}

function registerInterceptor(e, t) {
var r = e.interceptors || (e.interceptors = []);
r.push(t);
return once(function() {
var e = r.indexOf(t);
-1 !== e && r.splice(e, 1);
});
}

function interceptChange(e, t) {
var r = untrackedStart();
try {
for (var n = __spread(e.interceptors || []), a = 0, o = n.length; a < o; a++) {
invariant(!(t = n[a](t)) || t.type, "Intercept handlers should return nothing or a change object");
if (!t) break;
}
return t;
} finally {
untrackedEnd(r);
}
}

function hasListeners(e) {
return void 0 !== e.changeListeners && e.changeListeners.length > 0;
}

function registerListener(e, t) {
var r = e.changeListeners || (e.changeListeners = []);
r.push(t);
return once(function() {
var e = r.indexOf(t);
-1 !== e && r.splice(e, 1);
});
}

function notifyListeners(e, t) {
var r = untrackedStart(), n = e.changeListeners;
if (n) {
for (var a = 0, o = (n = n.slice()).length; a < o; a++) n[a](t);
untrackedEnd(r);
}
}

var MAX_SPLICE_SIZE = 1e4, arrayTraps = {
get: function(e, t) {
return t === $mobx ? e[$mobx] : "length" === t ? e[$mobx].getArrayLength() : "number" == typeof t ? arrayExtensions.get.call(e, t) : "string" != typeof t || isNaN(t) ? arrayExtensions.hasOwnProperty(t) ? arrayExtensions[t] : e[t] : arrayExtensions.get.call(e, parseInt(t));
},
set: function(e, t, r) {
"length" === t && e[$mobx].setArrayLength(r);
"number" == typeof t && arrayExtensions.set.call(e, t, r);
"symbol" == typeof t || isNaN(t) ? e[t] = r : arrayExtensions.set.call(e, parseInt(t), r);
return !0;
},
preventExtensions: function() {
fail("Observable arrays cannot be frozen");
return !1;
}
};

function createObservableArray(e, t, r, n) {
void 0 === r && (r = "ObservableArray@" + getNextId());
void 0 === n && (n = !1);
var a = new ObservableArrayAdministration(r, t, n);
addHiddenFinalProp(a.values, $mobx, a);
var o = new Proxy(a.values, arrayTraps);
a.proxy = o;
if (e && e.length) {
var i = allowStateChangesStart(!0);
a.spliceWithArray(0, 0, e);
allowStateChangesEnd(i);
}
return o;
}

var ObservableArrayAdministration = function() {
function e(e, t, r) {
this.owned = r;
this.values = [];
this.proxy = void 0;
this.lastKnownLength = 0;
this.atom = new Atom(e || "ObservableArray@" + getNextId());
this.enhancer = function(r, n) {
return t(r, n, e + "[..]");
};
}
e.prototype.dehanceValue = function(e) {
return void 0 !== this.dehancer ? this.dehancer(e) : e;
};
e.prototype.dehanceValues = function(e) {
return void 0 !== this.dehancer && e.length > 0 ? e.map(this.dehancer) : e;
};
e.prototype.intercept = function(e) {
return registerInterceptor(this, e);
};
e.prototype.observe = function(e, t) {
void 0 === t && (t = !1);
t && e({
object: this.proxy,
type: "splice",
index: 0,
added: this.values.slice(),
addedCount: this.values.length,
removed: [],
removedCount: 0
});
return registerListener(this, e);
};
e.prototype.getArrayLength = function() {
this.atom.reportObserved();
return this.values.length;
};
e.prototype.setArrayLength = function(e) {
if ("number" != typeof e || e < 0) throw new Error("[mobx.array] Out of range: " + e);
var t = this.values.length;
if (e !== t) if (e > t) {
for (var r = new Array(e - t), n = 0; n < e - t; n++) r[n] = void 0;
this.spliceWithArray(t, 0, r);
} else this.spliceWithArray(e, t - e);
};
e.prototype.updateArrayLength = function(e, t) {
if (e !== this.lastKnownLength) throw new Error("[mobx] Modification exception: the internal structure of an observable array was changed.");
this.lastKnownLength += t;
};
e.prototype.spliceWithArray = function(e, t, r) {
var n = this;
checkIfStateModificationsAreAllowed(this.atom);
var a = this.values.length;
void 0 === e ? e = 0 : e > a ? e = a : e < 0 && (e = Math.max(0, a + e));
t = 1 === arguments.length ? a - e : null == t ? 0 : Math.max(0, Math.min(t, a - e));
void 0 === r && (r = EMPTY_ARRAY);
if (hasInterceptors(this)) {
var o = interceptChange(this, {
object: this.proxy,
type: "splice",
index: e,
removedCount: t,
added: r
});
if (!o) return EMPTY_ARRAY;
t = o.removedCount;
r = o.added;
}
var i = (r = 0 === r.length ? r : r.map(function(e) {
return n.enhancer(e, void 0);
})).length - t;
this.updateArrayLength(a, i);
var s = this.spliceItemsIntoValues(e, t, r);
0 === t && 0 === r.length || this.notifyArraySplice(e, r, s);
return this.dehanceValues(s);
};
e.prototype.spliceItemsIntoValues = function(e, t, r) {
var n;
if (r.length < MAX_SPLICE_SIZE) return (n = this.values).splice.apply(n, __spread([ e, t ], r));
var a = this.values.slice(e, e + t);
this.values = this.values.slice(0, e).concat(r, this.values.slice(e + t));
return a;
};
e.prototype.notifyArrayChildUpdate = function(e, t, r) {
var n = !this.owned && isSpyEnabled(), a = hasListeners(this), o = a || n ? {
object: this.proxy,
type: "update",
index: e,
newValue: t,
oldValue: r
} : null;
n && spyReportStart(__assign(__assign({}, o), {
name: this.atom.name
}));
this.atom.reportChanged();
a && notifyListeners(this, o);
n && spyReportEnd();
};
e.prototype.notifyArraySplice = function(e, t, r) {
var n = !this.owned && isSpyEnabled(), a = hasListeners(this), o = a || n ? {
object: this.proxy,
type: "splice",
index: e,
removed: r,
added: t,
removedCount: r.length,
addedCount: t.length
} : null;
n && spyReportStart(__assign(__assign({}, o), {
name: this.atom.name
}));
this.atom.reportChanged();
a && notifyListeners(this, o);
n && spyReportEnd();
};
return e;
}(), arrayExtensions = {
intercept: function(e) {
return this[$mobx].intercept(e);
},
observe: function(e, t) {
void 0 === t && (t = !1);
return this[$mobx].observe(e, t);
},
clear: function() {
return this.splice(0);
},
replace: function(e) {
var t = this[$mobx];
return t.spliceWithArray(0, t.values.length, e);
},
toJS: function() {
return this.slice();
},
toJSON: function() {
return this.toJS();
},
splice: function(e, t) {
for (var r = [], n = 2; n < arguments.length; n++) r[n - 2] = arguments[n];
var a = this[$mobx];
switch (arguments.length) {
case 0:
return [];

case 1:
return a.spliceWithArray(e);

case 2:
return a.spliceWithArray(e, t);
}
return a.spliceWithArray(e, t, r);
},
spliceWithArray: function(e, t, r) {
return this[$mobx].spliceWithArray(e, t, r);
},
push: function() {
for (var e = [], t = 0; t < arguments.length; t++) e[t] = arguments[t];
var r = this[$mobx];
r.spliceWithArray(r.values.length, 0, e);
return r.values.length;
},
pop: function() {
return this.splice(Math.max(this[$mobx].values.length - 1, 0), 1)[0];
},
shift: function() {
return this.splice(0, 1)[0];
},
unshift: function() {
for (var e = [], t = 0; t < arguments.length; t++) e[t] = arguments[t];
var r = this[$mobx];
r.spliceWithArray(0, 0, e);
return r.values.length;
},
reverse: function() {
console.warn("[mobx] `observableArray.reverse()` will not update the array in place. Use `observableArray.slice().reverse()` to suppress this warning and perform the operation on a copy, or `observableArray.replace(observableArray.slice().reverse())` to reverse & update in place");
var e = this.slice();
return e.reverse.apply(e, arguments);
},
sort: function() {
console.warn("[mobx] `observableArray.sort()` will not update the array in place. Use `observableArray.slice().sort()` to suppress this warning and perform the operation on a copy, or `observableArray.replace(observableArray.slice().sort())` to sort & update in place");
var e = this.slice();
return e.sort.apply(e, arguments);
},
remove: function(e) {
var t = this[$mobx], r = t.dehanceValues(t.values).indexOf(e);
if (r > -1) {
this.splice(r, 1);
return !0;
}
return !1;
},
get: function(e) {
var t = this[$mobx];
if (t) {
if (e < t.values.length) {
t.atom.reportObserved();
return t.dehanceValue(t.values[e]);
}
console.warn("[mobx.array] Attempt to read an array index (" + e + ") that is out of bounds (" + t.values.length + "). Please check length first. Out of bound indices will not be tracked by MobX");
}
},
set: function(e, t) {
var r = this[$mobx], n = r.values;
if (e < n.length) {
checkIfStateModificationsAreAllowed(r.atom);
var a = n[e];
if (hasInterceptors(r)) {
var o = interceptChange(r, {
type: "update",
object: r.proxy,
index: e,
newValue: t
});
if (!o) return;
t = o.newValue;
}
if ((t = r.enhancer(t, a)) !== a) {
n[e] = t;
r.notifyArrayChildUpdate(e, t, a);
}
} else {
if (e !== n.length) throw new Error("[mobx.array] Index out of bounds, " + e + " is larger than " + n.length);
r.spliceWithArray(e, 0, [ t ]);
}
}
};

[ "concat", "every", "filter", "forEach", "indexOf", "join", "lastIndexOf", "map", "reduce", "reduceRight", "slice", "some", "toString", "toLocaleString" ].forEach(function(e) {
arrayExtensions[e] = function() {
var t = this[$mobx];
t.atom.reportObserved();
var r = t.dehanceValues(t.values);
return r[e].apply(r, arguments);
};
});

var _a, isObservableArrayAdministration = createInstanceofPredicate("ObservableArrayAdministration", ObservableArrayAdministration);

function isObservableArray(e) {
return isObject(e) && isObservableArrayAdministration(e[$mobx]);
}

var _a$1, ObservableMapMarker = {}, ObservableMap = function() {
function e(e, t, r) {
void 0 === t && (t = deepEnhancer);
void 0 === r && (r = "ObservableMap@" + getNextId());
this.enhancer = t;
this.name = r;
this[_a] = ObservableMapMarker;
this._keysAtom = createAtom(this.name + ".keys()");
this[Symbol.toStringTag] = "Map";
if ("function" != typeof Map) throw new Error("mobx.map requires Map polyfill for the current browser. Check babel-polyfill or core-js/es6/map.js");
this._data = new Map();
this._hasMap = new Map();
this.merge(e);
}
e.prototype._has = function(e) {
return this._data.has(e);
};
e.prototype.has = function(e) {
var t = this;
if (!globalState.trackingDerivation) return this._has(e);
var r = this._hasMap.get(e);
if (!r) {
var n = r = new ObservableValue(this._has(e), referenceEnhancer, this.name + "." + stringifyKey(e) + "?", !1);
this._hasMap.set(e, n);
onBecomeUnobserved(n, function() {
return t._hasMap.delete(e);
});
}
return r.get();
};
e.prototype.set = function(e, t) {
var r = this._has(e);
if (hasInterceptors(this)) {
var n = interceptChange(this, {
type: r ? "update" : "add",
object: this,
newValue: t,
name: e
});
if (!n) return this;
t = n.newValue;
}
r ? this._updateValue(e, t) : this._addValue(e, t);
return this;
};
e.prototype.delete = function(e) {
var t = this;
if (hasInterceptors(this) && !(a = interceptChange(this, {
type: "delete",
object: this,
name: e
}))) return !1;
if (this._has(e)) {
var r = isSpyEnabled(), n = hasListeners(this), a = n || r ? {
type: "delete",
object: this,
oldValue: this._data.get(e).value,
name: e
} : null;
r && spyReportStart(__assign(__assign({}, a), {
name: this.name,
key: e
}));
transaction(function() {
t._keysAtom.reportChanged();
t._updateHasMapEntry(e, !1);
t._data.get(e).setNewValue(void 0);
t._data.delete(e);
});
n && notifyListeners(this, a);
r && spyReportEnd();
return !0;
}
return !1;
};
e.prototype._updateHasMapEntry = function(e, t) {
var r = this._hasMap.get(e);
r && r.setNewValue(t);
};
e.prototype._updateValue = function(e, t) {
var r = this._data.get(e);
if ((t = r.prepareNewValue(t)) !== globalState.UNCHANGED) {
var n = isSpyEnabled(), a = hasListeners(this), o = a || n ? {
type: "update",
object: this,
oldValue: r.value,
name: e,
newValue: t
} : null;
n && spyReportStart(__assign(__assign({}, o), {
name: this.name,
key: e
}));
r.setNewValue(t);
a && notifyListeners(this, o);
n && spyReportEnd();
}
};
e.prototype._addValue = function(e, t) {
var r = this;
checkIfStateModificationsAreAllowed(this._keysAtom);
transaction(function() {
var n = new ObservableValue(t, r.enhancer, r.name + "." + stringifyKey(e), !1);
r._data.set(e, n);
t = n.value;
r._updateHasMapEntry(e, !0);
r._keysAtom.reportChanged();
});
var n = isSpyEnabled(), a = hasListeners(this), o = a || n ? {
type: "add",
object: this,
name: e,
newValue: t
} : null;
n && spyReportStart(__assign(__assign({}, o), {
name: this.name,
key: e
}));
a && notifyListeners(this, o);
n && spyReportEnd();
};
e.prototype.get = function(e) {
return this.has(e) ? this.dehanceValue(this._data.get(e).get()) : this.dehanceValue(void 0);
};
e.prototype.dehanceValue = function(e) {
return void 0 !== this.dehancer ? this.dehancer(e) : e;
};
e.prototype.keys = function() {
this._keysAtom.reportObserved();
return this._data.keys();
};
e.prototype.values = function() {
var e = this, t = 0, r = Array.from(this.keys());
return makeIterable({
next: function() {
return t < r.length ? {
value: e.get(r[t++]),
done: !1
} : {
done: !0
};
}
});
};
e.prototype.entries = function() {
var e = this, t = 0, r = Array.from(this.keys());
return makeIterable({
next: function() {
if (t < r.length) {
var n = r[t++];
return {
value: [ n, e.get(n) ],
done: !1
};
}
return {
done: !0
};
}
});
};
e.prototype[(_a = $mobx, Symbol.iterator)] = function() {
return this.entries();
};
e.prototype.forEach = function(e, t) {
var r, n;
try {
for (var a = __values(this), o = a.next(); !o.done; o = a.next()) {
var i = __read(o.value, 2), s = i[0], c = i[1];
e.call(t, c, s, this);
}
} catch (e) {
r = {
error: e
};
} finally {
try {
o && !o.done && (n = a.return) && n.call(a);
} finally {
if (r) throw r.error;
}
}
};
e.prototype.merge = function(e) {
var t = this;
isObservableMap(e) && (e = e.toJS());
transaction(function() {
if (isPlainObject(e)) getPlainObjectKeys(e).forEach(function(r) {
return t.set(r, e[r]);
}); else if (Array.isArray(e)) e.forEach(function(e) {
var r = __read(e, 2), n = r[0], a = r[1];
return t.set(n, a);
}); else if (isES6Map(e)) {
e.constructor !== Map && fail("Cannot initialize from classes that inherit from Map: " + e.constructor.name);
e.forEach(function(e, r) {
return t.set(r, e);
});
} else null != e && fail("Cannot initialize map from " + e);
});
return this;
};
e.prototype.clear = function() {
var e = this;
transaction(function() {
untracked(function() {
var t, r;
try {
for (var n = __values(e.keys()), a = n.next(); !a.done; a = n.next()) {
var o = a.value;
e.delete(o);
}
} catch (e) {
t = {
error: e
};
} finally {
try {
a && !a.done && (r = n.return) && r.call(n);
} finally {
if (t) throw t.error;
}
}
});
});
};
e.prototype.replace = function(e) {
var t = this;
transaction(function() {
var r = getMapLikeKeys(e);
Array.from(t.keys()).filter(function(e) {
return -1 === r.indexOf(e);
}).forEach(function(e) {
return t.delete(e);
});
t.merge(e);
});
return this;
};
Object.defineProperty(e.prototype, "size", {
get: function() {
this._keysAtom.reportObserved();
return this._data.size;
},
enumerable: !0,
configurable: !0
});
e.prototype.toPOJO = function() {
var e, t, r = {};
try {
for (var n = __values(this), a = n.next(); !a.done; a = n.next()) {
var o = __read(a.value, 2), i = o[0], s = o[1];
r["symbol" == typeof i ? i : stringifyKey(i)] = s;
}
} catch (t) {
e = {
error: t
};
} finally {
try {
a && !a.done && (t = n.return) && t.call(n);
} finally {
if (e) throw e.error;
}
}
return r;
};
e.prototype.toJS = function() {
return new Map(this);
};
e.prototype.toJSON = function() {
return this.toPOJO();
};
e.prototype.toString = function() {
var e = this;
return this.name + "[{ " + Array.from(this.keys()).map(function(t) {
return stringifyKey(t) + ": " + e.get(t);
}).join(", ") + " }]";
};
e.prototype.observe = function(e, t) {
invariant(!0 !== t, "`observe` doesn't support fireImmediately=true in combination with maps.");
return registerListener(this, e);
};
e.prototype.intercept = function(e) {
return registerInterceptor(this, e);
};
return e;
}(), isObservableMap = createInstanceofPredicate("ObservableMap", ObservableMap), ObservableSetMarker = {}, ObservableSet = function() {
function e(e, t, r) {
void 0 === t && (t = deepEnhancer);
void 0 === r && (r = "ObservableSet@" + getNextId());
this.name = r;
this[_a$1] = ObservableSetMarker;
this._data = new Set();
this._atom = createAtom(this.name);
this[Symbol.toStringTag] = "Set";
if ("function" != typeof Set) throw new Error("mobx.set requires Set polyfill for the current browser. Check babel-polyfill or core-js/es6/set.js");
this.enhancer = function(e, n) {
return t(e, n, r);
};
e && this.replace(e);
}
e.prototype.dehanceValue = function(e) {
return void 0 !== this.dehancer ? this.dehancer(e) : e;
};
e.prototype.clear = function() {
var e = this;
transaction(function() {
untracked(function() {
var t, r;
try {
for (var n = __values(e._data.values()), a = n.next(); !a.done; a = n.next()) {
var o = a.value;
e.delete(o);
}
} catch (e) {
t = {
error: e
};
} finally {
try {
a && !a.done && (r = n.return) && r.call(n);
} finally {
if (t) throw t.error;
}
}
});
});
};
e.prototype.forEach = function(e, t) {
var r, n;
try {
for (var a = __values(this), o = a.next(); !o.done; o = a.next()) {
var i = o.value;
e.call(t, i, i, this);
}
} catch (e) {
r = {
error: e
};
} finally {
try {
o && !o.done && (n = a.return) && n.call(a);
} finally {
if (r) throw r.error;
}
}
};
Object.defineProperty(e.prototype, "size", {
get: function() {
this._atom.reportObserved();
return this._data.size;
},
enumerable: !0,
configurable: !0
});
e.prototype.add = function(e) {
var t = this;
checkIfStateModificationsAreAllowed(this._atom);
if (hasInterceptors(this) && !(a = interceptChange(this, {
type: "add",
object: this,
newValue: e
}))) return this;
if (!this.has(e)) {
transaction(function() {
t._data.add(t.enhancer(e, void 0));
t._atom.reportChanged();
});
var r = isSpyEnabled(), n = hasListeners(this), a = n || r ? {
type: "add",
object: this,
newValue: e
} : null;
r && spyReportStart(a);
n && notifyListeners(this, a);
r && spyReportEnd();
}
return this;
};
e.prototype.delete = function(e) {
var t = this;
if (hasInterceptors(this) && !(a = interceptChange(this, {
type: "delete",
object: this,
oldValue: e
}))) return !1;
if (this.has(e)) {
var r = isSpyEnabled(), n = hasListeners(this), a = n || r ? {
type: "delete",
object: this,
oldValue: e
} : null;
r && spyReportStart(__assign(__assign({}, a), {
name: this.name
}));
transaction(function() {
t._atom.reportChanged();
t._data.delete(e);
});
n && notifyListeners(this, a);
r && spyReportEnd();
return !0;
}
return !1;
};
e.prototype.has = function(e) {
this._atom.reportObserved();
return this._data.has(this.dehanceValue(e));
};
e.prototype.entries = function() {
var e = 0, t = Array.from(this.keys()), r = Array.from(this.values());
return makeIterable({
next: function() {
var n = e;
e += 1;
return n < r.length ? {
value: [ t[n], r[n] ],
done: !1
} : {
done: !0
};
}
});
};
e.prototype.keys = function() {
return this.values();
};
e.prototype.values = function() {
this._atom.reportObserved();
var e = this, t = 0, r = Array.from(this._data.values());
return makeIterable({
next: function() {
return t < r.length ? {
value: e.dehanceValue(r[t++]),
done: !1
} : {
done: !0
};
}
});
};
e.prototype.replace = function(e) {
var t = this;
isObservableSet(e) && (e = e.toJS());
transaction(function() {
if (Array.isArray(e)) {
t.clear();
e.forEach(function(e) {
return t.add(e);
});
} else if (isES6Set(e)) {
t.clear();
e.forEach(function(e) {
return t.add(e);
});
} else null != e && fail("Cannot initialize set from " + e);
});
return this;
};
e.prototype.observe = function(e, t) {
invariant(!0 !== t, "`observe` doesn't support fireImmediately=true in combination with sets.");
return registerListener(this, e);
};
e.prototype.intercept = function(e) {
return registerInterceptor(this, e);
};
e.prototype.toJS = function() {
return new Set(this);
};
e.prototype.toString = function() {
return this.name + "[ " + Array.from(this).join(", ") + " ]";
};
e.prototype[(_a$1 = $mobx, Symbol.iterator)] = function() {
return this.values();
};
return e;
}(), isObservableSet = createInstanceofPredicate("ObservableSet", ObservableSet), ObservableObjectAdministration = function() {
function e(e, t, r, n) {
void 0 === t && (t = new Map());
this.target = e;
this.values = t;
this.name = r;
this.defaultEnhancer = n;
this.keysAtom = new Atom(r + ".keys");
}
e.prototype.read = function(e) {
return this.values.get(e).get();
};
e.prototype.write = function(e, t) {
var r = this.target, n = this.values.get(e);
if (n instanceof ComputedValue) n.set(t); else {
if (hasInterceptors(this)) {
if (!(i = interceptChange(this, {
type: "update",
object: this.proxy || r,
name: e,
newValue: t
}))) return;
t = i.newValue;
}
if ((t = n.prepareNewValue(t)) !== globalState.UNCHANGED) {
var a = hasListeners(this), o = isSpyEnabled(), i = a || o ? {
type: "update",
object: this.proxy || r,
oldValue: n.value,
name: e,
newValue: t
} : null;
o && spyReportStart(__assign(__assign({}, i), {
name: this.name,
key: e
}));
n.setNewValue(t);
a && notifyListeners(this, i);
o && spyReportEnd();
}
}
};
e.prototype.has = function(e) {
var t = this.pendingKeys || (this.pendingKeys = new Map()), r = t.get(e);
if (r) return r.get();
var n = !!this.values.get(e);
r = new ObservableValue(n, referenceEnhancer, this.name + "." + stringifyKey(e) + "?", !1);
t.set(e, r);
return r.get();
};
e.prototype.addObservableProp = function(e, t, r) {
void 0 === r && (r = this.defaultEnhancer);
var n = this.target;
assertPropertyConfigurable(n, e);
if (hasInterceptors(this)) {
var a = interceptChange(this, {
object: this.proxy || n,
name: e,
type: "add",
newValue: t
});
if (!a) return;
t = a.newValue;
}
var o = new ObservableValue(t, r, this.name + "." + stringifyKey(e), !1);
this.values.set(e, o);
t = o.value;
Object.defineProperty(n, e, generateObservablePropConfig(e));
this.notifyPropertyAddition(e, t);
};
e.prototype.addComputedProp = function(e, t, r) {
var n = this.target;
r.name = r.name || this.name + "." + stringifyKey(t);
this.values.set(t, new ComputedValue(r));
(e === n || isPropertyConfigurable(e, t)) && Object.defineProperty(e, t, generateComputedPropConfig(t));
};
e.prototype.remove = function(e) {
if (this.values.has(e)) {
var t = this.target;
if (hasInterceptors(this) && !(s = interceptChange(this, {
object: this.proxy || t,
name: e,
type: "remove"
}))) return;
try {
startBatch();
var r = hasListeners(this), n = isSpyEnabled(), a = this.values.get(e), o = a && a.get();
a && a.set(void 0);
this.keysAtom.reportChanged();
this.values.delete(e);
if (this.pendingKeys) {
var i = this.pendingKeys.get(e);
i && i.set(!1);
}
delete this.target[e];
var s = r || n ? {
type: "remove",
object: this.proxy || t,
oldValue: o,
name: e
} : null;
n && spyReportStart(__assign(__assign({}, s), {
name: this.name,
key: e
}));
r && notifyListeners(this, s);
n && spyReportEnd();
} finally {
endBatch();
}
}
};
e.prototype.illegalAccess = function(e, t) {
console.warn("Property '" + t + "' of '" + e + "' was accessed through the prototype chain. Use 'decorate' instead to declare the prop or access it statically through it's owner");
};
e.prototype.observe = function(e, t) {
invariant(!0 !== t, "`observe` doesn't support the fire immediately property for observable objects.");
return registerListener(this, e);
};
e.prototype.intercept = function(e) {
return registerInterceptor(this, e);
};
e.prototype.notifyPropertyAddition = function(e, t) {
var r = hasListeners(this), n = isSpyEnabled(), a = r || n ? {
type: "add",
object: this.proxy || this.target,
name: e,
newValue: t
} : null;
n && spyReportStart(__assign(__assign({}, a), {
name: this.name,
key: e
}));
r && notifyListeners(this, a);
n && spyReportEnd();
if (this.pendingKeys) {
var o = this.pendingKeys.get(e);
o && o.set(!0);
}
this.keysAtom.reportChanged();
};
e.prototype.getKeys = function() {
var e, t;
this.keysAtom.reportObserved();
var r = [];
try {
for (var n = __values(this.values), a = n.next(); !a.done; a = n.next()) {
var o = __read(a.value, 2), i = o[0];
o[1] instanceof ObservableValue && r.push(i);
}
} catch (t) {
e = {
error: t
};
} finally {
try {
a && !a.done && (t = n.return) && t.call(n);
} finally {
if (e) throw e.error;
}
}
return r;
};
return e;
}();

function asObservableObject(e, t, r) {
void 0 === t && (t = "");
void 0 === r && (r = deepEnhancer);
if (Object.prototype.hasOwnProperty.call(e, $mobx)) return e[$mobx];
invariant(Object.isExtensible(e), "Cannot make the designated object observable; it is not extensible");
isPlainObject(e) || (t = (e.constructor.name || "ObservableObject") + "@" + getNextId());
t || (t = "ObservableObject@" + getNextId());
var n = new ObservableObjectAdministration(e, new Map(), stringifyKey(t), r);
addHiddenProp(e, $mobx, n);
return n;
}

var observablePropertyConfigs = Object.create(null), computedPropertyConfigs = Object.create(null);

function generateObservablePropConfig(e) {
return observablePropertyConfigs[e] || (observablePropertyConfigs[e] = {
configurable: !0,
enumerable: !0,
get: function() {
return this[$mobx].read(e);
},
set: function(t) {
this[$mobx].write(e, t);
}
});
}

function getAdministrationForComputedPropOwner(e) {
var t = e[$mobx];
if (!t) {
initializeInstance(e);
return e[$mobx];
}
return t;
}

function generateComputedPropConfig(e) {
return computedPropertyConfigs[e] || (computedPropertyConfigs[e] = {
configurable: globalState.computedConfigurable,
enumerable: !1,
get: function() {
return getAdministrationForComputedPropOwner(this).read(e);
},
set: function(t) {
getAdministrationForComputedPropOwner(this).write(e, t);
}
});
}

var isObservableObjectAdministration = createInstanceofPredicate("ObservableObjectAdministration", ObservableObjectAdministration);

function isObservableObject(e) {
if (isObject(e)) {
initializeInstance(e);
return isObservableObjectAdministration(e[$mobx]);
}
return !1;
}

function getAtom(e, t) {
if ("object" == typeof e && null !== e) {
if (isObservableArray(e)) {
void 0 !== t && fail("It is not possible to get index atoms from arrays");
return e[$mobx].atom;
}
if (isObservableSet(e)) return e[$mobx];
if (isObservableMap(e)) {
var r = e;
if (void 0 === t) return r._keysAtom;
(n = r._data.get(t) || r._hasMap.get(t)) || fail("the entry '" + t + "' does not exist in the observable map '" + getDebugName(e) + "'");
return n;
}
initializeInstance(e);
t && !e[$mobx] && e[t];
if (isObservableObject(e)) {
if (!t) return fail("please specify a property");
var n;
(n = e[$mobx].values.get(t)) || fail("no observable property '" + t + "' found on the observable object '" + getDebugName(e) + "'");
return n;
}
if (isAtom(e) || isComputedValue(e) || isReaction(e)) return e;
} else if ("function" == typeof e && isReaction(e[$mobx])) return e[$mobx];
return fail("Cannot obtain atom from " + e);
}

function getAdministration(e, t) {
e || fail("Expecting some object");
if (void 0 !== t) return getAdministration(getAtom(e, t));
if (isAtom(e) || isComputedValue(e) || isReaction(e)) return e;
if (isObservableMap(e) || isObservableSet(e)) return e;
initializeInstance(e);
if (e[$mobx]) return e[$mobx];
fail("Cannot obtain administration from " + e);
}

function getDebugName(e, t) {
return (void 0 !== t ? getAtom(e, t) : isObservableObject(e) || isObservableMap(e) || isObservableSet(e) ? getAdministration(e) : getAtom(e)).name;
}

var g, toString = Object.prototype.toString;

function deepEqual(e, t, r) {
void 0 === r && (r = -1);
return eq(e, t, r);
}

function eq(e, t, r, n, a) {
if (e === t) return 0 !== e || 1 / e == 1 / t;
if (null == e || null == t) return !1;
if (e != e) return t != t;
var o = typeof e;
if ("function" !== o && "object" !== o && "object" != typeof t) return !1;
var i = toString.call(e);
if (i !== toString.call(t)) return !1;
switch (i) {
case "[object RegExp]":
case "[object String]":
return "" + e == "" + t;

case "[object Number]":
return +e != +e ? +t != +t : 0 == +e ? 1 / +e == 1 / t : +e == +t;

case "[object Date]":
case "[object Boolean]":
return +e == +t;

case "[object Symbol]":
return "undefined" != typeof Symbol && Symbol.valueOf.call(e) === Symbol.valueOf.call(t);

case "[object Map]":
case "[object Set]":
r >= 0 && r++;
}
e = unwrap(e);
t = unwrap(t);
var s = "[object Array]" === i;
if (!s) {
if ("object" != typeof e || "object" != typeof t) return !1;
var c = e.constructor, l = t.constructor;
if (c !== l && !("function" == typeof c && c instanceof c && "function" == typeof l && l instanceof l) && "constructor" in e && "constructor" in t) return !1;
}
if (0 === r) return !1;
r < 0 && (r = -1);
a = a || [];
for (var u = (n = n || []).length; u--; ) if (n[u] === e) return a[u] === t;
n.push(e);
a.push(t);
if (s) {
if ((u = e.length) !== t.length) return !1;
for (;u--; ) if (!eq(e[u], t[u], r - 1, n, a)) return !1;
} else {
var p = Object.keys(e), d = void 0;
u = p.length;
if (Object.keys(t).length !== u) return !1;
for (;u--; ) if (!has$1(t, d = p[u]) || !eq(e[d], t[d], r - 1, n, a)) return !1;
}
n.pop();
a.pop();
return !0;
}

function unwrap(e) {
return isObservableArray(e) ? e.slice() : isES6Map(e) || isObservableMap(e) ? Array.from(e.entries()) : isES6Set(e) || isObservableSet(e) ? Array.from(e.entries()) : e;
}

function has$1(e, t) {
return Object.prototype.hasOwnProperty.call(e, t);
}

function makeIterable(e) {
e[Symbol.iterator] = getSelf;
return e;
}

function getSelf() {
return this;
}

if ("undefined" == typeof Proxy || "undefined" == typeof Symbol) throw new Error("[mobx] MobX 5+ requires Proxy and Symbol objects. If your environment doesn't support Symbol or Proxy objects, please downgrade to MobX 4. For React Native Android, consider upgrading JSCore.");

(function() {
if ("testCodeMinification" !== function() {}.name && "undefined" != typeof process && "true" !== process.env.IGNORE_MOBX_MINIFY_WARNING) {
var e = [ "process", "env", "NODE_ENV" ].join(".");
console.warn("[mobx] you are running a minified build, but '" + e + "' was not set to 'production' in your bundler. This results in an unnecessarily large and slow bundle");
}
})();

"object" == typeof __MOBX_DEVTOOLS_GLOBAL_HOOK__ && __MOBX_DEVTOOLS_GLOBAL_HOOK__.injectMobx({
spy: spy,
extras: {
getDebugName: getDebugName
},
$mobx: $mobx
});

window.FlowCancellationError = FlowCancellationError;

window.ObservableMap = ObservableMap;

window.ObservableSet = ObservableSet;

window.Reaction = Reaction;

window.allowStateChanges = allowStateChanges;

window.allowStateChangesInsideComputed = allowStateChangesInsideComputed;

window.allowStateReadsEnd = allowStateReadsEnd;

window.allowStateReadsStart = allowStateReadsStart;

window._endAction = _endAction;

window.getAdministration = getAdministration;

window.getGlobalState = getGlobalState;

window.interceptReads = interceptReads;

window.isComputingDerivation = isComputingDerivation;

window.resetGlobalState = resetGlobalState;

window._startAction = _startAction;

window.configure = configure;

window.observable = observable;

window.autorun = autorun;

window.computed = computed;

window.when = when;

window.reaction = reaction;

window.action = action;

window.values = values;

window.createAtom = createAtom;

window.decorate = decorate;

window.runInAction = runInAction;