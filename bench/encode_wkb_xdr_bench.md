
# Benchmark

Benchmark run from 2022-01-30 14:36:22.309261Z UTC

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
    <td style="white-space: nowrap; text-align: right">780.32 K</td>
    <td style="white-space: nowrap; text-align: right">1.28 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1795.37%</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">507.21 K</td>
    <td style="white-space: nowrap; text-align: right">1.97 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;428.83%</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">5 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">780.32 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">507.21 K</td>
    <td style="white-space: nowrap; text-align: right">1.54x</td>
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
    <td style="white-space: nowrap; text-align: right">221.74 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.42%</td>
    <td style="white-space: nowrap; text-align: right">227 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">241 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.36 K</td>
    <td style="white-space: nowrap; text-align: right">423.68 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;8.54%</td>
    <td style="white-space: nowrap; text-align: right">414 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">578 &micro;s</td>
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
    <td style="white-space: nowrap; text-align: right">2.36 K</td>
    <td style="white-space: nowrap; text-align: right">1.91x</td>
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
    <td style="white-space: nowrap; text-align: right">1.55 M</td>
    <td style="white-space: nowrap; text-align: right">647.07 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3419.33%</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.32 M</td>
    <td style="white-space: nowrap; text-align: right">760.07 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;511.17%</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
    <td style="white-space: nowrap; text-align: right">4000 ns</td>
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
    <td style="white-space: nowrap;text-align: right">1.55 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.32 M</td>
    <td style="white-space: nowrap; text-align: right">1.17x</td>
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
    <td style="white-space: nowrap; text-align: right">314.23 K</td>
    <td style="white-space: nowrap; text-align: right">3.18 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;527.86%</td>
    <td style="white-space: nowrap; text-align: right">3 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">7 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">180.10 K</td>
    <td style="white-space: nowrap; text-align: right">5.55 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;226.06%</td>
    <td style="white-space: nowrap; text-align: right">5 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">11 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">314.23 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">180.10 K</td>
    <td style="white-space: nowrap; text-align: right">1.74x</td>
  </tr>

</table>



