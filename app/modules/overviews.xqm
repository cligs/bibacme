xquery version "3.0";

module namespace overviews="http://localhost/overviews";

declare namespace tei="http://www.tei-c.org/ns/1.0";

import module namespace app="http://localhost/app" at "app.xqm";


declare function overviews:bar-chart($params as map()*, $data as map()*){
    (:
    $params := map{
        "title" := "bar chart title",
        "containerId" := "ChartAutores_1",
        "xaxis-title" := "xaxis title",
        "yaxis-title" := "yaxis title"
        }
    $data := map{
            "x" := ["argentina/o", "cubana/o", "mexicana/o"],
            "y" := [10, 5, 20]
        }
    :)
    <script>
        var data = [{{
          x: ['{string-join($data("x"),"','")}'],
          y: [{string-join($data("y"),",")}],
          type: 'bar',
          marker: {{color: '{let $color := $params("color") return if ($color) then $color else "green"}'}}
        }}];
  
        var layout = {{
      	     title: '{$params("title")}',
      	     showlegend: false,
      	     //hovermode: !1,
      	     xaxis: {{title: '{$params("xaxis-title")}' }},
      	     yaxis: {{title: '{$params("yaxis-title")}'{let $y_range := $params("y_range") 
      	                                                return if ($y_range) then concat(", range: [0,", $y_range,"]") else()} }}
      	     }};

        Plotly.newPlot('{$params("containerId")}', data, layout, {{displayModeBar: false, staticPlot: false}});
    </script>
    
};

declare function overviews:pie-chart($params as map()*, $data as map()*){
    <script>
        var data = [{{
          labels: ['{string-join($data("labels"),"','")}'],
          values: [{string-join($data("values"),",")}],
          type: 'pie',
          marker: {{color: 'green'}}
        }}];
  
        var layout = {{
      	     title: '{$params("title")}',
      	     showlegend: true,
      	     //hovermode: !1
      	     }};

        Plotly.newPlot('{$params("containerId")}', data, layout, {{displayModeBar: false, staticPlot: false}});
    </script>
};


declare function overviews:histogram($params as map()*, $data as map()*){
    <script>
        var data = [{{
          x: ['{string-join($data("x"),"','")}'],
          type: 'histogram',
          marker: {{color: 'green'}},
          name: '{$params("legend-name")}',
          xbins: {{size: 1}}
        }}];
  
        var layout = {{
      	     title: '{$params("title")}',
      	     showlegend: true,
      	     //hovermode: !1,
      	     xaxis: {{title: '{$params("xaxis-title")}' }},
      	     yaxis: {{title: '{$params("yaxis-title")}' }}
      	     }};

        Plotly.newPlot('{$params("containerId")}', data, layout, {{displayModeBar: false, staticPlot: false}});
    </script>
};