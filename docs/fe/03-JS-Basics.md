## JavaScript

### JavaScript 的引入方式


```html
<script src="xxx.js"></script>

<!-- or -->

<script>

  raw js

</script>
```


#### Load JSON file 

```js
function loadJSON(fileName, callback) {   
  var xobj = new XMLHttpRequest();
  xobj.overrideMimeType("application/json");
  xobj.open('GET', fileName, true);
  xobj.onreadystatechange = function () {
    if (xobj.readyState == 4 && xobj.status == "200") {
      callback(xobj.responseText);
    }
  };
  xobj.send(null);
}

// index.json
// {'abc': ['a', 'b', 'c']}

loadJSON('index.json', response => {
  var actual_JSON = JSON.parse(response);

  let ab = actual_JSON.abc;
});
```

