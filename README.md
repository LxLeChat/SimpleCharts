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
New-PieChartImage -Hash $HashTable -Title "Title" -LegendTile "Legend" -Path $PWD\PieChartExample1.png -Unite 'patates' -ThreeDimension -Radius 99
```
```powershell
New-PieChartImage -Hash $HashTable -Title "Title" -LegendTile "Legend" -Path $PWD\PieChartExample2.png -Unite 'patates' -ThreeDimension -Radius 25
```

![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/PieChartExample1.png)
![Image of New-LineChartImage](https://github.com/LxLeChat/Invoke-Charts/blob/master/PieChartExample2.png)

You can create a more complex hashtable, to specify the exact color of each data point. For each key, you must providea hastable, with the following key/value pair: ```@{color=[system.drawing.color];point=[int]}```
```powershell
$MoreCompleHashtable = @{
  a = @{
    color = [System.Drawing.ColorTranslator]::FromHtml("#34495e")
    point = 12
  }
  b = @{
    color = [System.Drawing.ColorTranslator]::FromHtml("#abebc6")
    point = 150
  }
  x = @{
    color =[System.Drawing.ColorTranslator]::FromHtml("#922b21")
    point = 71
  }
}
```
Make sure the you use "color" and "point"!

# Fairly long example:
Lets say you want to render your disk size as pie chart and you want to save this in a png file.. (i know, i know..)
Let's first grab your disk size from wmi and transform the data in a human comprehensible way.. Charts, to my knowledge accepts only ints, no double, that's why i rounded freespace and usedspace to 0:
```powershell
$a = get-WmiObject win32_logicaldisk | select deviceid,@{l='TotalSize';e={[Math]::Round($($_.size/1GB),0)}},@{l='FreeSpace';e={[Math]::Round($($_.freespace/1GB),0)}},@{l='UsedSpace';e={[Math]::Round((($_.size-$_.freespace)/1gb),0)}}

deviceid TotalSize FreeSpace UsedSpace
-------- --------- --------- ---------
C:             464       390        74
```
Now me must create a new hashtable (not ordered since we will be outputing a PIE) containing the UsedSpace and FreeSpace
```powershell
$DiskData = @{FreeSpace=[int]$($a.FreeSpace);UsedSpace=[int]$($a.UsedSpace)}

Name                           Value                               
----                           -----                               
UsedSpace                      74                              
FreeSpace                      390
```
We know have the DiskData variable we can feed to New-PieChartImage
```powershell
New-PieChartImage -Hash $DiskData -Title "$($a.DeviceId) Size Report, size: $($a.TotalSize) GB" -Unite ' Gb' -Path $PWD\disk_c.png -Radius 99
```
And voila!
![DiskSize](https://github.com/LxLeChat/SimpleCharts/blob/master/disk_c.png)

# Note(s)
- Colors are randomly picked. Maybe i can find a way to make sure it's picked in a certain order.
- I personally using these functions to created daily mail report.
