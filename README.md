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

<div class="hidden">
    <div id="first_hidden_child"></div>
    <div id="second_hidden_child"></div>
</div>

<div id="my_template">
    <div class="template_child"></div>
    <div class="template_child"></div>
</div>
```

Main.hx
```haxe
// converts in compile time to js.Browser.document.getElementById("my-input").value
trace(Id.my_input.as(InputElement).value);

// converts in compile time to js.Browser.document.getElementsByClassName("hidden")
var hiddenElements = Cls.hidden.get();
for (h in hiddenElements)
  h.classList.remove(Cls.hidden);

// Gets the first element from the array of the elements containing "template_child" class inside the element with "my_template" id
// converts in compile time to js.Browser.getElementById("my_template").getElementsByClassName("template_child")[0]
switch Cls.template_child.firstFrom(Id.my_template.get()) {
    case Some(elementFound):
        // do something with the element
    case None:
        trace('No ${Cls.template_child.selector()} found in ${Id.my_template.selector()}');
}

// More specific search
Tag.input.specify('[type="text"]').addEventListener('keyup', (e) -> {
    // do something
});
```
