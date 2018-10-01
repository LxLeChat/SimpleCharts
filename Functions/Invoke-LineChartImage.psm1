Function Invoke-LineChartImage{
    [cmdletbinding()]
    param(
        [parameter(Mandatory=$True)]
        [ValidateScript({If($_.gettype().toString() -eq "System.Collections.Specialized.OrderedDictionary"){$True}Else{Throw "You must provide an ordered HashTable, `$hash=@{""a""=1;""b""=2} "}})]
        $Hash,
        [String]$Path,
        [String]$Title,
        [Int]$Width,
        [Int]$Height,
        [String]$Color,
        [Switch]$Legend,
        [String]$LegendTitle,
        [String]$LegendText
    )

    ## Test & Define default value For Width
    If ( $null -eq $PSBoundParameters['Width'] ) {
        $PSBoundParameters.Add('Width',500)
    }

    ## Test & Define default value For Height
    If ( $null -eq $PSBoundParameters['Height'] ) {
        $PSBoundParameters.Add('Height',250)
    }

    ## Test & Define default value For Color
    If ( $null -eq $PSBoundParameters['Color'] ) {
        $PSBoundParameters.Add('Color','#58d68d')
    }

    ## Test & Define default value For Title
    If ( $null -eq $PSBoundParameters['Title'] ) {
        $PSBoundParameters.Add('Title','Default Title')
    }

    ## Test & Define default value For Title
    If ( $null -eq $PSBoundParameters['LegendTitle'] ) {
        $PSBoundParameters.Add('LegendTitle','Default Legend Title')
    }

    ## Test & Define default value For LegendText
    If ( $null -eq $PSBoundParameters['LegendText'] ) {
        $PSBoundParameters.Add('LegendText',"This is a Legend")
    }
    

    ## Test Path, if root directory doest exist, return nothing, for the moment..
    Try {
        If ( !(Test-Path -Path ([System.IO.FileInfo]$PSBoundParameters["Path"]).Directory.FullName) ) {
            Throw "Invalid Path..."
        }
    } Catch {
        Return $PSItem
    }

    ## Load necessary assemblies
    Try {
        Add-Type -AssemblyName System.Windows.Forms, System.Windows.Forms.DataVisualization -ErrorAction Stop
    } Catch {
        Return $PSItem
    }

    ## Create Chart Object
    $Chart              = New-object -TypeName System.Windows.Forms.DataVisualization.Charting.Chart
    $Chart.Width        = $PSBoundParameters['Width']
    $Chart.Height       = $PSBoundParameters['Height']
    $Chart.Left         = 0
    $Chart.Top          = 0
    
    ## Titre
    [void]$chart.Titles.Add($PSBoundParameters['Title'])
    $Chart.Titles["Title1"].alignment = "TopCenter"

    ## Create a ChartArea to draw on and add to chart
    $ChartArea                           = New-Object -TypeName System.Windows.Forms.DataVisualization.Charting.ChartArea
    $ChartArea.Name                      = "chart"
    $ChartArea.AxisX.LabelStyle.Angle    = -90
    $chartarea.AxisX.IsLabelAutoFit      = $False
    $ChartArea.AxisX.IsMarginVisible     = $False
    $ChartArea.AxisX.MajorGrid.LineColor = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
    $ChartArea.AxisX.LineColor           = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
    $ChartArea.AxisY.MajorGrid.LineColor = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")
    $ChartArea.AxisY.LineColor           = [System.Drawing.ColorTranslator]::FromHtml("#d5dbdb")

    ## Add ChartArea to chart
    $Chart.ChartAreas.Add($ChartArea)

    ## Add Legend
    If( $PSBoundParameters['Legend'].isPresent ) {
        $legendHuss                           = New-Object -TypeName system.Windows.Forms.DataVisualization.Charting.Legend
        $legendHuss.name                      = "Legend1"
        $legendHuss.LegendStyle               = "Table"
        $legendHuss.Alignment                 = "Center"
        $legendHuss.Title                     = $PSBoundParameters['LegendTitle']
        $legendHuss.TitleAlignment            = "Near"

        $chart.Legends.Add($legendHuss)

        $chart.Legends["Legend1"].docking = "Bottom"
    }
   
    ## Create new serie and add it to the chart series
    [void]$Chart.Series.Add("Data")
    
    ## Configure Series
    $Chart.Series["Data"].Points.DataBindXY($PSBoundParameters["hash"].Keys, $PSBoundParameters["hash"].Values)
    $Chart.Series["Data"].ChartType         = [System.Windows.Forms.DataVisualization.Charting.SeriesChartType]::SplineArea
    $Chart.Series["Data"]["LineTension"]    = "0.295"
    $Chart.Series["Data"].label             = "#VALY"
    $Chart.Series["Data"]["LabelStyle"]     = "Top"
    $Chart.Series["Data"].LegendText        = $PSBoundParameters['LegendText']
    $Chart.Series["Data"].Color             = [System.Drawing.ColorTranslator]::FromHtml($color)
    $Chart.Series["Data"].MarkerSize        = 10
    $Chart.Series["Data"].MarkerStyle       = [System.Windows.Forms.DataVisualization.Charting.MarkerStyle]::Star4
    $Chart.Series["Data"].MarkerColor       = [System.Drawing.ColorTranslator]::FromHtml($Color)
    $Chart.Series["Data"].MarkerBorderColor = [System.Drawing.ColorTranslator]::FromHtml("#616161")

    #return $Chart

    ## Save chart as image
    Try {
        $Chart.SaveImage($($PSBoundParameters["path"]),"png")
        [System.IO.FileInfo]$PSBoundParameters['path'] | Select-Object Mode,LastWriteTime,Name,FullName
    } Catch {
        $_
    }
}
