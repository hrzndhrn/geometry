Decode WKB (NDR/bin)

Benchmark run from 2025-06-25 05:24:35.272036Z UTC

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
    <td style="white-space: nowrap; text-align: right">16.71 K</td>
    <td style="white-space: nowrap; text-align: right">59.83 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;33.25%</td>
    <td style="white-space: nowrap; text-align: right">52.00 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">129.16 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">10.84 K</td>
    <td style="white-space: nowrap; text-align: right">92.24 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9.06%</td>
    <td style="white-space: nowrap; text-align: right">92.20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">107.70 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">16.71 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">10.84 K</td>
    <td style="white-space: nowrap; text-align: right">1.54x</td>
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
    <td style="white-space: nowrap">210.94 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">281.25 KB</td>
    <td>1.33x</td>
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
    <td style="white-space: nowrap; text-align: right">2.63 K</td>
    <td style="white-space: nowrap; text-align: right">379.82 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;12.07%</td>
    <td style="white-space: nowrap; text-align: right">369.82 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">485.82 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.44 K</td>
    <td style="white-space: nowrap; text-align: right">693.19 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10.43%</td>
    <td style="white-space: nowrap; text-align: right">686.23 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">894.47 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">2.63 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.44 K</td>
    <td style="white-space: nowrap; text-align: right">1.83x</td>
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
    <td style="white-space: nowrap">1.11 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">1.79 MB</td>
    <td>1.62x</td>
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
    <td style="white-space: nowrap; text-align: right">102.77</td>
    <td style="white-space: nowrap; text-align: right">9.73 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;15.37%</td>
    <td style="white-space: nowrap; text-align: right">9.18 ms</td>
    <td style="white-space: nowrap; text-align: right">13.47 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">62.54</td>
    <td style="white-space: nowrap; text-align: right">15.99 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;11.55%</td>
    <td style="white-space: nowrap; text-align: right">16.20 ms</td>
    <td style="white-space: nowrap; text-align: right">18.76 ms</td>
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
    <td style="white-space: nowrap;text-align: right">102.77</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">62.54</td>
    <td style="white-space: nowrap; text-align: right">1.64x</td>
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
    <td style="white-space: nowrap">24.76 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">40.25 MB</td>
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
    <td style="white-space: nowrap; text-align: right">897.84</td>
    <td style="white-space: nowrap; text-align: right">1.11 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9.50%</td>
    <td style="white-space: nowrap; text-align: right">1.11 ms</td>
    <td style="white-space: nowrap; text-align: right">1.37 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">480.77</td>
    <td style="white-space: nowrap; text-align: right">2.08 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.73%</td>
    <td style="white-space: nowrap; text-align: right">2.12 ms</td>
    <td style="white-space: nowrap; text-align: right">2.19 ms</td>
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
    <td style="white-space: nowrap;text-align: right">897.84</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">480.77</td>
    <td style="white-space: nowrap; text-align: right">1.87x</td>
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
    <td style="white-space: nowrap">3.07 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">5.17 MB</td>
    <td>1.68x</td>
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
    <td style="white-space: nowrap; text-align: right">907.91</td>
    <td style="white-space: nowrap; text-align: right">1.10 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8.64%</td>
    <td style="white-space: nowrap; text-align: right">1.15 ms</td>
    <td style="white-space: nowrap; text-align: right">1.24 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">879.02</td>
    <td style="white-space: nowrap; text-align: right">1.14 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.16%</td>
    <td style="white-space: nowrap; text-align: right">1.14 ms</td>
    <td style="white-space: nowrap; text-align: right">1.17 ms</td>
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
    <td style="white-space: nowrap;text-align: right">907.91</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">879.02</td>
    <td style="white-space: nowrap; text-align: right">1.03x</td>
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
    <td style="white-space: nowrap">2.87 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">3.24 MB</td>
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
    <td style="white-space: nowrap; text-align: right">99.16</td>
    <td style="white-space: nowrap; text-align: right">10.09 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13.60%</td>
    <td style="white-space: nowrap; text-align: right">9.74 ms</td>
    <td style="white-space: nowrap; text-align: right">14.78 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">55.96</td>
    <td style="white-space: nowrap; text-align: right">17.87 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;14.90%</td>
    <td style="white-space: nowrap; text-align: right">17.58 ms</td>
    <td style="white-space: nowrap; text-align: right">21.80 ms</td>
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
    <td style="white-space: nowrap;text-align: right">99.16</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">55.96</td>
    <td style="white-space: nowrap; text-align: right">1.77x</td>
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
    <td style="white-space: nowrap">26.89 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">44.98 MB</td>
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
    <td style="white-space: nowrap; text-align: right">80.96</td>
    <td style="white-space: nowrap; text-align: right">12.35 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.56%</td>
    <td style="white-space: nowrap; text-align: right">12.34 ms</td>
    <td style="white-space: nowrap; text-align: right">12.98 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">56.31</td>
    <td style="white-space: nowrap; text-align: right">17.76 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;7.98%</td>
    <td style="white-space: nowrap; text-align: right">18.52 ms</td>
    <td style="white-space: nowrap; text-align: right">19.86 ms</td>
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
    <td style="white-space: nowrap;text-align: right">80.96</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">56.31</td>
    <td style="white-space: nowrap; text-align: right">1.44x</td>
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
    <td style="white-space: nowrap">29.33 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">50.56 MB</td>
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
    <td style="white-space: nowrap; text-align: right">20.80 K</td>
    <td style="white-space: nowrap; text-align: right">48.08 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;22.02%</td>
    <td style="white-space: nowrap; text-align: right">49.37 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">84.62 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">13.55 K</td>
    <td style="white-space: nowrap; text-align: right">73.79 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;21.16%</td>
    <td style="white-space: nowrap; text-align: right">71.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">141.39 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">20.80 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">13.55 K</td>
    <td style="white-space: nowrap; text-align: right">1.53x</td>
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
    <td style="white-space: nowrap">196.09 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">264.06 KB</td>
    <td>1.35x</td>
  </tr>
</table>