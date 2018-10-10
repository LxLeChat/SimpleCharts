# SimpleCharts
Basic Charting functions for Powershell.
Create png files
You provide, one or more Ordered Hashtable

# New-LineChartImage
-New-LineChartImage, usage example(s):
Create 3 ordered Hashtables, for coherence, keys should be the same accros hashtables.
```powershell
$OrderedHashtable1 = [Ordered]@{a=3;b=8;c=6}
$OrderedHashtable2 = [Ordered]@{a=5;b=2;c=10}
$OrderedHashtable3 = [Ordered]@{a=3;b=12}
```
Then pass the three hastables to the New-LineCHartImage
```powershell
New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Hash $OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 -Title 'I am a Title' -Legend -LegendTitle 'I am a LegendTitle' -LegendText 'FirstHash','SecondHash','ThirdHash'
```
```powershell
$OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 | New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Title 'I am a Title' -Legend -LegendTitle 'I am a LegendTitle' -LegendText 'FirstHash','SecondHash','ThirdHash'
```

![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/LineChartFromThePipeLine.png)


# New-PieChartImage
-New-LineChartImage, usage example(s):
```powershell
New-PieChartImage -Hash $hash -Titre "Title" -TitreLegende "Legend" -Path $PWD\PieChartExample1.png -Unite 'patates' -ThreeDimension -Radius 99
```
```powershell
New-PieChartImage -Hash $hash -Titre "Title" -TitreLegende "Legend" -Path $PWD\PieChartExample2.png -Unite 'patates' -ThreeDimension -Radius 25
```

![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/PieChartExample1.png)
![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/PieChartExample2.png)

