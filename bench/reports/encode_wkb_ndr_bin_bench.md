Encode WKB (NDR/bin)

Benchmark run from 2025-06-25 05:00:27.430949Z UTC

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
    <td style="white-space: nowrap; text-align: right">25.33 K</td>
    <td style="white-space: nowrap; text-align: right">39.47 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8.33%</td>
    <td style="white-space: nowrap; text-align: right">37.83 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">44.00 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">13.07 K</td>
    <td style="white-space: nowrap; text-align: right">76.49 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13.48%</td>
    <td style="white-space: nowrap; text-align: right">72.92 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">118.83 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">25.33 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">13.07 K</td>
    <td style="white-space: nowrap; text-align: right">1.94x</td>
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
    <td style="white-space: nowrap">54.69 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">226.56 KB</td>
    <td>4.14x</td>
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
    <td style="white-space: nowrap; text-align: right">6.70 K</td>
    <td style="white-space: nowrap; text-align: right">149.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13.23%</td>
    <td style="white-space: nowrap; text-align: right">145.62 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">233.02 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">5.21 K</td>
    <td style="white-space: nowrap; text-align: right">192.03 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;67.55%</td>
    <td style="white-space: nowrap; text-align: right">185.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">329.29 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">6.70 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">5.21 K</td>
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
    <td style="white-space: nowrap">296.33 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">671.56 KB</td>
    <td>2.27x</td>
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
    <td style="white-space: nowrap; text-align: right">288.01</td>
    <td style="white-space: nowrap; text-align: right">3.47 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.45%</td>
    <td style="white-space: nowrap; text-align: right">3.44 ms</td>
    <td style="white-space: nowrap; text-align: right">3.77 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">160.39</td>
    <td style="white-space: nowrap; text-align: right">6.23 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2.66%</td>
    <td style="white-space: nowrap; text-align: right">6.28 ms</td>
    <td style="white-space: nowrap; text-align: right">6.51 ms</td>
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
    <td style="white-space: nowrap;text-align: right">288.01</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">160.39</td>
    <td style="white-space: nowrap; text-align: right">1.8x</td>
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
    <td style="white-space: nowrap">4.71 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">13.96 MB</td>
    <td>2.96x</td>
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
    <td style="white-space: nowrap; text-align: right">2.32 K</td>
    <td style="white-space: nowrap; text-align: right">431.21 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10.18%</td>
    <td style="white-space: nowrap; text-align: right">440.15 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">559.42 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.74 K</td>
    <td style="white-space: nowrap; text-align: right">576.20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9.34%</td>
    <td style="white-space: nowrap; text-align: right">591.75 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">664.72 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">2.32 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.74 K</td>
    <td style="white-space: nowrap; text-align: right">1.34x</td>
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
    <td style="white-space: nowrap">0.69 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">1.86 MB</td>
    <td>2.71x</td>
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
    <td style="white-space: nowrap; text-align: right">2.60 K</td>
    <td style="white-space: nowrap; text-align: right">383.95 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6.99%</td>
    <td style="white-space: nowrap; text-align: right">381.65 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">449.11 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.29 K</td>
    <td style="white-space: nowrap; text-align: right">773.43 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.31%</td>
    <td style="white-space: nowrap; text-align: right">767.29 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">842.41 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">2.60 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.29 K</td>
    <td style="white-space: nowrap; text-align: right">2.01x</td>
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
    <td style="white-space: nowrap">0.55 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">2.85 MB</td>
    <td>5.19x</td>
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
    <td style="white-space: nowrap; text-align: right">288.42</td>
    <td style="white-space: nowrap; text-align: right">3.47 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;19.08%</td>
    <td style="white-space: nowrap; text-align: right">3.61 ms</td>
    <td style="white-space: nowrap; text-align: right">4.26 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">161.53</td>
    <td style="white-space: nowrap; text-align: right">6.19 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6.46%</td>
    <td style="white-space: nowrap; text-align: right">6.12 ms</td>
    <td style="white-space: nowrap; text-align: right">7.88 ms</td>
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
    <td style="white-space: nowrap;text-align: right">288.42</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">161.53</td>
    <td style="white-space: nowrap; text-align: right">1.79x</td>
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
    <td style="white-space: nowrap">5.35 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">16.43 MB</td>
    <td>3.07x</td>
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
    <td style="white-space: nowrap; text-align: right">212.68</td>
    <td style="white-space: nowrap; text-align: right">4.70 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;7.80%</td>
    <td style="white-space: nowrap; text-align: right">4.55 ms</td>
    <td style="white-space: nowrap; text-align: right">5.51 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">102.03</td>
    <td style="white-space: nowrap; text-align: right">9.80 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1.82%</td>
    <td style="white-space: nowrap; text-align: right">9.84 ms</td>
    <td style="white-space: nowrap; text-align: right">10.10 ms</td>
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
    <td style="white-space: nowrap;text-align: right">212.68</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">102.03</td>
    <td style="white-space: nowrap; text-align: right">2.08x</td>
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
    <td style="white-space: nowrap">6.27 MB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">19.02 MB</td>
    <td>3.03x</td>
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
    <td style="white-space: nowrap; text-align: right">29.18 K</td>
    <td style="white-space: nowrap; text-align: right">34.27 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;20.33%</td>
    <td style="white-space: nowrap; text-align: right">30.83 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">56.21 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">28.98 K</td>
    <td style="white-space: nowrap; text-align: right">34.51 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;16.29%</td>
    <td style="white-space: nowrap; text-align: right">34.88 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">43.21 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">29.18 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">28.98 K</td>
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
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap">49.03 KB</td>
    <td>&nbsp;</td>
  </tr>
    <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap">110.81 KB</td>
    <td>2.26x</td>
  </tr>
</table>