
# Benchmark

Benchmark run from 2020-10-18 21:47:26.251693Z UTC

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




__Input: LineString__

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
    <td style="white-space: nowrap; text-align: right">1.64 M</td>
    <td style="white-space: nowrap; text-align: right">610.56 ns</td>
    <td style="white-space: nowrap; text-align: right">±5309.07%</td>
    <td style="white-space: nowrap; text-align: right">970 ns</td>
    <td style="white-space: nowrap; text-align: right">970 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.19 M</td>
    <td style="white-space: nowrap; text-align: right">840.28 ns</td>
    <td style="white-space: nowrap; text-align: right">±4082.18%</td>
    <td style="white-space: nowrap; text-align: right">970 ns</td>
    <td style="white-space: nowrap; text-align: right">970 ns</td>
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
    <td style="white-space: nowrap;text-align: right">1.64 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.19 M</td>
    <td style="white-space: nowrap; text-align: right">1.38x</td>
  </tr>

</table>



<hr/>


__Input: LineString (long)__

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
    <td style="white-space: nowrap; text-align: right">17.51 K</td>
    <td style="white-space: nowrap; text-align: right">57.11 μs</td>
    <td style="white-space: nowrap; text-align: right">±425.92%</td>
    <td style="white-space: nowrap; text-align: right">53.97 μs</td>
    <td style="white-space: nowrap; text-align: right">92.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">12.16 K</td>
    <td style="white-space: nowrap; text-align: right">82.23 μs</td>
    <td style="white-space: nowrap; text-align: right">±26.50%</td>
    <td style="white-space: nowrap; text-align: right">77.97 μs</td>
    <td style="white-space: nowrap; text-align: right">129.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">17.51 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">12.16 K</td>
    <td style="white-space: nowrap; text-align: right">1.44x</td>
  </tr>

</table>



<hr/>


__Input: Point__

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
    <td style="white-space: nowrap; text-align: right">3.42 M</td>
    <td style="white-space: nowrap; text-align: right">292.65 ns</td>
    <td style="white-space: nowrap; text-align: right">±1821.60%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">970 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.53 M</td>
    <td style="white-space: nowrap; text-align: right">653.29 ns</td>
    <td style="white-space: nowrap; text-align: right">±8769.79%</td>
    <td style="white-space: nowrap; text-align: right">970 ns</td>
    <td style="white-space: nowrap; text-align: right">970 ns</td>
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
    <td style="white-space: nowrap;text-align: right">3.42 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">1.53 M</td>
    <td style="white-space: nowrap; text-align: right">2.23x</td>
  </tr>

</table>



<hr/>


__Input: Polygon__

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
    <td style="white-space: nowrap; text-align: right">812.51 K</td>
    <td style="white-space: nowrap; text-align: right">1.23 μs</td>
    <td style="white-space: nowrap; text-align: right">±2931.47%</td>
    <td style="white-space: nowrap; text-align: right">0.97 μs</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">742.32 K</td>
    <td style="white-space: nowrap; text-align: right">1.35 μs</td>
    <td style="white-space: nowrap; text-align: right">±3372.51%</td>
    <td style="white-space: nowrap; text-align: right">0.97 μs</td>
    <td style="white-space: nowrap; text-align: right">1.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">812.51 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">742.32 K</td>
    <td style="white-space: nowrap; text-align: right">1.09x</td>
  </tr>

</table>



<hr/>

