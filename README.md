# hx_selectors

This library parses `html` and `css` files defined in the `hxml` file and extracts the `id` and `class` elements to create a type-safe access.

build.hxml
```
--library hx_selectors
-D indexPath=bin/index.html,bin/style.css
```

index.html
```html
<input id="my-input">

<div class="hidden"></div>
```

Main.hx
```haxe
// converts in compile time to js.Browser.document.getElementById("my-input").value
trace(Id.my_input.as(InputElement).value);
// converts in compile time to js.Browser.document.getElementsByClassName("hidden")
var hiddenElements = Cls.hidden.get();
for (h in hiddenElements)
  h.classList.remove(Cls.hidden);
```
