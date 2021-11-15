package hx;

import js.Browser.document;
import js.html.Element;
import haxe.ds.Option;

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
	 *  Get the element by this id
	 *  @return js.Browser.document.getElementById(this)
	 */
	inline public function get()
		return document.getElementById(this);

	/**
	 *  Get the element by this id casted the given class
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
	 *  Get array of elements containing this classname
	 *  @return js.Browser.document.getElementsByClassName(this)
	 */
	inline public function get()
		return from(cast document);

	/**
	 *  Get the first item from the array of elements containing this classname
	 *  @return js.Browser.document.getElementsByClassName(this)[0]
	 */
	inline public function first()
		return firstFrom(cast document);

	/**
	 *  Get the first item from the array of elements containing this classname casted to given class
	 *  @return js.Browser.document.getElementsByClassName(this)[0]
	 */
	inline public function firstAs<T:js.html.Element>(cls:Class<T>)
		return firstFromAs(cast document, cls);

	/**
	 *  Get the children array of the element `element` containing this classname
	 *  @return element.getElementsByClassName(this)
	 */
	inline public function from(element:Element)
		return element.getElementsByClassName(this);

	/**
	 *  Get the first of the chindren array of the element `element` containing this classname
	 *  @return element.getElementsByClassName(this)[0]
	 */
	inline public function firstFrom(element:Element) {
		var array = element.getElementsByClassName(this);
		return array.length == 0 ? None : Some(array[0]);
	}

	/**
	 *  Get the first of the chindren array of the element `element` containing this classname
	 *  @return element.getElementsByClassName(this)[0]
	 */
	inline public function firstFromAs<T:js.html.Element>(element:Element, cls:Class<T>) {
		var array = element.getElementsByClassName(this);
		return array.length == 0 ? None : Some(Std.downcast(array[0], cls));
	}

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
	 *  Get array of elements which are defined by this tag
	 *  @return js.Browser.document.getElementsByTagName(this)
	 */
	inline public function get()
		return from(cast document);

	/**
	 *  Get the first elements from the array which are defined by this tag
	 *  @return js.Browser.document.getElementsByTagName(this)[0]
	 */
	inline public function first()
		return firstFrom(cast document);

	/**
	 *  Get the children array of the element `element` defined by this tag
	 *  @return element.getElementsByTagName(this)
	 */
	inline public function from(element:Element)
		return element.getElementsByTagName(this);

	/**
	 *  Get the first element of the children array of the element `element` defined by this tag
	 *  @return element.getElementsByTagName(this)[0]
	 */
	inline public function firstFrom(element:Element) {
		var array = element.getElementsByTagName(this);
		return array.length == 0 ? None : Some(array[0]);
	}

	/**
	 *  @return js.Browser.document.querySelector(this + ' ' + extraSelector)
	 */
	inline public function specify(extraSelector:String)
		return document.querySelector(selector() + ' $extraSelector');
}
