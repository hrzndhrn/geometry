
# Benchmark

Benchmark run from 2022-01-30 15:34:53.087872Z UTC

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
    <td style="white-space: nowrap; text-align: right">789.53 K</td>
    <td style="white-space: nowrap; text-align: right">1.27 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2107.58%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">509.09 K</td>
    <td style="white-space: nowrap; text-align: right">1.96 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;526.85%</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">4.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">789.53 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">509.09 K</td>
    <td style="white-space: nowrap; text-align: right">1.55x</td>
  </tr>

</table>




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
    <td style="white-space: nowrap; text-align: right">4.51 K</td>
    <td style="white-space: nowrap; text-align: right">221.65 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.52%</td>
    <td style="white-space: nowrap; text-align: right">226.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">241.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.40 K</td>
    <td style="white-space: nowrap; text-align: right">416.83 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;10.74%</td>
    <td style="white-space: nowrap; text-align: right">404.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">576.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">4.51 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.40 K</td>
    <td style="white-space: nowrap; text-align: right">1.88x</td>
  </tr>

</table>




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
    <td style="white-space: nowrap; text-align: right">1.60 M</td>
    <td style="white-space: nowrap; text-align: right">624.91 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3848.19%</td>
    <td style="white-space: nowrap; text-align: right">990 ns</td>
    <td style="white-space: nowrap; text-align: right">990 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.35 M</td>
    <td style="white-space: nowrap; text-align: right">740.58 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;487.53%</td>
    <td style="white-space: nowrap; text-align: right">990 ns</td>
    <td style="white-space: nowrap; text-align: right">2990 ns</td>
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
    <td style="white-space: nowrap;text-align: right">1.60 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.35 M</td>
    <td style="white-space: nowrap; text-align: right">1.19x</td>
  </tr>

</table>




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
    <td style="white-space: nowrap; text-align: right">315.91 K</td>
    <td style="white-space: nowrap; text-align: right">3.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;560.42%</td>
    <td style="white-space: nowrap; text-align: right">2.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">6.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">176.63 K</td>
    <td style="white-space: nowrap; text-align: right">5.66 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;298.67%</td>
    <td style="white-space: nowrap; text-align: right">4.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">10.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">315.91 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">176.63 K</td>
    <td style="white-space: nowrap; text-align: right">1.79x</td>
  </tr>

</table>



