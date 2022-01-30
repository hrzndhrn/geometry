
# Benchmark

Benchmark run from 2022-01-30 14:59:12.841952Z UTC

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
    <td style="white-space: nowrap; text-align: right">744.45 K</td>
    <td style="white-space: nowrap; text-align: right">1.34 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2259.50%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">270.38 K</td>
    <td style="white-space: nowrap; text-align: right">3.70 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;524.35%</td>
    <td style="white-space: nowrap; text-align: right">2.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">6.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">744.45 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">270.38 K</td>
    <td style="white-space: nowrap; text-align: right">2.75x</td>
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
    <td style="white-space: nowrap; text-align: right">4.44 K</td>
    <td style="white-space: nowrap; text-align: right">225.14 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;5.03%</td>
    <td style="white-space: nowrap; text-align: right">226.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">259.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.16 K</td>
    <td style="white-space: nowrap; text-align: right">859.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.93%</td>
    <td style="white-space: nowrap; text-align: right">844.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">995.71 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">4.44 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.16 K</td>
    <td style="white-space: nowrap; text-align: right">3.82x</td>
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
    <td style="white-space: nowrap; text-align: right">1.42 M</td>
    <td style="white-space: nowrap; text-align: right">0.71 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4532.54%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">0.80 M</td>
    <td style="white-space: nowrap; text-align: right">1.24 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1829.52%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1.42 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">0.80 M</td>
    <td style="white-space: nowrap; text-align: right">1.76x</td>
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
    <td style="white-space: nowrap; text-align: right">306.70 K</td>
    <td style="white-space: nowrap; text-align: right">3.26 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;604.68%</td>
    <td style="white-space: nowrap; text-align: right">2.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">6.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">92.84 K</td>
    <td style="white-space: nowrap; text-align: right">10.77 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;172.18%</td>
    <td style="white-space: nowrap; text-align: right">8.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">33.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">306.70 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">92.84 K</td>
    <td style="white-space: nowrap; text-align: right">3.3x</td>
  </tr>

</table>



