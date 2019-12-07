function initRanges() {
    loadRangeJSON(function (response) {
        var actual_range_JSON = JSON.parse(response);
        listenToShapeSelectRange(actual_range_JSON);
    });
}

function loadRangeJSON(callback) {
    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    xobj.open('GET', './data-js/match_shp_ranges1.json', true);
    xobj.onreadystatechange = function () {
        if (xobj.readyState == 4 && xobj.status == "200") {
            callback(xobj.responseText);
        }
    };
    xobj.send(null);
}

function sortShapeRange(figura, json) {
    var figurasR = Object.values(json).filter((n) => {
        return n.shape === figura;
    });

    var count = figurasR.length;

    // console.log(figurasR);
    var resultShp = {
        'rLaimNelaim': 0,
        'rCerIzmis': 0, 'rUztrMier': 0,
        'rBrivIerob': 0, 'rApmAizkait': 0,
        'rInterGarl': 0, 'rPatNepat': 0
    }

    Object.values(figurasR).forEach((n) => {
        Object.entries(n).forEach((e) => {
            var range = e[0];
            if (range != "ranges" && range != "respID" && range != "shape") {
                resultShp[range] = resultShp[range] + parseInt(e[1], 10);
            }
        })
    });

    Object.keys(resultShp).forEach(k => {
        resultShp[k] = resultShp[k] / count;
        resultShp[k] = resultShp[k].toFixed(2);
    });

    var outputShp = Object.entries(resultShp).map(([key, value]) => ({ key, value }));

    outputShp.sort(function (a, b) {
        return b.value - a.value;
    });

    drawShapeRange(outputShp);
}

function listenToShapeSelectRange(json) {
    sortShapeRange("1", json); // on initial call to draw bars for shape 1
    document.querySelectorAll('.shapeRange').forEach(item => {
        item.addEventListener('click', event => {
            removeActiveShpRange();
            sortShapeRange(event.srcElement.id, json);
            event.srcElement.classList.add('activeShpRng');
        })
    });
}

function removeActiveShpRange() {
    document.querySelectorAll('.shapeRange').forEach(item => {
        item.classList.remove('activeShpRng');
    });
}

function drawShapeRange(values) {
    var dataset = values;

    var svgWidth = 600;
    var charWidth = 410;
    var svgHeight = 300;
    var chartHeight = 270;

    document.getElementById("range-diag").remove();

    var barSvgRange = d3.select('#range-div').append("svg").attr("id", "range-diag");
    barSvgRange.attr('width', svgWidth)
        .attr('height', svgHeight);


    var labels1 = {
            'rLaimNelaim': "Laimgīgs",
            'rCerIzmis': "Cerīgs",
            'rUztrMier': "Uztraukts",
            'rBrivIerob': "Brīvs",
            'rApmAizkait': "Apmierināts",
            'rInterGarl': "Ieinteresēts",
            'rPatNepat': "Patīk"
        }
    
    var labels2 = {
            'rLaimNelaim': "Nelaimīgs",
            'rCerIzmis': "Izmisis",
            'rUztrMier': "Mierīgs",
            'rBrivIerob': "Ierobežots",
            'rApmAizkait': "Aizkaitināts",
            'rInterGarl': "Garlaikots",
            'rPatNepat': "Nepatīk"
        }

    // scale height so bars are to max height
    var x = d3.scaleLinear()
        .domain([0, 100])
        .range([ 0, charWidth]);
    var y = d3.scaleBand()
        .range([ 0, chartHeight ])
        .domain(dataset.map(function(d) { return labels1[d.key]; }))
        .padding(.2);

    var y2 = d3.scaleBand()
        .range([ 0, chartHeight ]);

    var y3 = d3.scaleBand()
        .range([ 0, chartHeight ])
        .domain(dataset.map(function(d) { return labels2[d.key]; }))
        .padding(.2);
    
    // labels on x
    barSvgRange.append("g")
        .attr("transform", "translate(130, 270)")
        .call(d3.axisBottom(x));

    // labels on y
    barSvgRange.append("g")
        .call(d3.axisLeft(y))
        .attr("transform", "translate(130, 0)")
        .attr("id", "main-y")
        .attr("fill", "#f65c78");

    barSvgRange.append("g")
        .call(d3.axisLeft(y2))
        .attr("transform", "translate(335, 0)")
        .style("opacity", 0.2);

    barSvgRange.append("g")
        .call(d3.axisRight(y3))
        .attr("transform", "translate(540, 0)")
        .style("fill", "#c3f584");

    barSvgRange.selectAll("rect")
        .data(dataset)
        .enter()
        .append("text")
        .attr("y", function(d) { return y(labels1[d.key]) + 15; })
        .attr("text-anchor", "end")
        .text(function(d){
            return (d.value);
        })
        .attr("dx", function(d) { return x(d.value) + 165; }) //margin right
        .attr("dy", ".35em") //vertical align middle
        .style("color", "black")
        .style("font-size", "12")
        .style("text-align", "left")
        .style("display", "inline-block")
        .style("width", "30px");


    //Bars
    barSvgRange.selectAll("rect")
        .data(dataset)
        .enter()
        .append("rect")
        .attr("x", x(0) )
        .attr("y", function(d) { return y(labels1[d.key]); })
        .attr("width", function(d) { return x(d.value); })
        .attr("height", y.bandwidth() )
        .attr("fill", "#69b3a2")
        .attr('transform', "translate(131,0)")
        .attr("fill", function(d, i){
            if (d.value > 50) {
                return "#c3f584"
            } else {
                return "#f65c78"
            }
        })
        .style("opacity", 0.8);

}

initRanges();