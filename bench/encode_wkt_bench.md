
# Benchmark

Benchmark run from 2022-01-30 15:03:12.047501Z UTC

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
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">1.24 M</td>
    <td style="white-space: nowrap; text-align: right">0.80 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3992.36%</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.80 M</td>
    <td style="white-space: nowrap; text-align: right">1.26 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;2532.20%</td>
    <td style="white-space: nowrap; text-align: right">1 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">1.24 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">0.80 M</td>
    <td style="white-space: nowrap; text-align: right">1.56x</td>
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
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">5.20 K</td>
    <td style="white-space: nowrap; text-align: right">192.27 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;12.30%</td>
    <td style="white-space: nowrap; text-align: right">194 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">255 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">4.04 K</td>
    <td style="white-space: nowrap; text-align: right">247.30 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;4.96%</td>
    <td style="white-space: nowrap; text-align: right">242 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">292 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">5.20 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">4.04 K</td>
    <td style="white-space: nowrap; text-align: right">1.29x</td>
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
    <td style="white-space: nowrap; text-align: right">3.95 M</td>
    <td style="white-space: nowrap; text-align: right">253.22 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;3791.44%</td>
    <td style="white-space: nowrap; text-align: right">0 ns</td>
    <td style="white-space: nowrap; text-align: right">1000 ns</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.14 M</td>
    <td style="white-space: nowrap; text-align: right">466.90 ns</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;11308.88%</td>
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
    <td style="white-space: nowrap;text-align: right">3.95 M</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">2.14 M</td>
    <td style="white-space: nowrap; text-align: right">1.84x</td>
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
    <td style="white-space: nowrap">geometry</td>
    <td style="white-space: nowrap; text-align: right">368.12 K</td>
    <td style="white-space: nowrap; text-align: right">2.72 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;1104.54%</td>
    <td style="white-space: nowrap; text-align: right">2 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">6 &micro;s</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">302.34 K</td>
    <td style="white-space: nowrap; text-align: right">3.31 &micro;s</td>
    <td style="white-space: nowrap; text-align: right">&plusmn;785.80%</td>
    <td style="white-space: nowrap; text-align: right">3 &micro;s</td>
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
    <td style="white-space: nowrap;text-align: right">368.12 K</td>
    <td>&nbsp;</td>
  </tr>

  <tr>
    <td style="white-space: nowrap">geo</td>
    <td style="white-space: nowrap; text-align: right">302.34 K</td>
    <td style="white-space: nowrap; text-align: right">1.22x</td>
  </tr>

</table>



