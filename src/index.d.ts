/* eslint-disable unicorn/filename-case */
import type { Janitor } from "@rbxts/janitor";

export = JanitorUtilities;
export as namespace JanitorUtilities;

type Constructable<T> = new (...createArguments: Parameters<T>) => T;
interface ConnectionLike {
	Disconnect(): void;
}

interface SignalLike<T extends Callback = Callback> {
	Connect?(callback: T): ConnectionLike;
	connect?(callback: T): ConnectionLike;
}

type InferSignalParameters<S> = S extends SignalLike
	? Parameters<
			Parameters<
				S["Connect"] extends Callback ? S["Connect"] : S["connect"] extends Callback ? S["connect"] : never
			>[0]
		>
	: never;

type OnlyStringKeys<T extends object | void = void> = T extends object
	? { [K in keyof T]-?: T[K] extends string ? K : never }[keyof T]
	: never;

/**
 * A bunch of utilities to deal with Janitors.
 */
declare namespace JanitorUtilities {
	/**
	 * Constructs an object for you and adds it to the Janitor. It's really
	 * just shorthand for `janitor.Add(new Object(), methodName, index)`. This
	 * did originally exist as part of Janitor's API, but it has since been
	 * removed in favor of this library.
	 *
	 * @example
	 * import { Janitor } from "@rbxts/janitor";
	 * import JanitorUtilities from "@rbxts/janitor-utilities";
	 *
	 * const obliterator = new Janitor();
	 * const subObliterator = JanitorUtilities.AddObject(obliterator, Janitor, "Destroy");
	 *
	 * @param janitor The Janitor to add the object to.
	 * @param object The constructor for the object you want to add to the Janitor.
	 * @param methodName The name of the method that will be used to clean up.
	 * If not passed, it will first check if the object's type exists in
	 * TypeDefaults, and if that doesn't exist, it assumes `Destroy`.
	 * @param index The index that can be used to clean up the object manually.
	 * @param createArguments The arguments that will be passed to the
	 *  constructor.
	 * @returns The constructed object.
	 */
	export function AddObject<
		O extends Constructable<unknown>,
		T extends InstanceType<O>,
		M extends ExtractKeys<T, () => void> | true | undefined,
		U extends object | void = void,
		I extends keyof U | undefined = undefined,
	>(janitor: Janitor<U>, object: O, methodName?: M, index?: I, ...createArguments: ConstructorParameters<O>): T;

	/**
	 * Adds a new sub-Janitor to the passed Janitor.
	 *
	 * @example
	 * import { Janitor } from "@rbxts/janitor";
	 * import JanitorUtilities from "@rbxts/janitor-utilities";
	 *
	 * const obliterator = new Janitor();
	 * const subObliterator = JanitorUtilities.AddNewJanitor(obliterator);
	 *
	 * @param janitor The Janitor to create a new Janitor in.
	 * @param index The index that can be used to clean up the Janitor
	 * manually.
	 * @returns The new Janitor.`
	 */
	export function AddNewJanitor<
		U extends object | void = void,
		I extends keyof U | undefined = undefined,
		V extends object | void = void,
	>(janitor: Janitor<U>, index?: I): Janitor<V>;

	/**
	 * Clones an Instance and adds it to the Janitor.
	 *
	 * @example
	 * import { Janitor } from "@rbxts/janitor";
	 * import JanitorUtilities from "@rbxts/janitor-utilities";
	 *
	 * const obliterator = new Janitor();
	 * const newPart = JanitorUtilities.AddClone(obliterator, new Instance("Part"));
	 *
	 * @param janitor The Janitor to add the object to.
	 * @param object The Instance to clone.
	 * @param index The index that can be used to clean up the object manually.
	 * @returns The cloned Instance.
	 */
	export function AddClone<
		T extends Instance,
		M extends ExtractKeys<T, () => void> | true | undefined,
		U extends object | void = void,
		I extends keyof U | undefined = undefined,
	>(janitor: Janitor<U>, object: T, methodName?: M, index?: I): T;

	/**
	 * Connects a callback to a signal and adds the returned connection to the
	 * Janitor.
	 *
	 * @example
	 * import { Janitor } from "@rbxts/janitor";
	 * import JanitorUtilities from "@rbxts/janitor-utilities";
	 *
	 * const obliterator = new Janitor();
	 * JanitorUtilities.AddConnect(obliterator, script.ChildAdded, (child) => {});
	 *
	 * @param janitor The Janitor to add the connection to.
	 * @param signal The signal to connect to.
	 * @param callback The callback to connect.
	 * @param index The index that can be used to clean up the connection manually.
	 * @returns The connection that was added.
	 */
	export function AddConnect<
		S extends SignalLike,
		U extends object | void = void,
		I extends keyof U | undefined = undefined,
	>(
		janitor: Janitor<U>,
		signal: S,
		callback: (...signalArguments: InferSignalParameters<S>) => void,
		index?: I,
	): ConnectionLike;

	/**
	 * Adds a {@linkcode RunService.BindToRenderStep} to the passed Janitor.
	 *
	 * @example
	 * import { Janitor } from "@rbxts/janitor";
	 * import JanitorUtilities from "@rbxts/janitor-utilities";
	 *
	 * const obliterator = new Janitor<{ readonly update: () => void }>();
	 * JanitorUtilities.AddBindToRenderStep(obliterator, "update", 9999, () => {});
	 *
	 * @throws A context error if the function is not called on the client.
	 *
	 * @param janitor The Janitor to add the binding to.
	 * @param name The name of the binding.
	 * @param priority The priority of the binding.
	 * @param callback The callback to bind.
	 * @returns A function to cleanup the binding.
	 */
	export function AddBindToRenderStep<I extends OnlyStringKeys<U>, U extends object | void = void>(
		janitor: Janitor<U>,
		name: I,
		priority: number,
		callback: (deltaTime: number) => void,
	): () => void;
}
