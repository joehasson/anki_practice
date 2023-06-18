let file =
    Lwt_io.open_file ~mode:Input "foo"

let rec loop () =
    let open Lwt in
    file >>= fun c -> 
    Lwt_io.read_line c >>= fun s ->
    ignore (Lwt_io.printl s); loop ()

