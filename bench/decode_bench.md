
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
    <td style="white-space: nowrap">Intel(R) Core(TM) i7-4770HQ CPU @ 2.20GHz</td>
  </tr><tr>
    <th style="white-space: nowrap">Number of Available Cores</th>
    <td style="white-space: nowrap">8</td>
  </tr><tr>
    <th style="white-space: nowrap">Available Memory</th>
    <td style="white-space: nowrap">16 GB</td>
  </tr><tr>
    <th style="white-space: nowrap">Elixir Version</th>
    <td style="white-space: nowrap">1.11.1</td>
  </tr><tr>
    <th style="white-space: nowrap">Erlang Version</th>
    <td style="white-space: nowrap">23.1.1</td>
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
    <td style="white-space: nowrap; text-align: right">1.44 M</td>
    <td style="white-space: nowrap; text-align: right">693.30 ns</td>
    <td style="white-space: nowrap; text-align: right">±5720.30%</td>
    <td style="white-space: nowrap; text-align: right">900 ns</td>
    <td style="white-space: nowrap; text-align: right">900 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.21 M</td>
    <td style="white-space: nowrap; text-align: right">828.58 ns</td>
    <td style="white-space: nowrap; text-align: right">±3031.36%</td>
    <td style="white-space: nowrap; text-align: right">900 ns</td>
    <td style="white-space: nowrap; text-align: right">1900 ns</td>
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
    <td style="white-space: nowrap;text-align: right">1.44 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.21 M</td>
    <td style="white-space: nowrap; text-align: right">1.2x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">1.39 M</td>
    <td style="white-space: nowrap; text-align: right">0.72 μs</td>
    <td style="white-space: nowrap; text-align: right">±6804.76%</td>
    <td style="white-space: nowrap; text-align: right">0.90 μs</td>
    <td style="white-space: nowrap; text-align: right">0.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.0130 M</td>
    <td style="white-space: nowrap; text-align: right">76.95 μs</td>
    <td style="white-space: nowrap; text-align: right">±47.82%</td>
    <td style="white-space: nowrap; text-align: right">72.90 μs</td>
    <td style="white-space: nowrap; text-align: right">139.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.39 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.0130 M</td>
    <td style="white-space: nowrap; text-align: right">107.02x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">1.63 M</td>
    <td style="white-space: nowrap; text-align: right">614.24 ns</td>
    <td style="white-space: nowrap; text-align: right">±4018.32%</td>
    <td style="white-space: nowrap; text-align: right">900 ns</td>
    <td style="white-space: nowrap; text-align: right">900 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.10 M</td>
    <td style="white-space: nowrap; text-align: right">905.67 ns</td>
    <td style="white-space: nowrap; text-align: right">±3980.13%</td>
    <td style="white-space: nowrap; text-align: right">900 ns</td>
    <td style="white-space: nowrap; text-align: right">1900 ns</td>
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
    <td style="white-space: nowrap;text-align: right">1.63 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.10 M</td>
    <td style="white-space: nowrap; text-align: right">1.47x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">1.03 M</td>
    <td style="white-space: nowrap; text-align: right">0.98 μs</td>
    <td style="white-space: nowrap; text-align: right">±4365.35%</td>
    <td style="white-space: nowrap; text-align: right">0.90 μs</td>
    <td style="white-space: nowrap; text-align: right">1.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.65 M</td>
    <td style="white-space: nowrap; text-align: right">1.53 μs</td>
    <td style="white-space: nowrap; text-align: right">±2275.49%</td>
    <td style="white-space: nowrap; text-align: right">0.90 μs</td>
    <td style="white-space: nowrap; text-align: right">2.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">1.03 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.65 M</td>
    <td style="white-space: nowrap; text-align: right">1.57x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">290.18 K</td>
    <td style="white-space: nowrap; text-align: right">3.45 μs</td>
    <td style="white-space: nowrap; text-align: right">±881.74%</td>
    <td style="white-space: nowrap; text-align: right">2.90 μs</td>
    <td style="white-space: nowrap; text-align: right">6.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">245.25 K</td>
    <td style="white-space: nowrap; text-align: right">4.08 μs</td>
    <td style="white-space: nowrap; text-align: right">±662.98%</td>
    <td style="white-space: nowrap; text-align: right">3.90 μs</td>
    <td style="white-space: nowrap; text-align: right">7.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">290.18 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">245.25 K</td>
    <td style="white-space: nowrap; text-align: right">1.18x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">1.24 K</td>
    <td style="white-space: nowrap; text-align: right">0.81 ms</td>
    <td style="white-space: nowrap; text-align: right">±17.17%</td>
    <td style="white-space: nowrap; text-align: right">0.76 ms</td>
    <td style="white-space: nowrap; text-align: right">1.30 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.91 K</td>
    <td style="white-space: nowrap; text-align: right">1.10 ms</td>
    <td style="white-space: nowrap; text-align: right">±20.10%</td>
    <td style="white-space: nowrap; text-align: right">1.04 ms</td>
    <td style="white-space: nowrap; text-align: right">1.95 ms</td>
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
    <td style="white-space: nowrap;text-align: right">1.24 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.91 K</td>
    <td style="white-space: nowrap; text-align: right">1.36x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">631.44 K</td>
    <td style="white-space: nowrap; text-align: right">1.58 μs</td>
    <td style="white-space: nowrap; text-align: right">±2459.27%</td>
    <td style="white-space: nowrap; text-align: right">0.90 μs</td>
    <td style="white-space: nowrap; text-align: right">2.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">607.62 K</td>
    <td style="white-space: nowrap; text-align: right">1.65 μs</td>
    <td style="white-space: nowrap; text-align: right">±2414.34%</td>
    <td style="white-space: nowrap; text-align: right">1.90 μs</td>
    <td style="white-space: nowrap; text-align: right">2.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">631.44 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">607.62 K</td>
    <td style="white-space: nowrap; text-align: right">1.04x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">115.36 K</td>
    <td style="white-space: nowrap; text-align: right">8.67 μs</td>
    <td style="white-space: nowrap; text-align: right">±334.57%</td>
    <td style="white-space: nowrap; text-align: right">7.90 μs</td>
    <td style="white-space: nowrap; text-align: right">18.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">91.36 K</td>
    <td style="white-space: nowrap; text-align: right">10.95 μs</td>
    <td style="white-space: nowrap; text-align: right">±176.68%</td>
    <td style="white-space: nowrap; text-align: right">9.90 μs</td>
    <td style="white-space: nowrap; text-align: right">23.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">115.36 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">91.36 K</td>
    <td style="white-space: nowrap; text-align: right">1.26x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">106.15 K</td>
    <td style="white-space: nowrap; text-align: right">9.42 μs</td>
    <td style="white-space: nowrap; text-align: right">±274.99%</td>
    <td style="white-space: nowrap; text-align: right">8.90 μs</td>
    <td style="white-space: nowrap; text-align: right">19.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">19.80 K</td>
    <td style="white-space: nowrap; text-align: right">50.50 μs</td>
    <td style="white-space: nowrap; text-align: right">±39.43%</td>
    <td style="white-space: nowrap; text-align: right">47.90 μs</td>
    <td style="white-space: nowrap; text-align: right">89.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">106.15 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">19.80 K</td>
    <td style="white-space: nowrap; text-align: right">5.36x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">619.52</td>
    <td style="white-space: nowrap; text-align: right">1.61 ms</td>
    <td style="white-space: nowrap; text-align: right">±9.16%</td>
    <td style="white-space: nowrap; text-align: right">1.58 ms</td>
    <td style="white-space: nowrap; text-align: right">2.10 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">67.89</td>
    <td style="white-space: nowrap; text-align: right">14.73 ms</td>
    <td style="white-space: nowrap; text-align: right">±6.20%</td>
    <td style="white-space: nowrap; text-align: right">14.52 ms</td>
    <td style="white-space: nowrap; text-align: right">18.76 ms</td>
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
    <td style="white-space: nowrap;text-align: right">619.52</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">67.89</td>
    <td style="white-space: nowrap; text-align: right">9.12x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">223.02 K</td>
    <td style="white-space: nowrap; text-align: right">4.48 μs</td>
    <td style="white-space: nowrap; text-align: right">±664.20%</td>
    <td style="white-space: nowrap; text-align: right">3.90 μs</td>
    <td style="white-space: nowrap; text-align: right">10.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">77.24 K</td>
    <td style="white-space: nowrap; text-align: right">12.95 μs</td>
    <td style="white-space: nowrap; text-align: right">±150.61%</td>
    <td style="white-space: nowrap; text-align: right">11.90 μs</td>
    <td style="white-space: nowrap; text-align: right">26.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">223.02 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">77.24 K</td>
    <td style="white-space: nowrap; text-align: right">2.89x</td>
  </tr>

</table>



<hr/>


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
    <td style="white-space: nowrap; text-align: right">42.65 K</td>
    <td style="white-space: nowrap; text-align: right">23.44 μs</td>
    <td style="white-space: nowrap; text-align: right">±74.77%</td>
    <td style="white-space: nowrap; text-align: right">21.90 μs</td>
    <td style="white-space: nowrap; text-align: right">43.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">5.29 K</td>
    <td style="white-space: nowrap; text-align: right">188.93 μs</td>
    <td style="white-space: nowrap; text-align: right">±15.81%</td>
    <td style="white-space: nowrap; text-align: right">179.90 μs</td>
    <td style="white-space: nowrap; text-align: right">292.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">42.65 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">5.29 K</td>
    <td style="white-space: nowrap; text-align: right">8.06x</td>
  </tr>

</table>



<hr/>

