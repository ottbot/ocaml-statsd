#load "unix.cma";;
#load "str.cma";;

type metric_action =
  | Increment
  | Decrement
  | Count of int
  | Gauge of float
  | Timing of float

let metric_to_string = function
  | Increment -> "1"
  | Decrement -> "-1"
  | Count n -> string_of_int n
  | Gauge n | Timing n -> string_of_float n

let metric_suffix = function
  | Increment | Decrement | Count _ -> "|c"
  | Gauge _ -> "|g"
  | Timing _ -> "|ms"

(* reserved chars @ : *)
let sanitize_name =
  Str.global_replace (Str.regexp "@\\|:") "_"

let prepare_str metric name =
  let buff = Buffer.create 32 in
  let add_str = Buffer.add_string buff in
  add_str (sanitize_name name);
  add_str ":";
  add_str (metric_to_string metric);
  add_str (metric_suffix metric);
  Buffer.contents buff

let bucket prefix name =
  if prefix = "" then name else
    Printf.sprintf "%s.%s" prefix name

let send ?hostname:(hostname="localhost") ?port:(port=8125) ?namespace:(ns="") name metric =
  let message = prepare_str metric (bucket ns name) in
  let ipaddr = (Unix.gethostbyname hostname).Unix.h_addr_list.(0) in
  let portaddr = Unix.ADDR_INET (ipaddr, port) in
  let socket =
    Unix.socket Unix.PF_INET Unix.SOCK_DGRAM
      (Unix.getprotobyname "udp").Unix.p_proto in
  Unix.sendto socket message 0 (String.length message) [] portaddr
