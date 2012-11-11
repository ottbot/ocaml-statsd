
let shopstats = Statsd.send ~hostname:"localhost" ~port:8125 ~namespace:"my_hardware_store";;

shopstats "bolts" Increment
shopstats "nuts" Decrement
shopstats "mousetraps" (Count 250)
shopstats "sale" (Gauge 14.99)
shopstats "first_contact" (Timing 23.)
