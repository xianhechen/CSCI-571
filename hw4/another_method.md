```javascript
airlines = xmlDoc.getElementsByTagName("Airline");
for (i = 0; i<airlines.length; i++) {
    airline = airlines[i];
    airlineName = airline.childNodes[0];
    airlineValue = airlineName.nodeValue;
    //txt += airlineValue + "<br>";

    var tr = document.createElement("tr");
    var td = document.createElement("td");
    var textNode = document.createTextNode(airlineValue);
    td.appendChild(textNode);
    tr.appendChild(td);
    document.getElementById("demo").appendChild(tr);
}
```
