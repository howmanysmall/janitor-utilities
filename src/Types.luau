--!optimize 2
--!strict

export type Status = "Started" | "Resolved" | "Rejected" | "Cancelled"
export type ErrorKind = "ExecutionError" | "AlreadyCancelled" | "NotResolvedInTime" | "TimedOut"

type ErrorStaticAndShared = {
	Kind: {
		ExecutionError: "ExecutionError",
		AlreadyCancelled: "AlreadyCancelled",
		NotResolvedInTime: "NotResolvedInTime",
		TimedOut: "TimedOut",
	},
}
type ErrorOptions = {
	error: string,
	trace: string?,
	context: string?,
	kind: ErrorKind,
}

export type Error = typeof(setmetatable(
	{} :: ErrorStaticAndShared & {
		error: string,
		trace: string?,
		context: string?,
		kind: ErrorKind,
		parent: Error?,
		createdTick: number,
		createdTrace: string,

		extend: (self: Error, options: ErrorOptions?) -> Error,
		getErrorChain: (self: Error) -> {Error},
	},
	{} :: {__tostring: (self: Error) -> string}
))
type ErrorStatic = ErrorStaticAndShared & {
	new: (options: ErrorOptions?, parent: Error?) -> Error,
	is: (anything: any) -> boolean,
	isKind: (anything: any, kind: ErrorKind) -> boolean,
}

export type VoidPromise = {
	andThen: (
		self: VoidPromise,
		successHandler: (...any) -> ...any,
		failureHandler: ((...any) -> ...any)?
	) -> VoidPromise,
	andThenCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> any,
	andThenReturn: (self: VoidPromise, ...any) -> VoidPromise,

	await: (self: VoidPromise) -> (boolean, ...any),
	awaitStatus: (self: VoidPromise) -> (Status, ...any),

	cancel: (self: VoidPromise) -> (),
	catch: (self: VoidPromise, failureHandler: (...any) -> ...any) -> VoidPromise,
	expect: (self: VoidPromise) -> ...any,

	finally: (self: VoidPromise, finallyHandler: (status: Status) -> ...any) -> VoidPromise,
	finallyCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> VoidPromise,
	finallyReturn: (self: VoidPromise, ...any) -> VoidPromise,

	getStatus: (self: VoidPromise) -> Status,
	now: (self: VoidPromise, rejectionValue: any?) -> VoidPromise,
	tap: (self: VoidPromise, tapHandler: (...any) -> ...any) -> VoidPromise,
	timeout: (self: VoidPromise, seconds: number, rejectionValue: any?) -> VoidPromise,
}
export type Promise<T...> = {
	andThen: (
		self: VoidPromise,
		successHandler: (T...) -> ...any,
		failureHandler: ((...any) -> ...any)?
	) -> VoidPromise,
	andThenCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> VoidPromise,
	andThenReturn: (self: VoidPromise, ...any) -> VoidPromise,

	await: (self: VoidPromise) -> (boolean, T...),
	awaitStatus: (self: VoidPromise) -> (Status, T...),

	cancel: (self: VoidPromise) -> (),
	catch: (self: VoidPromise, failureHandler: (...any) -> ...any) -> VoidPromise,
	expect: (self: VoidPromise) -> T...,

	finally: (self: VoidPromise, finallyHandler: (status: Status) -> ...any) -> VoidPromise,
	finallyCall: <TArgs...>(self: VoidPromise, callback: (TArgs...) -> ...any, TArgs...) -> VoidPromise,
	finallyReturn: (self: VoidPromise, ...any) -> VoidPromise,

	getStatus: (self: VoidPromise) -> Status,
	now: (self: VoidPromise, rejectionValue: any?) -> VoidPromise,
	tap: (self: VoidPromise, tapHandler: (T...) -> ...any) -> VoidPromise,
	timeout: (self: VoidPromise, seconds: number, rejectionValue: any?) -> Promise<T...>,
}

type BooleanOrString = boolean | string
export type Janitor = typeof(setmetatable(
	{} :: {
		CurrentlyCleaning: boolean,
		SuppressInstanceReDestroy: boolean,

		Add: <T>(self: Janitor, object: T, methodName: BooleanOrString?, index: any?) -> T,
		AddObject: <T, A...>(
			self: Janitor,
			constructor: {new: (A...) -> T},
			methodName: BooleanOrString?,
			index: any?,
			A...
		) -> T,
		AddPromise: <T...>(self: Janitor, promiseObject: Promise<T...>) -> Promise<T...>,

		Remove: (self: Janitor, index: any) -> Janitor,
		RemoveNoClean: (self: Janitor, index: any) -> Janitor,

		RemoveList: (self: Janitor, ...any) -> Janitor,
		RemoveListNoClean: (self: Janitor, ...any) -> Janitor,

		Get: (self: Janitor, index: any) -> any?,
		GetAll: (self: Janitor) -> {[any]: any},

		Cleanup: (self: Janitor) -> (),
		Destroy: (self: Janitor) -> (),

		LinkToInstance: (self: Janitor, Object: Instance, allowMultiple: boolean?) -> RBXScriptConnection,
		LinkToInstances: (self: Janitor, ...Instance) -> Janitor,
	},
	{} :: {__call: (self: Janitor) -> ()}
))

return false
