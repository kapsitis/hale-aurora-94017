// ----------------------- match_shp_emo


function initShapes() {
    loadShpJSON(function(response) {
        var actual_shp_JSON = JSON.parse(response);
        listenToShapeSelect(actual_shp_JSON);
    });
}

function loadShpJSON(callback) {   
    var xobj = new XMLHttpRequest();
        xobj.overrideMimeType("application/json");
    xobj.open('GET', './data-js/match_shp_emo.json', true);
    xobj.onreadystatechange = function () {
          if (xobj.readyState == 4 && xobj.status == "200") {
            callback(xobj.responseText);
          }
    };
    xobj.send(null);  
}

function sortShape(figura, json) {
    var figuras = Object.values(json).filter((n) => {
        return n.shape === figura;
    });
    
    var resultShp = { 'Prieks':0.1, 'Milestiba':0.1, 
    'Apmierinajums':0.1, 'Mundrums':0.1, 
    'Ceriba':0.1, 'Sajusminajums':0.1, 
    'Bazas':0.1, 'Skumjas':0.1, 'Riebums':0.1, 
    'Vaina':0.1, 'Bailes':0.1, 'Dusmas': 0.1}

    Object.values(figuras).forEach((n) => {
        var emo = n.emotion;
        resultShp[emo] = resultShp[emo] + 1;
    });

    var outputShp = Object.entries(resultShp).map(([key, value]) => ({key,value}));
    
    outputShp.sort(function(a, b) { 
        return b.value - a.value;
    });

    drawShapeChart(outputShp);
}

function listenToShapeSelect(json) {
    sortShape("1", json); // on initial call to draw bars for shape 1
    document.querySelectorAll('.shape').forEach(item => {
        item.addEventListener('click', event => {
            removeActiveShp();
            sortShape(event.srcElement.id, json);
            event.srcElement.classList.add('activeShp');
        })
    });
}

function removeActiveShp() {
    document.querySelectorAll('.shape').forEach(item => {
        item.classList.remove('activeShp');
    });
}

function drawShapeChart(values) {
    var dataset = values;

    var svgWidth = 500;
    var charWidth = 410;
    var svgHeight = 300;
    var barHeight = 210;
    var barPadding = 7;
    var barWidth = (charWidth / dataset.length);
    
    document.getElementById("shape-bars").remove()
    
    var barSvg = d3.select('#shape-div').append("svg").attr("id", "shape-bars");
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
        .call(d3.axisBottom(x))
        .selectAll("text")
        .attr("y", 2)
        .attr("transform", "rotate(-70)")
        .style("text-anchor", "end");

    barSvg.append("text")             
        .attr("transform",
              "translate(470, 240)")
        .style("text-anchor", "middle")
        .text("Emocija");

    // labels on y
    barSvg.append("g")
        .call(d3.axisLeft(y))
        .attr("transform", "translate(30, 20)");

    // // bars
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

        
    // // Animation
    barSvg.selectAll('rect')
        .transition()
        .duration(500)
        .attr("height", function(d) { return barHeight - y(d.value); })
        .attr("y", function(d) { return y(d.value); })
        .delay(function(d,i){ return((i+1)*50)});
}

initShapes();