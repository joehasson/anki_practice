let (>>= ) = Lwt.( >>= )

let rec loop () =
    Lwt_io.open_file ~mode:Lwt_io.input "log" >>= fun ch ->
    Lwt_io.read_line ch >>= fun s ->
    Lwt_io.printl s >>= fun () -> loop ()

