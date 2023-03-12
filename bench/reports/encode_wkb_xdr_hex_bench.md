Encode WKB (XDR/hex)

Benchmark run from 2023-03-11 07:36:43.679655Z UTC

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
    <td style="white-space: nowrap">1.14.3</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">25.2.3</td>
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
    <td style="white-space: nowrap; text-align: right">2.19 K</td>
    <td style="white-space: nowrap; text-align: right">456.89 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;23.80%</td>
    <td style="white-space: nowrap; text-align: right">429.62 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">776.21 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.83 K</td>
    <td style="white-space: nowrap; text-align: right">546.75 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;18.61%</td>
    <td style="white-space: nowrap; text-align: right">519.82 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">820.90 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">2.19 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.83 K</td>
    <td style="white-space: nowrap; text-align: right">1.2x</td>
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
    <td style="white-space: nowrap">296.91 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">468.79 KB</td>
    <td>1.58x</td>
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
    <td style="white-space: nowrap; text-align: right">1.09 K</td>
    <td style="white-space: nowrap; text-align: right">0.91 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.96%</td>
    <td style="white-space: nowrap; text-align: right">0.90 ms</td>
    <td style="white-space: nowrap; text-align: right">1.05 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.94 K</td>
    <td style="white-space: nowrap; text-align: right">1.06 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8.33%</td>
    <td style="white-space: nowrap; text-align: right">1.07 ms</td>
    <td style="white-space: nowrap; text-align: right">1.27 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.09 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.94 K</td>
    <td style="white-space: nowrap; text-align: right">1.16x</td>
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
    <td style="white-space: nowrap">0.72 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">1.08 MB</td>
    <td>1.51x</td>
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
    <td style="white-space: nowrap; text-align: right">47.27</td>
    <td style="white-space: nowrap; text-align: right">21.15 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.60%</td>
    <td style="white-space: nowrap; text-align: right">21.14 ms</td>
    <td style="white-space: nowrap; text-align: right">21.81 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">41.33</td>
    <td style="white-space: nowrap; text-align: right">24.19 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.44%</td>
    <td style="white-space: nowrap; text-align: right">24.20 ms</td>
    <td style="white-space: nowrap; text-align: right">24.50 ms</td>
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
    <td style="white-space: nowrap;text-align: right">47.27</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">41.33</td>
    <td style="white-space: nowrap; text-align: right">1.14x</td>
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
    <td style="white-space: nowrap">12.53 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">21.77 MB</td>
    <td>1.74x</td>
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
    <td style="white-space: nowrap; text-align: right">409.45</td>
    <td style="white-space: nowrap; text-align: right">2.44 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2.93%</td>
    <td style="white-space: nowrap; text-align: right">2.46 ms</td>
    <td style="white-space: nowrap; text-align: right">2.65 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">303.95</td>
    <td style="white-space: nowrap; text-align: right">3.29 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10.05%</td>
    <td style="white-space: nowrap; text-align: right">3.48 ms</td>
    <td style="white-space: nowrap; text-align: right">3.65 ms</td>
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
    <td style="white-space: nowrap;text-align: right">409.45</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">303.95</td>
    <td style="white-space: nowrap; text-align: right">1.35x</td>
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
    <td style="white-space: nowrap">1.67 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">2.92 MB</td>
    <td>1.75x</td>
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
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">417.22</td>
    <td style="white-space: nowrap; text-align: right">2.40 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.74%</td>
    <td style="white-space: nowrap; text-align: right">2.40 ms</td>
    <td style="white-space: nowrap; text-align: right">2.50 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">323.79</td>
    <td style="white-space: nowrap; text-align: right">3.09 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.60%</td>
    <td style="white-space: nowrap; text-align: right">3.07 ms</td>
    <td style="white-space: nowrap; text-align: right">3.22 ms</td>
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
    <td style="white-space: nowrap;text-align: right">417.22</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">323.79</td>
    <td style="white-space: nowrap; text-align: right">1.29x</td>
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
    <td style="white-space: nowrap">1.57 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">4.25 MB</td>
    <td>2.71x</td>
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
    <td style="white-space: nowrap; text-align: right">47.96</td>
    <td style="white-space: nowrap; text-align: right">20.85 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.71%</td>
    <td style="white-space: nowrap; text-align: right">20.83 ms</td>
    <td style="white-space: nowrap; text-align: right">21.81 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">39.76</td>
    <td style="white-space: nowrap; text-align: right">25.15 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.51%</td>
    <td style="white-space: nowrap; text-align: right">25.13 ms</td>
    <td style="white-space: nowrap; text-align: right">25.48 ms</td>
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
    <td style="white-space: nowrap;text-align: right">47.96</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">39.76</td>
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
    <td style="white-space: nowrap">13.81 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">25.27 MB</td>
    <td>1.83x</td>
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
    <td style="white-space: nowrap; text-align: right">47.10</td>
    <td style="white-space: nowrap; text-align: right">21.23 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.26%</td>
    <td style="white-space: nowrap; text-align: right">21.22 ms</td>
    <td style="white-space: nowrap; text-align: right">21.42 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">37.91</td>
    <td style="white-space: nowrap; text-align: right">26.38 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.98%</td>
    <td style="white-space: nowrap; text-align: right">26.33 ms</td>
    <td style="white-space: nowrap; text-align: right">27.05 ms</td>
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
    <td style="white-space: nowrap;text-align: right">47.10</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">37.91</td>
    <td style="white-space: nowrap; text-align: right">1.24x</td>
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
    <td style="white-space: nowrap">15.11 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">29.01 MB</td>
    <td>1.92x</td>
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
    <td style="white-space: nowrap; text-align: right">7.32 K</td>
    <td style="white-space: nowrap; text-align: right">136.56 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.65%</td>
    <td style="white-space: nowrap; text-align: right">135.04 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">158.46 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">6.95 K</td>
    <td style="white-space: nowrap; text-align: right">143.95 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8.98%</td>
    <td style="white-space: nowrap; text-align: right">140.46 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">187.41 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">7.32 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">6.95 K</td>
    <td style="white-space: nowrap; text-align: right">1.05x</td>
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
    <td style="white-space: nowrap">114.84 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">176.60 KB</td>
    <td>1.54x</td>
  </tr>
</table>