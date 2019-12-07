// ------------------------- match_emp_shp
function initEmotions() {
    loadJSON(function(response) {
        var actual_emo_JSON = JSON.parse(response);

        listenToEmotionSelect(actual_emo_JSON);
    });
}

function loadJSON(callback) {   
    var xobj = new XMLHttpRequest();
        xobj.overrideMimeType("application/json");
    xobj.open('GET', './data-js/match_emo_shp.json', true);
    xobj.onreadystatechange = function () {
          if (xobj.readyState == 4 && xobj.status == "200") {
            callback(xobj.responseText);
          }
    };
    xobj.send(null);  
}

function sortEmo(emocija, json) {
    var bailes = Object.values(json).filter((n) => {
        return n[1] === emocija;
    });
    var result = { 1:0.1, 2:0.1, 3:0.1, 4:0.1, 5:0.1, 6:0.1, 7:0.1, 8:0.1, 9:0.1, 10:0.1, 11:0.1, 12:0.1, 13:0.1, 14:0.1, 15:0.1, 16:0.1, 17:0.1}

    Object.values(bailes).forEach((n) => {
        var fig = n[2];
        result[fig] = result[fig] + 1;
    });

    var output = Object.entries(result).map(([key, value]) => ({key,value}));
    
    output.sort(function(a, b) { 
        return b.value - a.value;
    });

    drawChart(output);
}

function listenToEmotionSelect(json) {
    sortEmo("Prieks", json); // on initial call to draw bars for 'Prieks'
    document.querySelectorAll('.emotion').forEach(item => {
        item.addEventListener('click', event => {
            removeActiveEmo();
            sortEmo(event.srcElement.id, json);
            event.srcElement.classList.add('activeEmo');
        })
    });
}

function removeActiveEmo() {
    document.querySelectorAll('.activeEmo').forEach(item => {
        item.classList.remove('activeEmo');
    });
}

function drawChart(values) {
    var dataset = values;

    var svgWidth = 500;
    var charWidth = 410;
    var svgHeight = 280;
    var barHeight = 210;
    var barPadding = 7;
    var barWidth = (charWidth / dataset.length);

    var scale = svgHeight / dataset[0].value;
    document.getElementById("emotion-bars").remove()
    
    var barSvg = d3.select('#emotion-div').append("svg").attr("id", "emotion-bars");
    barSvg.attr('width', svgWidth)
        .attr('height', svgHeight);
    
    var color = d3.scaleLinear().domain([1,9])
        .interpolate(d3.interpolateHcl)
        .range([d3.rgb("#007AFF"), d3.rgb('#FFF500')]);

    // scale height so bars are to max height
    var y = d3.scaleLinear()
        .domain([0, dataset[0].value])
        .range([ barHeight, 0]);
    var x = d3.scaleBand()
        .range([ 0, charWidth ])
        .domain(dataset.map(function(d) { return d.key; }));
    // labels on x
    barSvg.append("g")
        .attr("transform", "translate(30, 230)")
        .attr("class", "axis")
        .call(d3.axisBottom(x))
        .selectAll("text")
        .style("text-anchor", "end")
        .style("display", "none");


    barSvg.select(".axis").selectAll(".tick")
        .data(dataset)
        .append("svg:image")
        .attr("xlink:href", function (d) { return "./shape_svg/" + d.key + ".svg" })
        .attr("width", 20)
        .attr("height", 20)
        .attr("x", -10)
        .attr("y", 6);

    barSvg.append("text")             
        .attr("transform",
              "translate(470, 240)")
        .style("text-anchor", "middle")
        .text("Figūra");

    // labels on y
    barSvg.append("g")
        .call(d3.axisLeft(y))
        .attr("transform", "translate(30, 20)");

    // bars
    barSvg.selectAll('rect')
        .data(dataset) // provide the data in waiting state
        .enter() // enter method takes the dataset and complete futher operations
        .append('rect') //bars are rectangles
        .attr("height", function(d) { return barHeight - y(0); }) // always equal to 0
        .attr("y", function(d) { return y(0); })
        .attr('width', barWidth - barPadding)
        .attr('transform', function(d, i) {
            var translate = [barWidth * i + (barPadding/2) + 30, 20]; // barwidht * i būs nobīde uz labo pusi uz x ass
            return "translate(" + translate + ")"; //takes two argument x and y for the location of the object
        })
        .attr("fill", function(d, i){return color(i) });

        
    // Animation
    barSvg.selectAll('rect')
        .transition()
        .duration(500)
        .attr("height", function(d) { return barHeight - y(d.value); })
        .attr("y", function(d) { return y(d.value); })
        .delay(function(d,i){ return((i+1)*50)});
}

initEmotions();



