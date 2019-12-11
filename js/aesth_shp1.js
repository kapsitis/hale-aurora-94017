function initAesth() {
    loadAesthJSON(function (response) {
        var actual_JSON_aesth = JSON.parse(response);

        listenToShpAesthSelect(actual_JSON_aesth);
    });
}

function loadAesthJSON(callback) {
    var xobj = new XMLHttpRequest();
    xobj.overrideMimeType("application/json");
    xobj.open('GET', '../data-js/match_aesth_shp1.json', true);
    xobj.onreadystatechange = function () {
        if (xobj.readyState == 4 && xobj.status == "200") {
            callback(xobj.responseText);
        }
    };
    xobj.send(null);
}

function sortAesth(figura, json) {
    var figurasAs = Object.values(json).filter((n) => {
        return n.shape === figura;
    });
    var resultAesth = {
        'Kartiga': 0, 'Patikama': 0,
        'Simetriska': 0, 'Originala': 0,
        'Sarezgita': 0, 'Iespaidiga': 0,
        'Radosa': 0, 'Mulsinosa': 0,
        'Baudama': 0, 'Nepatikama': 0
    }

    Object.values(figurasAs).forEach((n) => {
        var aesth = n.aesth;
        resultAesth[aesth] = resultAesth[aesth] + 1;
    });

    for (var prop in resultAesth) {
        if (resultAesth[prop] === 0) {
            delete resultAesth[prop];
        }
    }

    drawPieChart(resultAesth);
}

function listenToShpAesthSelect(json) {
    sortAesth("1", json); // on initial call to draw bars for 'Prieks'
    document.querySelectorAll('.shape-ast').forEach(item => {
        item.addEventListener('click', event => {
            removeActive();
            sortAesth(event.srcElement.id, json);
            event.srcElement.classList.add('activeShpAsth');
        })
    });
}

function removeActive() {
    document.querySelectorAll('.shape-ast').forEach(item => {
        item.classList.remove('activeShpAsth');
    });
}

function drawPieChart(values) {

    // set the dimensions and margins of the graph
    var width = 450
    height = 450
    margin = 20

    document.getElementById("ashetics-pie").remove()

    // The radius of the pieplot is half the width or half the height (smallest one). I subtract a bit of margin.
    var radius = Math.min(width, height) / 2 - margin

    var radius = Math.min(width, height) / 2 * 0.8;

    // append the svg object to the div called 'ashetics-div'
    var svg = d3.select("#ashetics-div")
        .append("svg")
        .attr("id", "ashetics-pie")
        .attr("width", width)
        .attr("height", height)
        .append("g")
        .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

    // Create dummy data
    var data = values;

    // set the color scale
    var color = d3.scaleOrdinal()
        .domain([1, 20])
        .range(d3.schemeSet3);

    // Compute the position of each group on the pie:
    var pie = d3.pie()
        .value(function (d) { return d.value; })
    var data_ready = pie(d3.entries(data))
    // Now I know that group A goes from 0 degrees to x degrees and so on.

    // shape helper to build arcs:
    var arcGenerator = d3.arc()
        .innerRadius(0)
        .outerRadius(radius)

    var arcLabelGenerator = d3.arc()
        .innerRadius(radius)
        .outerRadius(radius + 30)

    // Build the pie chart: Basically, each part of the pie is a path that we build using the arc function.
    svg
        .selectAll('mySlices')
        .data(data_ready)
        .enter()
        .append('path')
        .attr('d', arcGenerator)
        .attr('fill', function (d) { return (color(d.data.key)) })
        .attr("stroke", "black")
        .style("stroke-width", "1px")
        .style("opacity", 0.7)

    // Now add the annotation. Use the centroid method to get the best coordinates
    svg
        .selectAll('mySlices')
        .data(data_ready)
        .enter()
        .append('text')
        .text(function (d) { return d.data.key })
        .attr("transform", function (d) { return "translate(" + arcLabelGenerator.centroid(d) + ")"; })
        .attr("id", function (d) { return d.data.key + "-text" })
        .style("text-anchor", "middle")
        .style("font-size", 12);



}

initAesth();