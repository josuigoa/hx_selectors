package hx;

import haxe.macro.Context;
import haxe.macro.Expr;

using StringTools;

enum SelType {
	id;
	cls;
	tag;
}

class Selectors {
	static public var ID_ATTR = ~/id=["']([A-Za-z0-9_-]+)["']/;
	static public var CLASS_ATTR = ~/class=["']([A-Za-z0-9_\s-]+)["']/;
	static public var TAG = ~/<([A-Za-z0-9]+)/;
	static var CSS_CLASS = ~/\.{1}([a-z][a-z0-9\-_]+)/;
	static public var INVALID_CHARS = ~/[^A-Za-z0-9_]/g;

	static public function buildId()
		return build(ID_ATTR, id);

	static public function buildCls() {
		var htmlClasses = build(CLASS_ATTR, cls);
		var cssClasses = build(CSS_CLASS, cls, 'css');

		var duplicates = [];
		for (htmlCls in htmlClasses)
			duplicates = duplicates.concat(cssClasses.filter(cssCls -> cssCls.name == htmlCls.name));

		for (dp in duplicates) {
			cssClasses.remove(dp);
		}

		return htmlClasses.concat(cssClasses);
	}

	static public function buildTag()
		return build(TAG, tag);

	static public function build(ereg:EReg, type:SelType, fileExt:String = 'html'):Array<Field> {
		var currentFields = Context.getBuildFields();

		var defPath = Context.definedValue("indexPath");
		var paths = (defPath == null) ? ['index.$fileExt'] : defPath.split(',');
		var extra = null;
		var extraDefName = switch type {
			case id: 'extraId';
			case cls: 'extraCls';
			case tag: 'extraTag';
		}
		var extraString = Context.definedValue(extraDefName);
		if (extraString != null)
			extra = [for (e in extraString.split(',')) if (e.trim() != '') e.trim()];

		var fileContent, elements = new Map<String, Elem>(), el, clsElem;
		for (p in paths) {
			fileContent = getFileContent(p);
			if (p.endsWith(fileExt)) {
				while (ereg.match(fileContent)) {
					el = ereg.matched(1);
					if (type == cls) {
						clsElem = el.split(' ');
						for (ce in clsElem) {
							elements.remove(ce);
							elements.set(ce, new Elem(ce, p));
						}
					} else {
						elements.remove(el);
						elements.set(el, new Elem(el, p));
					}
					fileContent = ereg.matchedRight();
				}
			}
			if (extra != null) {
				for (e in extra) {
					if (StringTools.trim(e) == '')
						continue;
					elements.remove(e);
					elements.set(e, new Elem(e, p));
				}
			}
		}
		return currentFields.concat(buildFields(elements, type));
	}

	static function buildFields(_fieldNames:Map<String, Elem>, type:SelType):Array<Field> {
		var fields = [];
		var pos = Context.currentPos();
		var varComplexType = switch type {
			case id: macro
			:hx.Selectors.IdSel;
			case cls: macro
			:hx.Selectors.ClsSel;
			case tag: macro
			:hx.Selectors.TagSel;
		}
		for (f in _fieldNames) {
			fields.push({
				name: INVALID_CHARS.replace(f.name, '_'),
				access: [APublic, AStatic, AInline],
				meta: [{name: ':dce', params: [], pos: pos}],
				pos: pos,
				doc: '"${f.name}" selector from "${f.origin}" file.',
				kind: FVar(varComplexType, macro $v{f.name})
			});
		}
		return fields;
	}

	static function getFileContent(_path:String) {
		try {
			var p = Context.resolvePath(_path);
			return sys.io.File.getContent(p);
		} catch (e:Dynamic) {
			Context.error('$_path fitxategia kargatzean errorea: $e', Context.currentPos());
			return '';
		}
	}
}

private class Elem {
	public var name:String;
	public var origin:String;

	public function new(n, o) {
		name = n;
		origin = o;
	}
}
