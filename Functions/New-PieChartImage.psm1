Function New-PieChartImage{
    <#
    .SYNOPSIS
        Generate a Pie Chart image file.
    .DESCRIPTION
        Generate a Pie Chart image file.
    .EXAMPLE
        PS C:\> $HashTable = @{a=12;b=150;x=71}
        PS C:\> New-PieChartImage -Hash $HashTable -Title "Title" -LegendTile "Legend" -Path $PWD\PieChartExample1.png -Unite 'patates' -ThreeDimension -Radius 99
        Create a hashtable. Generates a Pie chart image named PieChartExample1.png in the currentd path.
    .INPUTS
        System.Collections.Hashtable
    .OUTPUTS
        PNG file.
    .NOTES
        Feel free to contribute, fork, create issues etc...
        https://github.com/LxLeChat/SimpleCharts
    #>
    param(
        [parameter(Mandatory=$True)]
        [ValidateScript({If($_.gettype().toString() -eq "System.Collections.Hashtable"){$True}Else{Throw "You must provide a HashTable, `$hash=@{""a""=1;""b""=2} "}})]
        [Hashtable]$Hash,
        [ValidateScript({[System.IO.Directory]::Exists(([System.IO.FileInfo]$_).Directory.FullName)})]
        [String]$Path,
        [int]$Width,
        [int]$Height,
        [String]$Title,
        [String]$LegendTitle,
        [String]$Unite,
        [int]$Radius,
        [int]$StartAngle,
        [string]$DrawingStyle,
        [switch]$ThreeDimension
    )

    ## Test & Define default value For Width
    If ( $null -eq $PSBoundParameters['Title'] ) {
        $PSBoundParameters.Add('Title','Default')
    }

    ## Test & Define default value For Width
    If ( $null -eq $PSBoundParameters['Width'] ) {
        $PSBoundParameters.Add('Width',400)
    }

    ## Test & Define default value For Height
    If ( $null -eq $PSBoundParameters['Height'] ) {
        $PSBoundParameters.Add('Height',400)
    }

    ## Test & Define default value For Height
    If ( $null -eq $PSBoundParameters['Radius'] ) {
        $PSBoundParameters.Add('Radius',90)
    }

    ## Test & Define default value For Height
    If ( $null -eq $PSBoundParameters['StartAngle'] ) {
        $PSBoundParameters.Add('StartAngle',0)
    }

    ## Test & Define default value For Height
    If ( $null -eq $PSBoundParameters['DrawingStyle'] ) {
        $PSBoundParameters.Add('DrawingStyle','Default')
    }

    ## Load necessary assemblies 
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [void][Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms.DataVisualization")

    ## Create Chart Object
    $Chart = New-object System.Windows.Forms.DataVisualization.Charting.Chart
    $Chart.Width        = $PSBoundParameters["Width"]
    $Chart.Height       = $PSBoundParameters["Height"]
    $Chart.Left         = 0
    $Chart.Top          = 0
    
    ## Configure Color Palette
    $Chart.Palette      = "None"
    [System.Drawing.ColorTranslator]::FromHtml("#abebc6")
    [System.Drawing.ColorTranslator]::FromHtml("#e74c3c")
    $CustomColorPalette = `
    [System.Drawing.ColorTranslator]::FromHtml("#e74c3c"),`
    [System.Drawing.ColorTranslator]::FromHtml("#9b59b6"),`
    [System.Drawing.ColorTranslator]::FromHtml("#3498db"),`
    [System.Drawing.ColorTranslator]::FromHtml("#16a085"),`
    [System.Drawing.ColorTranslator]::FromHtml("#2ecc71"),`
    [System.Drawing.ColorTranslator]::FromHtml("#f39c12"),`
    [System.Drawing.ColorTranslator]::FromHtml("#d35400"),`
    [System.Drawing.ColorTranslator]::FromHtml("#7f8c8d"),` #gris
    [System.Drawing.ColorTranslator]::FromHtml("#d2b4de"),` #violet clair
    [System.Drawing.ColorTranslator]::FromHtml("#bdc3c7"),` #gris un peu plus clair
    [System.Drawing.ColorTranslator]::FromHtml("#0e6251"),` #marron.
    [System.Drawing.ColorTranslator]::FromHtml("#34495e"),` #gris bleu
    [System.Drawing.ColorTranslator]::FromHtml("#edbb99"),`
    [System.Drawing.ColorTranslator]::FromHtml("#f1c40f"),`
    [System.Drawing.ColorTranslator]::FromHtml("#abebc6"),` #vert clair 'pop'
    [System.Drawing.ColorTranslator]::FromHtml("#196f3d"),`
    [System.Drawing.ColorTranslator]::FromHtml("#73c6b6"),`
    [System.Drawing.ColorTranslator]::FromHtml("#aed6f1"),`
    [System.Drawing.ColorTranslator]::FromHtml("#5f6a6a"),` #gris fonc�
    [System.Drawing.ColorTranslator]::FromHtml("#154360"),`
    [System.Drawing.ColorTranslator]::FromHtml("#f5b7b1"),`
    [System.Drawing.ColorTranslator]::FromHtml("#922b21")
 
    $Chart.PaletteCustomColors = ($CustomColorPalette)

    ## Title
    [void]$chart.Titles.Add($PSBoundParameters["Title"])
    $Chart.Titles["Title1"].alignment = "TopCenter"

    ## Create a ChartArea to draw on and add to chart
    $ChartArea = New-Object System.Windows.Forms.DataVisualization.Charting.ChartArea
    $ChartArea.Name = "chart"

    ## 3D or not
    If($PSBoundParameters["ThreeDimension"])
    {
        $ChartArea.Area3DStyle.Enable3D    = $True
        $ChartArea.Area3DStyle.Inclination = 25
        $ChartArea.Area3DStyle.LightStyle  = "Realistic"
    }
    
    ## Add ChartArea to chart
    $Chart.ChartAreas.Add($ChartArea)

    ## Legend configuration
    $legend = New-Object system.Windows.Forms.DataVisualization.Charting.Legend
    $legend.name                      = "Legend1"
    $legend.LegendStyle               = "Table"
    $legend.Alignment                 = "Center"
    $legend.Title                     = $PSBoundParameters["LegendTitle"]
    $legend.TitleAlignment            = "Near"
    $chart.Legends.Add($legend)
    $chart.Legends["Legend1"].docking = "Bottom"
   
    ## Add data to chart
    [void]$Chart.Series.Add("Data")
    
    ### $x = @{a=@{point=12;color=[System.Drawing.ColorTranslator]::FromHtml("#3ce74c")}}

    ## If the input hashtable contains  2 properties for a give key..., else use normal behavior
    ## To fix the color use the above example, and make sure the inner properties are named 'color' and 'point'
    If ( ($PSBoundParameters["hash"].GetEnumerator() | select-object -first 1).value.count -eq 2 ) {

        Foreach ( $Point in $PSBoundParameters["hash"].GetEnumerator() ) {
            
            $NewDataPoint = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.DataPoint
            $NewDataPoint.SetValueXY( $Point.Name, $Point.Value['point'])
            $NewDataPoint.Color = $Point.Value['color']
            $Chart.Series["Data"].Points.Add($NewDataPoint)

        }
        $Chart.Series["Data"].LegendText = "#AXISLABEL"

    } Else {

        $Chart.Series['Data'].Points.DataBindXY($PSBoundParameters['hash'].Keys, $PSBoundParameters['hash'].Values)
        $Chart.Series["Data"].LegendText = "#VALX"
        
    }

    $Chart.Series["Data"].ChartType          = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::Doughnut
    $Chart.Series["Data"]["PieLabelStyle"]   = "Outside"
    $Chart.Series["Data"]["DoughnutRadius"]  = $PSBoundParameters["Radius"]
    $Chart.Series["Data"]["PieDrawingStyle"] = $PSBoundParameters["DrawingStyle"]
    $Chart.Series["Data"]["PieStartAngle"]   = $PSBoundParameters["StartAngle"]
    $Chart.Series["Data"].label              = "#VALY$($PSBoundParameters["unite"])"
    
    $Chart.Series["Data"]["PieLineColor"]    = "Black"
    $Chart.Series["Data"]["3DLabelLineSize"] = 31
    $Chart.Series["Data"].BorderColor        = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
    $Chart.Series["Data"].BorderColor        = 0

    #Return $Chart

    ## Save chart as image
    $Chart.SaveImage($PSBoundParameters["path"],"png")
}
