
# Benchmark

Generating structs from WKT, WKB and GeoJson

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
    <td style="white-space: nowrap">1.13.1</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">24.1</td>
  </tr>
</table>

## Configuration

Benchmark suite executing with the following configuration:

<table style="width: 1%">
  <tr>
    <th style="width: 1%">:time</th>
    <td style="white-space: nowrap">10 s</td>
  </tr><tr>
    <th>:parallel</th>
    <td style="white-space: nowrap">1</td>
  </tr><tr>
    <th>:warmup</th>
    <td style="white-space: nowrap">2 s</td>
  </tr>
</table>

## Statistics




__Input: GeoJson LineString__

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
    <td style="white-space: nowrap; text-align: right">3.09 M</td>
    <td style="white-space: nowrap; text-align: right">323.38 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13353.87%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">2.76 M</td>
    <td style="white-space: nowrap; text-align: right">362.93 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6139.05%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">3.09 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">2.76 M</td>
    <td style="white-space: nowrap; text-align: right">1.12x</td>
  </tr>

</table>




__Input: GeoJson LineString (long)__

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
    <td style="white-space: nowrap; text-align: right">3.07 M</td>
    <td style="white-space: nowrap; text-align: right">0.33 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13791.59%</td>
    <td style="white-space: nowrap; text-align: right">0 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.0526 M</td>
    <td style="white-space: nowrap; text-align: right">19.02 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;66.40%</td>
    <td style="white-space: nowrap; text-align: right">17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">54 &micro;s</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">3.07 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.0526 M</td>
    <td style="white-space: nowrap; text-align: right">58.4x</td>
  </tr>

</table>




__Input: GeoJson Point__

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
    <td style="white-space: nowrap; text-align: right">4.32 M</td>
    <td style="white-space: nowrap; text-align: right">231.36 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13996.32%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.45 M</td>
    <td style="white-space: nowrap; text-align: right">407.47 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8261.51%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap;text-align: right">4.32 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.45 M</td>
    <td style="white-space: nowrap; text-align: right">1.76x</td>
  </tr>

</table>




__Input: GeoJson Polygon__

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
    <td style="white-space: nowrap; text-align: right">2.37 M</td>
    <td style="white-space: nowrap; text-align: right">421.24 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9659.90%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.75 M</td>
    <td style="white-space: nowrap; text-align: right">570.56 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;6294.18%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">2.37 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.75 M</td>
    <td style="white-space: nowrap; text-align: right">1.35x</td>
  </tr>

</table>




__Input: WKB LineString__

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
    <td style="white-space: nowrap; text-align: right">853.13 K</td>
    <td style="white-space: nowrap; text-align: right">1.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1920.43%</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">3 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">416.40 K</td>
    <td style="white-space: nowrap; text-align: right">2.40 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;689.98%</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">7 &micro;s</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">853.13 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">416.40 K</td>
    <td style="white-space: nowrap; text-align: right">2.05x</td>
  </tr>

</table>




__Input: WKB LineString (long)__

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
    <td style="white-space: nowrap; text-align: right">4.22 K</td>
    <td style="white-space: nowrap; text-align: right">236.88 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;13.04%</td>
    <td style="white-space: nowrap; text-align: right">226 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">382 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">2.11 K</td>
    <td style="white-space: nowrap; text-align: right">473.85 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;9.00%</td>
    <td style="white-space: nowrap; text-align: right">466 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">672 &micro;s</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">4.22 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">2.11 K</td>
    <td style="white-space: nowrap; text-align: right">2.0x</td>
  </tr>

</table>




__Input: WKB Point__

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
    <td style="white-space: nowrap; text-align: right">1.71 M</td>
    <td style="white-space: nowrap; text-align: right">585.81 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3738.42%</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.08 M</td>
    <td style="white-space: nowrap; text-align: right">922.33 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3030.17%</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">1.71 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.08 M</td>
    <td style="white-space: nowrap; text-align: right">1.57x</td>
  </tr>

</table>




__Input: WKB Polygon__

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
    <td style="white-space: nowrap; text-align: right">328.02 K</td>
    <td style="white-space: nowrap; text-align: right">3.05 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;395.81%</td>
    <td style="white-space: nowrap; text-align: right">3 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">10 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">138.94 K</td>
    <td style="white-space: nowrap; text-align: right">7.20 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;294.98%</td>
    <td style="white-space: nowrap; text-align: right">6 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">24 &micro;s</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">328.02 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">138.94 K</td>
    <td style="white-space: nowrap; text-align: right">2.36x</td>
  </tr>

</table>




__Input: WKT LineString__

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
    <td style="white-space: nowrap; text-align: right">338.93 K</td>
    <td style="white-space: nowrap; text-align: right">2.95 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;424.93%</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">13 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">39.45 K</td>
    <td style="white-space: nowrap; text-align: right">25.35 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;36.97%</td>
    <td style="white-space: nowrap; text-align: right">24 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">67 &micro;s</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">338.93 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">39.45 K</td>
    <td style="white-space: nowrap; text-align: right">8.59x</td>
  </tr>

</table>




__Input: WKT LineString (long)__

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
    <td style="white-space: nowrap; text-align: right">1.97 K</td>
    <td style="white-space: nowrap; text-align: right">0.51 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10.67%</td>
    <td style="white-space: nowrap; text-align: right">0.49 ms</td>
    <td style="white-space: nowrap; text-align: right">0.75 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.131 K</td>
    <td style="white-space: nowrap; text-align: right">7.66 ms</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.22%</td>
    <td style="white-space: nowrap; text-align: right">7.60 ms</td>
    <td style="white-space: nowrap; text-align: right">8.61 ms</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">1.97 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.131 K</td>
    <td style="white-space: nowrap; text-align: right">15.08x</td>
  </tr>

</table>




__Input: WKT Point__

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
    <td style="white-space: nowrap; text-align: right">702.98 K</td>
    <td style="white-space: nowrap; text-align: right">1.42 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1288.67%</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">5 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">133.34 K</td>
    <td style="white-space: nowrap; text-align: right">7.50 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;195.22%</td>
    <td style="white-space: nowrap; text-align: right">7 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">12 &micro;s</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">702.98 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">133.34 K</td>
    <td style="white-space: nowrap; text-align: right">5.27x</td>
  </tr>

</table>




__Input: WKT Polygon__

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
    <td style="white-space: nowrap; text-align: right">96.74 K</td>
    <td style="white-space: nowrap; text-align: right">10.34 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;196.49%</td>
    <td style="white-space: nowrap; text-align: right">7 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">38 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">12.00 K</td>
    <td style="white-space: nowrap; text-align: right">83.32 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;39.38%</td>
    <td style="white-space: nowrap; text-align: right">80 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">113 &micro;s</td>
  </tr>

</table>


Comparison

<table style="width: 1%">
  <tr>
    <th>Name</th>
    <th style="text-align: right">IPS</th>
    <th style="text-align: right">Slower</th>
  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap;text-align: right">96.74 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">12.00 K</td>
    <td style="white-space: nowrap; text-align: right">8.06x</td>
  </tr>

</table>



