
# Benchmark

Benchmark run from 2020-11-02 20:38:43.899187Z UTC

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
    <td style="white-space: nowrap; text-align: right">95.48 K</td>
    <td style="white-space: nowrap; text-align: right">10.47 μs</td>
    <td style="white-space: nowrap; text-align: right">±314.11%</td>
    <td style="white-space: nowrap; text-align: right">8.97 μs</td>
    <td style="white-space: nowrap; text-align: right">26.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">78.21 K</td>
    <td style="white-space: nowrap; text-align: right">12.79 μs</td>
    <td style="white-space: nowrap; text-align: right">±1250.82%</td>
    <td style="white-space: nowrap; text-align: right">10.97 μs</td>
    <td style="white-space: nowrap; text-align: right">28.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">95.48 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">78.21 K</td>
    <td style="white-space: nowrap; text-align: right">1.22x</td>
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
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">385.70</td>
    <td style="white-space: nowrap; text-align: right">2.59 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.79%</td>
    <td style="white-space: nowrap; text-align: right">2.55 ms</td>
    <td style="white-space: nowrap; text-align: right">3.44 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">334.74</td>
    <td style="white-space: nowrap; text-align: right">2.99 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.51%</td>
    <td style="white-space: nowrap; text-align: right">2.95 ms</td>
    <td style="white-space: nowrap; text-align: right">3.65 ms</td>
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
    <td style="white-space: nowrap;text-align: right">385.70</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">334.74</td>
    <td style="white-space: nowrap; text-align: right">1.15x</td>
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
    <td style="white-space: nowrap; text-align: right">267.99 K</td>
    <td style="white-space: nowrap; text-align: right">3.73 μs</td>
    <td style="white-space: nowrap; text-align: right">±1186.76%</td>
    <td style="white-space: nowrap; text-align: right">2.97 μs</td>
    <td style="white-space: nowrap; text-align: right">10.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">202.92 K</td>
    <td style="white-space: nowrap; text-align: right">4.93 μs</td>
    <td style="white-space: nowrap; text-align: right">±548.62%</td>
    <td style="white-space: nowrap; text-align: right">3.97 μs</td>
    <td style="white-space: nowrap; text-align: right">13.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">267.99 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">202.92 K</td>
    <td style="white-space: nowrap; text-align: right">1.32x</td>
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
    <td style="white-space: nowrap; text-align: right">34.56 K</td>
    <td style="white-space: nowrap; text-align: right">28.93 μs</td>
    <td style="white-space: nowrap; text-align: right">±84.54%</td>
    <td style="white-space: nowrap; text-align: right">24.97 μs</td>
    <td style="white-space: nowrap; text-align: right">114.97 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">29.56 K</td>
    <td style="white-space: nowrap; text-align: right">33.83 μs</td>
    <td style="white-space: nowrap; text-align: right">±42.16%</td>
    <td style="white-space: nowrap; text-align: right">30.97 μs</td>
    <td style="white-space: nowrap; text-align: right">74.97 μs</td>
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
    <td style="white-space: nowrap;text-align: right">34.56 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">29.56 K</td>
    <td style="white-space: nowrap; text-align: right">1.17x</td>
  </tr>

</table>



<hr/>

