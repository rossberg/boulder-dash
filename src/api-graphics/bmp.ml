(* Loading BMP files *)

let int8 s i = String.get_uint8 s i
let int16_le s i = String.get_int16_le s i
let int24_le s i = int8 s i + String.get_uint16_le s (i + 1) lsl 8
let int32_le s i = String.get_int32_le s i |> Int32.to_int

let load file =
  let bmp = In_channel.with_open_bin file In_channel.input_all in
  if String.length bmp < 0x0e + 40 then
    failwith ("load_bmp: unsupported size " ^ string_of_int (String.length bmp) ^
      ", expected >=" ^ string_of_int (0x0e + 40));

  let info_size = int32_le bmp 0x0e in
  let width = int32_le bmp 0x12 in
  let height = int32_le bmp 0x16 in
  let planes = int16_le bmp 0x1a in
  let depth = int16_le bmp 0x1c in
  let compression = int32_le bmp 0x1e in
  let size = int32_le bmp 0x22 in
  let palette = int32_le bmp 0x2e in

  if height < 0 then
    failwith ("load_bmp: unsupported height " ^ string_of_int height);
  if planes <> 1 then
    failwith ("load_bmp: unsupported planes " ^ string_of_int planes);
  if depth <> 24 then
    failwith ("load_bmp: unsupported depth " ^ string_of_int depth);
  if compression <> 0 then
    failwith ("load_bmp: unsupported compression " ^ string_of_int compression);
  if size <> 0 then
    failwith ("load_bmp: unsupported size " ^ string_of_int size);
  if palette <> 0 then
    failwith ("load_bmp: unsupported palette " ^ string_of_int palette);

  let line_length = (3 * width + 3) land 0xffff_fffc in
  let expected_size = 0x0e + info_size + height * line_length in
  if String.length bmp <> expected_size then
    failwith ("load_bmp: unsupported size " ^ string_of_int (String.length bmp) ^
      ", expected " ^ string_of_int expected_size);

  let bitmap = Array.init height (fun _ -> Array.make width 0) in
  for y = 0 to height - 1 do
    let offset = 0x0e + info_size + (height - 1 - y) * line_length in
    for x = 0 to width - 1 do
      bitmap.(y).(x) <- int24_le bmp (offset + 3 * x)
    done
  done;
  bitmap
