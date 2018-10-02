# Invoke-Charts
Basic Charting functions for Powershell.
Create png files
You provide, one or more Ordered Hashtable

-New-LineChartImage, usage example(s):
>New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Hash $OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 -Title "I am aTitle" -Legend -LegendTitle 'I am a LegendTitle' -LegendText "FirstHash","SecondHash","ThirdHash"

>$OrderedHashtable1,$OrderedHashtable2,$OrderedHashtable3 | New-LineChartImage -Path $pwd\LineChartFromThePipeLine.png -Title "I am aTitle" -Legend -LegendTitle 'I am a LegendTitle' -LegendText "FirstHash","SecondHash","ThirdHash"


