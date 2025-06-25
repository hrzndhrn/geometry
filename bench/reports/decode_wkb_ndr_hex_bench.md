Decode WKB (NDR/hex)

Benchmark run from 2025-06-25 05:22:10.964184Z UTC

## System

Benchmark suite executing on the following system:

<table style="width: 1%">
  <tr>
    <th style="width: 1%; white-space: nowrap">Operating System</th>
    <td>macOS</td>
  </tr><tr>
    <th style="white-space: nowrap">CPU Information</th>
    <td style="white-space: nowrap">Apple M1</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.18.4</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">28.0</td>
  </tr>
</table>

## Configuration

Benchmark suite executing with the following configuration:

<table style="width: 1%">
  <tr>
    <th style="width: 1%">:time</th>
    <td style="white-space: nowrap">5 s</td>
  </tr><tr>
    <th>:parallel</th>
    <td style="white-space: nowrap">1</td>
  </tr><tr>
    <th>:warmup</th>
    <td style="white-space: nowrap">2 s</td>
  </tr>
</table>

## Statistics



__Input: (1) Point__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.00 K</td>
    <td style="white-space: nowrap; text-align: right">500.65 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6.02%</td>
    <td style="white-space: nowrap; text-align: right">500.03 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">577.26 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.73 K</td>
    <td style="white-space: nowrap; text-align: right">576.41 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.51%</td>
    <td style="white-space: nowrap; text-align: right">573.07 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">653.38 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">2.00 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.73 K</td>
    <td style="white-space: nowrap; text-align: right">1.15x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">312.50 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">484.38 KB</td>
    <td>1.55x</td>
  </tr>
</table>



__Input: (2) LineString__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">816.39</td>
    <td style="white-space: nowrap; text-align: right">1.22 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.21%</td>
    <td style="white-space: nowrap; text-align: right">1.22 ms</td>
    <td style="white-space: nowrap; text-align: right">1.32 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">649.38</td>
    <td style="white-space: nowrap; text-align: right">1.54 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.17%</td>
    <td style="white-space: nowrap; text-align: right">1.55 ms</td>
    <td style="white-space: nowrap; text-align: right">1.63 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">816.39</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">649.38</td>
    <td style="white-space: nowrap; text-align: right">1.26x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">1.21 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">1.97 MB</td>
    <td>1.63x</td>
  </tr>
</table>



__Input: (3) LineString (long)__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">32.90</td>
    <td style="white-space: nowrap; text-align: right">30.40 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.58%</td>
    <td style="white-space: nowrap; text-align: right">30.16 ms</td>
    <td style="white-space: nowrap; text-align: right">34.27 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">27.21</td>
    <td style="white-space: nowrap; text-align: right">36.75 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.08%</td>
    <td style="white-space: nowrap; text-align: right">37.15 ms</td>
    <td style="white-space: nowrap; text-align: right">39.37 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">32.90</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">27.21</td>
    <td style="white-space: nowrap; text-align: right">1.21x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">24.86 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">40.42 MB</td>
    <td>1.63x</td>
  </tr>
</table>



__Input: (4) Polygon__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">329.55</td>
    <td style="white-space: nowrap; text-align: right">3.03 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.48%</td>
    <td style="white-space: nowrap; text-align: right">3.04 ms</td>
    <td style="white-space: nowrap; text-align: right">3.29 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">230.17</td>
    <td style="white-space: nowrap; text-align: right">4.34 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.55%</td>
    <td style="white-space: nowrap; text-align: right">4.33 ms</td>
    <td style="white-space: nowrap; text-align: right">4.49 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">329.55</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">230.17</td>
    <td style="white-space: nowrap; text-align: right">1.43x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">3.17 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">5.35 MB</td>
    <td>1.69x</td>
  </tr>
</table>



__Input: (5) MultiPoint__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">265.98</td>
    <td style="white-space: nowrap; text-align: right">3.76 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2.99%</td>
    <td style="white-space: nowrap; text-align: right">3.79 ms</td>
    <td style="white-space: nowrap; text-align: right">4.00 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">263.35</td>
    <td style="white-space: nowrap; text-align: right">3.80 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.32%</td>
    <td style="white-space: nowrap; text-align: right">3.80 ms</td>
    <td style="white-space: nowrap; text-align: right">3.90 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap;text-align: right">265.98</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">263.35</td>
    <td style="white-space: nowrap; text-align: right">1.01x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">2.89 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">3.25 MB</td>
    <td>1.13x</td>
  </tr>
</table>



__Input: (6) MultiLineString__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">30.19</td>
    <td style="white-space: nowrap; text-align: right">33.13 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.98%</td>
    <td style="white-space: nowrap; text-align: right">33.22 ms</td>
    <td style="white-space: nowrap; text-align: right">36.31 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">25.76</td>
    <td style="white-space: nowrap; text-align: right">38.83 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6.92%</td>
    <td style="white-space: nowrap; text-align: right">38.78 ms</td>
    <td style="white-space: nowrap; text-align: right">43.00 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">30.19</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">25.76</td>
    <td style="white-space: nowrap; text-align: right">1.17x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">26.90 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">45.00 MB</td>
    <td>1.67x</td>
  </tr>
</table>



__Input: (7) MultiPolygon__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">30.55</td>
    <td style="white-space: nowrap; text-align: right">32.73 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.11%</td>
    <td style="white-space: nowrap; text-align: right">32.45 ms</td>
    <td style="white-space: nowrap; text-align: right">59.91 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">26.53</td>
    <td style="white-space: nowrap; text-align: right">37.70 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.04%</td>
    <td style="white-space: nowrap; text-align: right">38.43 ms</td>
    <td style="white-space: nowrap; text-align: right">40.24 ms</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">30.55</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">26.53</td>
    <td style="white-space: nowrap; text-align: right">1.15x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">29.34 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">50.58 MB</td>
    <td>1.72x</td>
  </tr>
</table>



__Input: (8) GeometryCollection__

Run Time

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Devitation</th>
    <th style="text-align: right">Median</th>
    <th style="text-align: right">99th&nbsp;%</th>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">5.85 K</td>
    <td style="white-space: nowrap; text-align: right">170.90 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10.48%</td>
    <td style="white-space: nowrap; text-align: right">166.91 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">232.57 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">4.80 K</td>
    <td style="white-space: nowrap; text-align: right">208.27 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10.03%</td>
    <td style="white-space: nowrap; text-align: right">206.12 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">295.12 &micro;s</td>
  </tr>

</table>


Run Time Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">5.85 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">4.80 K</td>
    <td style="white-space: nowrap; text-align: right">1.22x</td>
  </tr>

</table>



Memory Usage

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">Average</th>
    <th style="text-align: right">Factor</th>
  </tr>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">206.25 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">282.03 KB</td>
    <td>1.37x</td>
  </tr>
</table>