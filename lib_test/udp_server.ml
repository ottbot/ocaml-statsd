(* A dummy UDP server *)

let maxlen = 1024
let portno = 8125

let sock =
  Unix.socket Unix.PF_INET Unix.SOCK_DGRAM
    (Unix.getprotobyname "udp").Unix.p_proto

let () =
  Unix.bind sock (Unix.ADDR_INET (Unix.inet_addr_any, portno));
  Printf.printf "Awaiting UDP messages on port %d\n%!" portno

let oldmsg = ref "This is the starting message."

let () =
  let newmsg, response = String.create maxlen, "Thanks bro" in
  while true do
    let newmsg, hishost, sockaddr =
      match Unix.recvfrom sock newmsg 0 maxlen [] with
        | len, (Unix.ADDR_INET (addr, port) as sockaddr) ->
            String.sub newmsg 0 len,
            (Unix.gethostbyaddr addr).Unix.h_name,
            sockaddr
        | _ -> assert false in
    Printf.printf "Client %s said ``%s''\n%!" hishost newmsg;
    ignore
      (Unix.sendto sock response 0 (String.length response) [] sockaddr);
  done
