# What it would look like in Kona?

in Javascript, writing a Handlebars helper looks like this:
```Javascript
Handlebars.registerHelper("list", function(items, options) {
  const itemsAsHtml = items.map(item => "<li>" + options.fn(item) + "</li>");
  return "<ul>\n" + itemsAsHtml.join("\n") + "\n</ul>";
});
```

in Kona it would look like this:
```kona
Handlebars.register(:list, (items, options) => {
  <ul>
    {{#each items as item}}
      <li>{{item}}</li>
    {{/each}}
  </ul>
  ul.render { items: items.map( (item) => { options.fn item } ) }
})
```
