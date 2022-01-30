
# Benchmark

Benchmark run from 2022-01-30 15:33:02.854057Z UTC

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
    <td style="white-space: nowrap; text-align: right">794.56 K</td>
    <td style="white-space: nowrap; text-align: right">1.26 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2136.41%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">1.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">262.54 K</td>
    <td style="white-space: nowrap; text-align: right">3.81 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;506.86%</td>
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
    <td style="white-space: nowrap;text-align: right">794.56 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">262.54 K</td>
    <td style="white-space: nowrap; text-align: right">3.03x</td>
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
    <td style="white-space: nowrap; text-align: right">4.52 K</td>
    <td style="white-space: nowrap; text-align: right">221.38 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.11%</td>
    <td style="white-space: nowrap; text-align: right">225.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">242.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.23 K</td>
    <td style="white-space: nowrap; text-align: right">814.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3.50%</td>
    <td style="white-space: nowrap; text-align: right">805.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">906.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">4.52 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.23 K</td>
    <td style="white-space: nowrap; text-align: right">3.68x</td>
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
    <td style="white-space: nowrap; text-align: right">1.58 M</td>
    <td style="white-space: nowrap; text-align: right">0.63 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3824.87%</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">0.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">0.81 M</td>
    <td style="white-space: nowrap; text-align: right">1.23 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1619.98%</td>
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
    <td style="white-space: nowrap;text-align: right">1.58 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">0.81 M</td>
    <td style="white-space: nowrap; text-align: right">1.94x</td>
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
    <td style="white-space: nowrap; text-align: right">315.89 K</td>
    <td style="white-space: nowrap; text-align: right">3.17 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;569.32%</td>
    <td style="white-space: nowrap; text-align: right">2.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">6.99 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">94.27 K</td>
    <td style="white-space: nowrap; text-align: right">10.61 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;177.06%</td>
    <td style="white-space: nowrap; text-align: right">8.99 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">31.99 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">315.89 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">94.27 K</td>
    <td style="white-space: nowrap; text-align: right">3.35x</td>
  </tr>

</table>



