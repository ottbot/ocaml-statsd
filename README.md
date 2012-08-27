ocaml-statsd
============

A StatsD client for Ocaml

TODO
----
*  Sampling

Examples
--------

* Initialization

```ocaml
let shopstats = Statsd.send ~hostname:"localhost" ~port:8125 ~namespace:"my_hardware_store";;
```
* Increment

```ocaml
shopstats "bolts" Increment
```
* Decrement

```ocaml
shopstats "nuts" Decrement
```

* Count

```ocaml
shopstats "mousetraps" (Count 250)
```

* Gauge

```ocaml
shopstats "sale" (Gauge 14.99)
```

* Timing

```ocaml
shopstats "first_contact" (Timing 23.)
```