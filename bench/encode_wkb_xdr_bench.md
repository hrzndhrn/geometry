
# Benchmark

Benchmark run from 2020-10-18 21:50:53.818533Z UTC

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
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">160.55 K</td>
    <td style="white-space: nowrap; text-align: right">6.23 μs</td>
    <td style="white-space: nowrap; text-align: right">±531.90%</td>
    <td style="white-space: nowrap; text-align: right">5.90 μs</td>
    <td style="white-space: nowrap; text-align: right">14.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">47.27 K</td>
    <td style="white-space: nowrap; text-align: right">21.16 μs</td>
    <td style="white-space: nowrap; text-align: right">±115.10%</td>
    <td style="white-space: nowrap; text-align: right">18.90 μs</td>
    <td style="white-space: nowrap; text-align: right">86.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">160.55 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">47.27 K</td>
    <td style="white-space: nowrap; text-align: right">3.4x</td>
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
    <td style="white-space: nowrap; text-align: right">718.57</td>
    <td style="white-space: nowrap; text-align: right">1.39 ms</td>
    <td style="white-space: nowrap; text-align: right">±8.85%</td>
    <td style="white-space: nowrap; text-align: right">1.36 ms</td>
    <td style="white-space: nowrap; text-align: right">1.77 ms</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">139.42</td>
    <td style="white-space: nowrap; text-align: right">7.17 ms</td>
    <td style="white-space: nowrap; text-align: right">±10.75%</td>
    <td style="white-space: nowrap; text-align: right">7.03 ms</td>
    <td style="white-space: nowrap; text-align: right">9.75 ms</td>
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
    <td style="white-space: nowrap;text-align: right">718.57</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">139.42</td>
    <td style="white-space: nowrap; text-align: right">5.15x</td>
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
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">383.58 K</td>
    <td style="white-space: nowrap; text-align: right">2.61 μs</td>
    <td style="white-space: nowrap; text-align: right">±1307.88%</td>
    <td style="white-space: nowrap; text-align: right">1.90 μs</td>
    <td style="white-space: nowrap; text-align: right">4.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">144.25 K</td>
    <td style="white-space: nowrap; text-align: right">6.93 μs</td>
    <td style="white-space: nowrap; text-align: right">±189.03%</td>
    <td style="white-space: nowrap; text-align: right">6.90 μs</td>
    <td style="white-space: nowrap; text-align: right">16.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">383.58 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">144.25 K</td>
    <td style="white-space: nowrap; text-align: right">2.66x</td>
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
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">60.38 K</td>
    <td style="white-space: nowrap; text-align: right">16.56 μs</td>
    <td style="white-space: nowrap; text-align: right">±146.04%</td>
    <td style="white-space: nowrap; text-align: right">14.90 μs</td>
    <td style="white-space: nowrap; text-align: right">43.90 μs</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">16.28 K</td>
    <td style="white-space: nowrap; text-align: right">61.42 μs</td>
    <td style="white-space: nowrap; text-align: right">±32.23%</td>
    <td style="white-space: nowrap; text-align: right">55.90 μs</td>
    <td style="white-space: nowrap; text-align: right">159.90 μs</td>
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
    <td style="white-space: nowrap;text-align: right">60.38 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">16.28 K</td>
    <td style="white-space: nowrap; text-align: right">3.71x</td>
  </tr>

</table>



<hr/>

