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
Then pass the three ordered hastables to New-LineCHartImage by using the -Hash parameter, or by using the pipeline (second example). The below command will generate .png file in your current directory
```powershell
New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Hash $OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 -Title 'I am a Title' -Legend -LegendTitle 'I am a LegendTitle' -LegendText 'FirstHash','SecondHash','ThirdHash'
```
```powershell
$OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 | New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Title 'I am a Title' -Legend -LegendTitle 'I am a LegendTitle' -LegendText 'FirstHash','SecondHash','ThirdHash'
```

![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/LineChartFromThePipeLine.png)


# New-PieChartImage
-New-LineChartImage, usage example(s):

Create a hashtable containing your key/value pair
```powershell
$HashTable = @{a=12;b=150;x=71}
```
Then pass the hashtable to the -Hash parameter, use the -Unite parameter to describe your data. Using the -Radius parameter, or using the -ThreeDimension switch will change the look of the resuling pie chart. The below command will generate .png file in your current directory
```powershell
New-PieChartImage -Hash $HashTable -Titre "Title" -TitreLegende "Legend" -Path $PWD\PieChartExample1.png -Unite 'patates' -ThreeDimension -Radius 99
```
```powershell
New-PieChartImage -Hash $HashTable -Titre "Title" -TitreLegende "Legend" -Path $PWD\PieChartExample2.png -Unite 'patates' -ThreeDimension -Radius 25
```

![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/PieChartExample1.png)
![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/PieChartExample2.png)

# Note(s)
- Colors are randomly picked. Maybe i can find a way to make sure it's picked in a certain order.
- I personally using these functions to created daily mail report.
