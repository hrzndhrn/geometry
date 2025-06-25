Decode WKT

Benchmark run from 2025-06-25 05:02:54.562352Z UTC

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
    <td style="white-space: nowrap; text-align: right">1.40 K</td>
    <td style="white-space: nowrap; text-align: right">0.72 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6.24%</td>
    <td style="white-space: nowrap; text-align: right">0.71 ms</td>
    <td style="white-space: nowrap; text-align: right">0.83 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.155 K</td>
    <td style="white-space: nowrap; text-align: right">6.46 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.90%</td>
    <td style="white-space: nowrap; text-align: right">6.43 ms</td>
    <td style="white-space: nowrap; text-align: right">6.68 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.40 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.155 K</td>
    <td style="white-space: nowrap; text-align: right">9.02x</td>
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
    <td style="white-space: nowrap">3.23 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">1.56 MB</td>
    <td>0.48x</td>
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
    <td style="white-space: nowrap; text-align: right">575.48</td>
    <td style="white-space: nowrap; text-align: right">1.74 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.01%</td>
    <td style="white-space: nowrap; text-align: right">1.74 ms</td>
    <td style="white-space: nowrap; text-align: right">1.79 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">48.58</td>
    <td style="white-space: nowrap; text-align: right">20.58 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.64%</td>
    <td style="white-space: nowrap; text-align: right">20.54 ms</td>
    <td style="white-space: nowrap; text-align: right">20.98 ms</td>
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
    <td style="white-space: nowrap;text-align: right">575.48</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">48.58</td>
    <td style="white-space: nowrap; text-align: right">11.85x</td>
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
    <td style="white-space: nowrap">7.25 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">8.92 MB</td>
    <td>1.23x</td>
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
    <td style="white-space: nowrap; text-align: right">34.14</td>
    <td style="white-space: nowrap; text-align: right">29.29 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.53%</td>
    <td style="white-space: nowrap; text-align: right">29.28 ms</td>
    <td style="white-space: nowrap; text-align: right">30.04 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.55</td>
    <td style="white-space: nowrap; text-align: right">644.37 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.41%</td>
    <td style="white-space: nowrap; text-align: right">645.18 ms</td>
    <td style="white-space: nowrap; text-align: right">646.88 ms</td>
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
    <td style="white-space: nowrap;text-align: right">34.14</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.55</td>
    <td style="white-space: nowrap; text-align: right">22.0x</td>
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
    <td style="white-space: nowrap">178.31 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">301.52 MB</td>
    <td>1.69x</td>
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
    <td style="white-space: nowrap; text-align: right">288.73</td>
    <td style="white-space: nowrap; text-align: right">3.46 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;7.35%</td>
    <td style="white-space: nowrap; text-align: right">3.29 ms</td>
    <td style="white-space: nowrap; text-align: right">3.99 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">14.88</td>
    <td style="white-space: nowrap; text-align: right">67.22 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.23%</td>
    <td style="white-space: nowrap; text-align: right">67.44 ms</td>
    <td style="white-space: nowrap; text-align: right">69.16 ms</td>
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
    <td style="white-space: nowrap;text-align: right">288.73</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">14.88</td>
    <td style="white-space: nowrap; text-align: right">19.41x</td>
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
    <td style="white-space: nowrap">20.52 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">45.21 MB</td>
    <td>2.2x</td>
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
    <td style="white-space: nowrap; text-align: right">307.74</td>
    <td style="white-space: nowrap; text-align: right">3.25 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;11.88%</td>
    <td style="white-space: nowrap; text-align: right">3.04 ms</td>
    <td style="white-space: nowrap; text-align: right">4.08 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">15.27</td>
    <td style="white-space: nowrap; text-align: right">65.51 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.02%</td>
    <td style="white-space: nowrap; text-align: right">65.55 ms</td>
    <td style="white-space: nowrap; text-align: right">66.99 ms</td>
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
    <td style="white-space: nowrap;text-align: right">307.74</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">15.27</td>
    <td style="white-space: nowrap; text-align: right">20.16x</td>
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
    <td style="white-space: nowrap">18.57 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">30.06 MB</td>
    <td>1.62x</td>
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
    <td style="white-space: nowrap; text-align: right">32.93</td>
    <td style="white-space: nowrap; text-align: right">30.37 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.26%</td>
    <td style="white-space: nowrap; text-align: right">30.32 ms</td>
    <td style="white-space: nowrap; text-align: right">33.00 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.42</td>
    <td style="white-space: nowrap; text-align: right">704.08 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.39%</td>
    <td style="white-space: nowrap; text-align: right">704.67 ms</td>
    <td style="white-space: nowrap; text-align: right">708.43 ms</td>
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
    <td style="white-space: nowrap;text-align: right">32.93</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.42</td>
    <td style="white-space: nowrap; text-align: right">23.19x</td>
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
    <td style="white-space: nowrap">182.74 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">486.30 MB</td>
    <td>2.66x</td>
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
    <td style="white-space: nowrap; text-align: right">32.85</td>
    <td style="white-space: nowrap; text-align: right">30.44 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.52%</td>
    <td style="white-space: nowrap; text-align: right">30.43 ms</td>
    <td style="white-space: nowrap; text-align: right">31.21 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.39</td>
    <td style="white-space: nowrap; text-align: right">720.42 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.23%</td>
    <td style="white-space: nowrap; text-align: right">720.35 ms</td>
    <td style="white-space: nowrap; text-align: right">722.35 ms</td>
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
    <td style="white-space: nowrap;text-align: right">32.85</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.39</td>
    <td style="white-space: nowrap; text-align: right">23.67x</td>
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
    <td style="white-space: nowrap">176.27 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">635.57 MB</td>
    <td>3.61x</td>
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
    <td style="white-space: nowrap; text-align: right">2.99 K</td>
    <td style="white-space: nowrap; text-align: right">0.33 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;12.61%</td>
    <td style="white-space: nowrap; text-align: right">0.31 ms</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.35 K</td>
    <td style="white-space: nowrap; text-align: right">2.82 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;0.85%</td>
    <td style="white-space: nowrap; text-align: right">2.82 ms</td>
    <td style="white-space: nowrap; text-align: right">2.89 ms</td>
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
    <td style="white-space: nowrap;text-align: right">2.99 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.35 K</td>
    <td style="white-space: nowrap; text-align: right">8.44x</td>
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
    <td style="white-space: nowrap">1.71 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">1.62 MB</td>
    <td>0.95x</td>
  </tr>
</table>