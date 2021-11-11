package hx;

import js.Browser.document;

typedef Selectors = {}

@:build(hx.Selectors.buildId())
class Id {}

@:build(hx.Selectors.buildCls())
class Cls {}

@:build(hx.Selectors.buildTag())
class Tag {}

abstract IdSel(String) to String from String {
	inline public function new(id)
		this = id;

	/**
	 *  @return '#' + this
	 */
	public inline function selector()
		return '#' + this;

	/**
	 *  @return js.Browser.document.getElementById(this)
	 */
	inline public function get()
		return document.getElementById(this);

	/**
	 *  @return js.Browser.document.getElementById(this) casted to the given class
	 */
	inline public function as<T:js.html.Element>(cls:Class<T>)
		return Std.downcast(get(), cls);
}

abstract ClsSel(String) to String from String {
	inline public function new(cls)
		this = cls;

	/**
	 *  @return '.' + this
	 */
	public inline function selector()
		return '.' + this;

	/**
	 *  @return js.Browser.document.getElementsByClassName(this)
	 */
	inline public function get()
		return document.getElementsByClassName(this);

	/**
	 *  @return js.Browser.document.querySelector(this + ' ' + extraSelector)
	 */
	inline public function specify(extraSelector:String)
		return document.querySelector(selector() + ' $extraSelector');
}

abstract TagSel(String) to String from String {
	inline public function new(tag)
		this = tag;

	/**
	 *  @return this
	 */
	public inline function selector()
		return this;

	/**
	 *  @return js.Browser.document.getElementsByTagName(this)
	 */
	inline public function get()
		return document.getElementsByTagName(this);

	/**
	 *  @return js.Browser.document.querySelector(this + '[for="' + id + '"]')
	 */
	inline public function forId(id:String)
		return document.querySelector(selector() + '[for="$id"]');

	/**
	 *  @return js.Browser.document.querySelector(this + '[type="' + id + '"]')
	 */
	inline public function ofType(type:String)
		return document.querySelector(selector() + '[type="$type"]');

	/**
	 *  @return js.Browser.document.querySelector(this + ' ' + extraSelector)
	 */
	inline public function specify(extraSelector:String)
		return document.querySelector(selector() + ' $extraSelector');
}
