(*
 * Ported from https://www.bd-fans.com/Files/FanStuff/Programming/decodecaves.c
 *)

let data =
[|
  (* Boulder Dash 1 *)
  (* A *)
  "",
  "\x01\x14\x0A\x0F\x0A\x0B\x0C\x0D\x0E\x0C\x0C\x0C\x0C\x0C\x96\x6E" ^
  "\x46\x28\x1E\x08\x0B\x09\xD4\x20\x00\x10\x14\x00\x3C\x32\x09\x00" ^
  "\x42\x01\x09\x1E\x02\x42\x09\x10\x1E\x02\x25\x03\x04\x04\x26\x12" ^
  "\xFF";

  (* B *)
  "",
  "\x02\x14\x14\x32\x03\x00\x01\x57\x58\x0A\x0C\x09\x0D\x0A\x96\x6E" ^
  "\x46\x46\x46\x0A\x04\x09\x00\x00\x00\x10\x14\x08\x3C\x32\x09\x02" ^
  "\x42\x01\x08\x26\x02\x42\x01\x0F\x26\x02\x42\x08\x03\x14\x04\x42" ^
  "\x10\x03\x14\x04\x42\x18\x03\x14\x04\x42\x20\x03\x14\x04\x40\x01" ^
  "\x05\x26\x02\x40\x01\x0B\x26\x02\x40\x01\x12\x26\x02\x40\x14\x03" ^
  "\x14\x04\x25\x12\x15\x04\x12\x16\xFF";

  (* C *)
  "",
  "\x03\x00\x0F\x00\x00\x32\x36\x34\x37\x18\x17\x18\x17\x15\x96\x64" ^
  "\x5A\x50\x46\x09\x08\x09\x04\x00\x02\x10\x14\x00\x64\x32\x09\x00" ^
  "\x25\x03\x04\x04\x27\x14\xFF";

  (* D *)
  "",
  "\x04\x14\x05\x14\x00\x6E\x70\x73\x77\x24\x24\x24\x24\x24\x78\x64" ^
  "\x50\x3C\x32\x04\x08\x09\x00\x00\x10\x00\x00\x00\x14\x00\x00\x00" ^
  "\x25\x01\x03\x04\x26\x16\x81\x08\x0A\x04\x04\x00\x30\x0A\x0B\x81" ^
  "\x10\x0A\x04\x04\x00\x30\x12\x0B\x81\x18\x0A\x04\x04\x00\x30\x1A" ^
  "\x0B\x81\x20\x0A\x04\x04\x00\x30\x22\x0B\xFF";

  (* Intermission 1 *)
  "",
  "\x11\x14\x1E\x00\x0A\x0B\x0C\x0D\x0E\x06\x06\x06\x06\x06\x0A\x0A" ^
  "\x0A\x0A\x0A\x0E\x02\x09\x00\x00\x00\x14\x00\x00\xFF\x09\x00\x00" ^
  "\x87\x00\x02\x28\x16\x07\x87\x00\x02\x14\x0C\x00\x32\x0A\x0C\x10" ^
  "\x0A\x04\x01\x0A\x05\x25\x03\x05\x04\x12\x0C\xFF";

  (* E *)
  "",
  "\x05\x14\x32\x5A\x00\x00\x00\x00\x00\x04\x05\x06\x07\x08\x96\x78" ^
  "\x5A\x3C\x1E\x09\x0A\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" ^
  "\x25\x01\x03\x04\x27\x16\x80\x08\x0A\x03\x03\x00\x80\x10\x0A\x03" ^
  "\x03\x00\x80\x18\x0A\x03\x03\x00\x80\x20\x0A\x03\x03\x00\x14\x09" ^
  "\x0C\x08\x0A\x0A\x14\x11\x0C\x08\x12\x0A\x14\x19\x0C\x08\x1A\x0A" ^
  "\x14\x21\x0C\x08\x22\x0A\x80\x08\x10\x03\x03\x00\x80\x10\x10\x03" ^
  "\x03\x00\x80\x18\x10\x03\x03\x00\x80\x20\x10\x03\x03\x00\x14\x09" ^
  "\x12\x08\x0A\x10\x14\x11\x12\x08\x12\x10\x14\x19\x12\x08\x1A\x10" ^
  "\x14\x21\x12\x08\x22\x10\xFF";

  (* F *)
  "",
  "\x06\x14\x28\x3C\x00\x14\x15\x16\x17\x04\x06\x07\x08\x08\x96\x78" ^
  "\x64\x5A\x50\x0E\x0A\x09\x00\x00\x10\x00\x00\x00\x32\x00\x00\x00" ^
  "\x82\x01\x03\x0A\x04\x00\x82\x01\x06\x0A\x04\x00\x82\x01\x09\x0A" ^
  "\x04\x00\x82\x01\x0C\x0A\x04\x00\x41\x0A\x03\x0D\x04\x14\x03\x05" ^
  "\x08\x04\x05\x14\x03\x08\x08\x04\x08\x14\x03\x0B\x08\x04\x0B\x14" ^
  "\x03\x0E\x08\x04\x0E\x82\x1D\x03\x0A\x04\x00\x82\x1D\x06\x0A\x04" ^
  "\x00\x82\x1D\x09\x0A\x04\x00\x82\x1D\x0C\x0A\x04\x00\x41\x1D\x03" ^
  "\x0D\x04\x14\x24\x05\x08\x23\x05\x14\x24\x08\x08\x23\x08\x14\x24" ^
  "\x0B\x08\x23\x0B\x14\x24\x0E\x08\x23\x0E\x25\x03\x14\x04\x26\x14" ^
  "\xFF";

  (* G *)
  "",
  "\x07\x4B\x0A\x14\x02\x07\x08\x0A\x09\x0F\x14\x19\x19\x19\x78\x78" ^
  "\x78\x78\x78\x09\x0A\x0D\x00\x00\x00\x10\x08\x00\x64\x28\x02\x00" ^
  "\x42\x01\x07\x0C\x02\x42\x1C\x05\x0B\x02\x7A\x13\x15\x02\x02\x14" ^
  "\x04\x06\x14\x04\x0E\x14\x04\x16\x14\x22\x04\x14\x22\x0C\x14\x22" ^
  "\x16\x25\x14\x03\x04\x27\x07\xFF";

  (* H *)
  "",
  "\x08\x14\x0A\x14\x01\x03\x04\x05\x06\x0A\x0F\x14\x14\x14\x78\x6E" ^
  "\x64\x5A\x50\x02\x0E\x09\x00\x00\x00\x10\x08\x00\x5A\x32\x02\x00" ^
  "\x14\x04\x06\x14\x22\x04\x14\x22\x0C\x04\x00\x05\x25\x14\x03\x42" ^
  "\x01\x07\x0C\x02\x42\x01\x0F\x0C\x02\x42\x1C\x05\x0B\x02\x42\x1C" ^
  "\x0D\x0B\x02\x43\x0E\x11\x08\x02\x14\x0C\x10\x00\x0E\x12\x14\x13" ^
  "\x12\x41\x0E\x0F\x08\x02\xFF";

  (* Intermission 2 *)
  "",
  "\x12\x14\x0A\x00\x0A\x0B\x0C\x0D\x0E\x10\x10\x10\x10\x10\x0F\x0F" ^
  "\x0F\x0F\x0F\x06\x0F\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" ^
  "\x87\x00\x02\x28\x16\x07\x87\x00\x02\x14\x0C\x01\x50\x01\x03\x09" ^
  "\x03\x48\x02\x03\x08\x03\x54\x01\x05\x08\x03\x50\x01\x06\x07\x03" ^
  "\x50\x12\x03\x09\x05\x54\x12\x05\x08\x05\x50\x12\x06\x07\x05\x25" ^
  "\x01\x04\x04\x12\x04\xFF";

  (* I *)
  "",
  "\x09\x14\x05\x0A\x64\x89\x8C\xFB\x33\x4B\x4B\x50\x55\x5A\x96\x96" ^
  "\x82\x82\x78\x08\x04\x09\x00\x00\x10\x14\x00\x00\xF0\x78\x00\x00" ^
  "\x82\x05\x0A\x0D\x0D\x00\x01\x0C\x0A\x82\x19\x0A\x0D\x0D\x00\x01" ^
  "\x1F\x0A\x42\x11\x12\x09\x02\x40\x11\x13\x09\x02\x25\x07\x0C\x04" ^
  "\x08\x0C\xFF";

  (* J *)
  "",
  "\x0A\x14\x19\x3C\x00\x00\x00\x00\x00\x0C\x0C\x0C\x0C\x0C\x96\x82" ^
  "\x78\x6E\x64\x06\x08\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" ^
  "\x25\x0D\x03\x04\x27\x16\x54\x05\x04\x11\x03\x54\x15\x04\x11\x05" ^
  "\x80\x05\x0B\x11\x03\x08\xC2\x01\x04\x15\x11\x00\x0D\x04\xC2\x07" ^
  "\x06\x0D\x0D\x00\x0D\x06\xC2\x09\x08\x09\x09\x00\x0D\x08\xC2\x0B" ^
  "\x0A\x05\x05\x00\x0D\x0A\x82\x03\x06\x03\x0F\x08\x00\x04\x06\x54" ^
  "\x04\x10\x04\x04\xFF";

  (* K *)
  "",
  "\x0B\x14\x32\x00\x00\x04\x66\x97\x64\x06\x06\x06\x06\x06\x78\x78" ^
  "\x96\x96\xF0\x0B\x08\x09\x00\x00\x00\x10\x08\x00\x64\x50\x02\x00" ^
  "\x42\x0A\x03\x09\x04\x42\x14\x03\x09\x04\x42\x1E\x03\x09\x04\x42" ^
  "\x09\x16\x09\x00\x42\x0C\x0F\x11\x02\x42\x05\x0B\x09\x02\x42\x0F" ^
  "\x0B\x09\x02\x42\x19\x0B\x09\x02\x42\x1C\x13\x0B\x01\x14\x04\x03" ^
  "\x14\x0E\x03\x14\x18\x03\x14\x22\x03\x14\x04\x16\x14\x23\x15\x25" ^
  "\x14\x14\x04\x26\x11\xFF";

  (* L *)
  "",
  "\x0C\x14\x14\x00\x00\x3C\x02\x3B\x66\x13\x13\x0E\x10\x15\xB4\xAA" ^
  "\xA0\xA0\xA0\x0C\x0A\x09\x00\x00\x00\x10\x14\x00\x3C\x32\x09\x00" ^
  "\x42\x0A\x05\x12\x04\x42\x0E\x05\x12\x04\x42\x12\x05\x12\x04\x42" ^
  "\x16\x05\x12\x04\x42\x02\x06\x0B\x02\x42\x02\x0A\x0B\x02\x42\x02" ^
  "\x0E\x0F\x02\x42\x02\x12\x0B\x02\x81\x1E\x04\x04\x04\x00\x08\x20" ^
  "\x05\x81\x1E\x09\x04\x04\x00\x08\x20\x0A\x81\x1E\x0E\x04\x04\x00" ^
  "\x08\x20\x0F\x25\x03\x14\x04\x27\x16\xFF";

  (* Intermission 3 *)
  "",
  "\x13\x04\x0A\x00\x0A\x0B\x0C\x0D\x0E\x0E\x0E\x0E\x0E\x0E\x14\x14" ^
  "\x14\x14\x14\x06\x08\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" ^
  "\x87\x00\x02\x28\x16\x07\x87\x00\x02\x14\x0C\x00\x54\x01\x0C\x12" ^
  "\x02\x88\x0F\x09\x04\x04\x08\x25\x08\x03\x04\x12\x07\xFF";

  (* M *)
  "",
  "\x0D\x8C\x05\x08\x00\x01\x02\x03\x04\x32\x37\x3C\x46\x50\xA0\x9B" ^
  "\x96\x91\x8C\x06\x08\x0D\x00\x00\x10\x00\x00\x00\x28\x00\x00\x00" ^
  "\x25\x12\x03\x04\x0A\x03\x3A\x14\x03\x42\x05\x12\x1E\x02\x70\x05" ^
  "\x13\x1E\x02\x50\x05\x14\x1E\x02\xC1\x05\x15\x1E\x02\xFF";

  (* N *)
  "",
  "\x0E\x14\x0A\x14\x00\x00\x00\x00\x00\x1E\x23\x28\x2A\x2D\x96\x91" ^
  "\x8C\x87\x82\x0C\x08\x09\x00\x00\x10\x00\x00\x00\x00\x00\x00\x00" ^
  "\x81\x0A\x0A\x0D\x0D\x00\x70\x0B\x0B\x0C\x03\xC1\x0C\x0A\x03\x0D" ^
  "\xC1\x10\x0A\x03\x0D\xC1\x14\x0A\x03\x0D\x50\x16\x08\x0C\x02\x48" ^
  "\x16\x07\x0C\x02\xC1\x17\x06\x03\x04\xC1\x1B\x06\x03\x04\xC1\x1F" ^
  "\x06\x03\x04\x25\x03\x03\x04\x27\x14\xFF";

  (* O *)
  "",
  "\x0F\x08\x0A\x14\x01\x1D\x1E\x1F\x20\x0F\x14\x14\x19\x1E\x78\x78" ^
  "\x78\x78\x8C\x08\x0E\x09\x00\x00\x00\x10\x08\x00\x64\x50\x02\x00" ^
  "\x42\x02\x04\x0A\x03\x42\x0F\x0D\x0A\x01\x41\x0C\x0E\x03\x02\x43" ^
  "\x0C\x0F\x03\x02\x04\x14\x16\x25\x14\x03\xFF";

  (* P *)
  "",
  "\x10\x14\x0A\x14\x01\x78\x81\x7E\x7B\x0C\x0F\x0F\x0F\x0C\x96\x96" ^
  "\x96\x96\x96\x09\x0A\x09\x00\x00\x10\x00\x00\x00\x32\x00\x00\x00" ^
  "\x25\x01\x03\x04\x27\x04\x81\x08\x13\x04\x04\x00\x08\x0A\x14\xC2" ^
  "\x07\x0A\x06\x08\x43\x07\x0A\x06\x02\x81\x10\x13\x04\x04\x00\x08" ^
  "\x12\x14\xC2\x0F\x0A\x06\x08\x43\x0F\x0A\x06\x02\x81\x18\x13\x04" ^
  "\x04\x00\x08\x1A\x14\x81\x20\x13\x04\x04\x00\x08\x22\x14\xFF";

  (* Intermission 4 *)
  "",
  "\x14\x03\x1E\x00\x00\x00\x00\x00\x00\x06\x06\x06\x06\x06\x14\x14" ^
  "\x14\x14\x14\x06\x08\x09\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00" ^
  "\x87\x00\x02\x28\x16\x07\x87\x00\x02\x14\x0C\x01\xD0\x0B\x03\x03" ^
  "\x02\x80\x0B\x07\x03\x06\x00\x43\x0B\x06\x03\x02\x43\x0B\x0A\x03" ^
  "\x02\x50\x08\x07\x03\x03\x25\x03\x03\x04\x09\x0A\xFF";

  (* Boulder Dash 2 *)
  (* A *)
  "\x08\x0b\x09",
  "\x19\x0f\x0f\xf0\xa0\x78\x64\x64\x0a\x0a\x0a\x14\x14\x0b\x0c\x0d" ^
  "\x0e\x0f\x32\x05\x00\x00\x10\x14\x00\x00\x00\x02\x01\x13\x08\x0b" ^
  "\x00\x02\x0b\x01\x04\x13\x00\x01\x06\x03\x04\x0e\x00\x03\x07\x03" ^
  "\x04\x0e\x00\x01\x0a\x03\x04\x0e\x00\x07\x01\x21\x08\x10\x03\x10" ^
  "\x05\x14\x02\x01\x01\x15\x10\x0c\x01\x00\x07\x10\x21\x0c\x14\x02" ^
  "\x00\x11\x0f\x04\x18\x00\x04\x0a\x11\x10\x01\x04\x01\x06\x04\x01" ^
  "\x11\x12\x04\x04\x01\x06\x04\x03\x01\x16\x03\x06\x02\x02\x04\x03" ^
  "\x01\x17\x03\x03\x02\x04\x04\x03\x02\x16\x01\x03\x01\x04\x03\x03" ^
  "\x04\x1c\x03\x03\x04\x20\x03\x03\x04\x16\x00\x01\x05\x17\x04\x02" ^
  "\x03\x25\x03\x25\x03\x04\x12\x05\xff";

  (* B *)
  "\x05\x04\x09",
  "\x19\x03\x0a\xc8\xbe\xb4\xaa\xa0\x4b\x50\x55\x5a\x5f\x64\x89\x8c" ^
  "\xfb\x33\xfe\x7f\x00\x00\x10\x3a\x00\x00\x00\x07\x0f\x01\x04\x1e" ^
  "\x02\x00\x10\x01\x05\x26\x00\x02\x07\x00\x01\x10\x07\x07\x02\x07" ^
  "\x00\x0b\x10\x07\x07\x02\x07\x00\x15\x10\x07\x07\x02\x07\x00\x1f" ^
  "\x10\x08\x07\x04\x10\x0e\x09\x01\x03\x01\x0a\x04\x01\x0f\x09\x01" ^
  "\x03\x01\x0a\x00\x10\x01\x01\x04\x26\x00\x01\x02\x01\x04\x26\x00" ^
  "\x01\x03\x01\x04\x26\x01\x00\x01\x02\x0f\x02\x01\x00\x01\x24\x0f" ^
  "\x02\x03\x25\x10\x03\x03\x04\x10\x26\xff";

  (* C *)
  "\x04\x08\x09",
  "\x00\x19\x32\x96\x96\x96\x96\xc8\x10\x0c\x12\x0f\x0f\x18\x2d\x34" ^
  "\x1e\x28\x78\x32\x0f\x09\x00\x10\x08\x14\x00\x07\x04\x07\x04\x20" ^
  "\x00\x07\x04\x07\x08\x0c\x00\x07\x10\x07\x04\x1a\x00\x07\x10\x20" ^
  "\x00\x08\x00\x07\x08\x0e\x04\x13\x00\x07\x08\x0e\x08\x05\x00\x07" ^
  "\x0c\x0e\x04\x0c\x03\x25\x03\x25\x03\x04\x0a\x12\xff";

  (* D *)
  "\x05\x08\x09",
  "\x8c\x05\x08\x50\x46\x3c\x32\x28\x32\x34\x36\x38\x3a\x00\x01\x02" ^
  "\x03\x04\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x02\x05\x04\x0a" ^
  "\x03\x10\x02\x0f\x00\x08\x05\x05\x04\x0a\x03\x10\x05\x0f\x00\x08" ^
  "\x08\x05\x04\x0a\x03\x10\x08\x0f\x01\x3a\x01\x16\x14\x02\x00\x02" ^
  "\x0a\x15\x08\x0b\x02\x14\x01\x18\x14\x0f\x01\x01\x01\x0a\x12\x03" ^
  "\x03\x03\x25\x0b\x13\x03\x04\x0a\x01\xff";

  (* Intermission 1 *)
  "\x0e\x02\x09",
  "\x14\x1e\x1e\x14\x14\x14\x14\x14\x01\x01\x01\x01\x01\x00\x00\x00" ^
  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x00\x00\x16\x28" ^
  "\x07\x02\x07\x00\x00\x0c\x14\x01\x02\x10\x02\x05\x07\x07\x08\x03" ^
  "\x14\x05\x08\x03\x25\x03\x03\x03\x04\x0a\x02\xff";

  (* E *)
  "\x06\x0c\x09",
  "\x02\x14\x28\x1e\x1e\x1e\x1e\x1e\x05\x08\x0a\x0a\x0a\x1e\x1f\x20" ^
  "\x21\x22\xff\x7f\x00\x00\x10\x14\x00\x00\x02\x00\x07\x01\x0e\x26" ^
  "\x00\x02\x01\x01\x14\x14\x13\x01\x04\x3e\x05\x01\x03\x13\x02\x01" ^
  "\x00\x3e\x12\x01\x04\x13\x07\xe0\x00\x03\x14\x01\x04\x13\x03\x25" ^
  "\x11\x03\x03\x04\x12\x23\xff";

  (* F *)
  "\x09\x0a\x09",
  "\x00\x05\x50\xc8\xc8\xc8\xc8\xc8\x1e\x28\x20\x20\x2a\x0a\x0b\x0c" ^
  "\x0d\x0e\xdc\x50\x00\x00\x10\x14\x00\x00\x01\x01\x01\x01\x14\x26" ^
  "\x02\x01\x0a\x01\x03\x26\x02\x02\x01\x01\x01\x14\x0f\x01\x02\x01" ^
  "\x01\x19\x14\x0e\x01\x00\x02\x02\x0e\x08\x12\x00\x02\x02\x1a\x08" ^
  "\x12\x03\x25\x02\x01\x03\x04\x05\x02\x02\x00\x01\x04\x14\x05\x00" ^
  "\x00\x07\x02\x03\x08\x13\x00\x07\x01\x09\x08\x13\x04\x07\x03\x05" ^
  "\x06\x03\x03\x01\x04\x08\x02\x06\x03\x01\x06\x01\x04\x0a\x07\x06" ^
  "\x03\x01\x06\x01\xff";

  (* G *)
  "\x0a\x04\x09",
  "\x00\x14\x32\xc8\xb4\xb4\x96\x96\x08\x0e\x0f\x0f\x0c\x0a\x0b\x0f" ^
  "\x0d\x0e\x78\x32\x0f\x09\x00\x10\x08\x14\x04\x02\x02\x02\x05\x09" ^
  "\x04\x04\x04\x02\x02\x03\x05\x09\x04\x04\x06\x08\x10\x28\x02\x02" ^
  "\x04\x0b\x0a\x0d\x00\x00\x10\x05\x0b\x04\x0f\x00\x01\x06\x0b\x04" ^
  "\x0f\x04\x02\x05\x0b\x08\x05\x01\x03\x01\x07\x00\x00\x16\x28\x03" ^
  "\x25\x0b\x09\x03\x04\x0b\x0c\xff";

  (* H *)
  "\x05\x09\x09",
  "\x78\x05\x0a\xc8\xa0\x78\x64\x50\x1e\x28\x32\x3c\x46\x00\x00\x00" ^
  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x01\x00\x02\x02\x08\x0c" ^
  "\x04\x31\x09\x04\x01\x05\x01\x02\x04\x30\x02\x0d\x04\x01\x02\x01" ^
  "\x04\x33\x02\x03\x01\x05\x01\x02\x00\x02\x01\x14\x08\x0f\x00\x3a" ^
  "\x01\x19\x04\x0a\x03\x25\x01\x01\x03\x04\x04\x13\xff";

  (* Intermission 2 *)
  "\x06\x0f\x09",
  "\x14\x0a\x00\x1e\x19\x14\x14\x14\x06\x06\x06\x06\x06\x00\x00\x00" ^
  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x00\x00\x16\x28" ^
  "\x07\x02\x07\x00\x00\x0c\x14\x01\x02\x00\x03\x03\x03\x03\x14\x02" ^
  "\x00\x03\x08\x03\x03\x14\x02\x00\x03\x0d\x03\x03\x14\x02\x00\x07" ^
  "\x03\x03\x03\x14\x02\x00\x07\x08\x03\x03\x14\x02\x00\x07\x0d\x03" ^
  "\x03\x14\x04\x08\x03\x05\x01\x03\x01\x05\x04\x30\x07\x03\x01\x03" ^
  "\x01\x05\x03\x25\x02\x01\x03\x04\x0a\x12\xff";

  (* I *)
  "\x0b\x08\x09",
  "\x14\x05\x32\xa0\x8c\x78\x64\x50\x4b\x4b\x4b\x4b\x4b\x00\x00\x00" ^
  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x00\x01\x01\x14\x26" ^
  "\x00\x04\x14\x02\x03\x05\x11\x04\x02\x04\x01\x02\x04\x05\x11\x04" ^
  "\x02\x04\x07\x03\x03\x05\x22\x04\x01\x01\x00\x01\x0c\x08\x02\x01" ^
  "\x00\x01\x1c\x08\x02\x04\x08\x01\x04\x05\x01\x04\x01\x04\x08\x01" ^
  "\x14\x05\x01\x04\x01\x04\x08\x01\x24\x05\x01\x04\x01\x02\x00\x09" ^
  "\x11\x0c\x06\x00\x00\x07\x0a\x13\x08\x0a\x04\x14\x0a\x14\x05\x01" ^
  "\x02\x01\x04\x01\x0b\x14\x05\x01\x02\x01\x03\x08\x09\x13\x03\x25" ^
  "\x0d\x01\x03\x04\x0d\x26\xff";

  (* J *)
  "\x06\x08\x09",
  "\x14\x05\x0a\xc8\xb4\xa0\x8c\x78\x12\x1b\x24\x2d\x36\x01\x02\x03" ^
  "\x04\x05\x01\x00\x00\x00\x10\x00\x00\x00\x04\x08\x03\x03\x02\x04" ^
  "\x09\x07\x04\x30\x03\x04\x02\x04\x09\x07\x04\x10\x04\x03\x02\x04" ^
  "\x09\x07\x04\x10\x04\x04\x02\x04\x09\x07\x03\x25\x0a\x07\x03\x04" ^
  "\x0f\x1e\xff";

  (* K *)
  "\x08\x0e\x09",
  "\x02\x0f\x1e\x3c\x3c\x3c\x3c\x3c\x15\x18\x13\x17\x1b\x0a\x0b\x0c" ^
  "\x0d\x0f\x0f\x00\x00\x00\x14\x00\x00\x00\x01\x01\x01\x01\x14\x26" ^
  "\x00\x08\x01\x01\x04\x19\x00\x01\x02\x01\x04\x26\x03\x10\x02\x0a" ^
  "\x02\x02\x03\x09\x03\x03\x00\x00\x01\x03\x09\x04\x03\x06\x14\x03" ^
  "\x28\x03\x25\x03\x0a\x03\x04\x12\x23\xff";

  (* L *)
  "\x09\x0a\x09",
  "\x4b\x0f\x0f\xf0\xdc\xc8\xaa\x96\x23\x24\x21\x25\x22\x0c\x08\x07" ^
  "\x09\x0b\x5a\x14\x00\x00\x10\x14\x00\x00\x04\x02\x06\x01\x03\x24" ^
  "\x06\x01\x04\x02\x01\x06\x12\x06\x01\x06\x04\x00\x06\x03\x03\x06" ^
  "\x06\x06\x04\x00\x03\x06\x03\x06\x06\x06\x00\x01\x01\x26\x08\x14" ^
  "\x00\x01\x14\x01\x04\x26\x03\x25\x03\x15\x03\x04\x06\x25\xff";

  (* Intermission 3 *)
  "\x06\x08\x09",
  "\x14\x19\x3c\x1e\x19\x14\x14\x14\x02\x02\x02\x02\x02\x00\x00\x00" ^
  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x00\x00\x16\x28" ^
  "\x07\x02\x07\x00\x00\x0c\x14\x00\x00\x08\x01\x03\x06\x09\x00\x08" ^
  "\x07\x0d\x02\x05\x04\x01\x01\x02\x0a\x09\x01\x02\x03\x14\x05\x0e" ^
  "\x03\x14\x05\x10\x03\x25\x02\x01\x03\x04\x05\x12\xff";

  (* M *)
  "\x06\x0a\x09",
  "\x05\x02\x0a\xc8\xc8\xc8\xc8\xb4\x01\x14\x14\x28\x32\x89\x8c\x64" ^
  "\xfb\x33\xff\x7f\x00\x00\x10\x14\x00\x00\x02\x10\x10\x01\x05\x26" ^
  "\x10\x04\x07\x01\x02\x09\x13\x02\x02\x04\x01\x02\x02\x09\x13\x02" ^
  "\x02\x00\x3e\x12\x01\x04\x26\x07\x00\x01\x01\x13\x01\x02\x26\x01" ^
  "\x01\x01\x25\x14\x02\x03\x25\x13\x02\x03\x04\x0d\x02\xff";

  (* N *)
  "\x09\x08\x09",
  "\x00\x14\x01\xc8\xb4\xa0\x8c\x78\x15\x15\x15\x15\x15\x0f\x10\x11" ^
  "\x12\x13\x3c\x00\x00\x00\x10\x00\x00\x00\x01\x00\x01\x01\x14\x26" ^
  "\x01\x01\x02\x02\x0c\x24\x02\x00\x0e\x01\x07\x26\x00\x04\x08\x13" ^
  "\x01\x01\x09\x01\x02\x04\x08\x14\x01\x01\x13\x01\x02\x02\x01\x0e" ^
  "\x13\x07\x03\x00\x04\x14\x02\x05\x03\x07\x04\x05\x03\x25\x11\x14" ^
  "\x03\x04\x13\x14\xff";

  (* O *)
  "\x0e\x0a\x09",
  "\x0a\x0a\x0a\xc8\x96\x85\x7d\x78\x24\x24\x24\x24\x24\x00\x00\x00" ^
  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x01\x06\x03\x07\x07" ^
  "\x00\x03\x30\x08\x04\x03\x10\x05\x06\x02\x02\x06\x0c\x0a\x07\x01" ^
  "\x00\x02\x10\x0c\x04\x07\x02\x00\x07\x0d\x05\x05\x00\x00\x01\x06" ^
  "\x0d\x04\x05\x04\x2a\x06\x0c\x01\x04\x01\x02\x03\x30\x08\x0d\x03" ^
  "\x01\x07\x0f\x03\x10\x06\x0f\x02\x00\x08\x13\x09\x0a\x00\x02\x01" ^
  "\x09\x15\x07\x07\x00\x00\x02\x09\x14\x04\x08\x03\x30\x0b\x16\x03" ^
  "\x10\x01\x18\x03\x10\x03\x18\x02\x01\x06\x1e\x07\x07\x00\x03\x30" ^
  "\x08\x1f\x03\x10\x07\x1e\x00\x03\x0c\x1e\x04\x07\x00\x03\x0d\x1e" ^
  "\x04\x07\x03\x25\x12\x03\x03\x04\x03\x26\xff";
        
  (* P *)
  "\x09\x0a\x09",
  "\x00\x0a\x28\xc8\xc8\xc8\xc8\xc8\x14\x0f\x11\x0f\x14\x0a\x0b\x0c" ^
  "\x0d\x0e\xbd\xb3\x13\x00\x00\x10\x14\x00\x01\x01\x01\x01\x14\x26" ^
  "\x03\x25\x02\x03\x03\x04\x0b\x14\xff";

  (* Intermission 4 *)
  "\x06\x08\x09",
  "\x14\x0a\x14\x14\x14\x14\x14\x14\x01\x01\x01\x01\x01\x00\x00\x00" ^
  "\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x02\x07\x00\x00\x16\x28" ^
  "\x07\x02\x07\x00\x00\x0c\x14\x01\x02\x00\x05\x06\x03\x03\x10\x02" ^
  "\x00\x02\x0a\x03\x03\x14\x03\x08\x02\x0c\x03\x25\x01\x02\x02\x08" ^
  "\x08\x0a\x03\x03\x04\x00\x07\x08\x0c\x08\x03\xff";
|]

type color = int * int * int
let colors =  (* C64 colors, http://unusedino.de/ec64/technical/misc/vic656x/colors/ *)
[|
  0x00, 0x00, 0x00;  (* black *)
  0xff, 0xff, 0xff;  (* white *)
  0x74, 0x43, 0x35;  (* red *)
  0x7c, 0xac, 0xba;  (* cyan *)
  0x7b, 0x48, 0x90;  (* purple *)
  0x64, 0x97, 0x4f;  (* green *)
  0x40, 0x32, 0x85;  (* blue *)
  0xbf, 0xcd, 0x7a;  (* yellow *)
  0x7b, 0x5b, 0x2f;  (* orange *)
  0x4f, 0x45, 0x00;  (* brown *)
  0xa3, 0x72, 0x65;  (* light red *)
  0x50, 0x50, 0x50;  (* dark grey *)
  0x78, 0x78, 0x78;  (* grey *)
  0xa4, 0xd7, 0x8e;  (* light green *)
  0x78, 0x6a, 0xbd;  (* light blue *)
  0x9f, 0x9f, 0x9f;  (* light grey *)
|]

let tiles = let open Cave in function
  | 0x00 -> Space
  | 0x01 -> Dirt
  | 0x02 -> Wall
  | 0x03 -> Mill Inactive
  | 0x04 -> Exit Inactive
  | 0x07 -> Steel
  | 0x08 -> Firefly Left
  | 0x09 -> Firefly Up
  | 0x0a -> Firefly Right
  | 0x0b -> Firefly Down
  | 0x10 -> Boulder Resting
  | 0x14 -> Diamond Resting
  | 0x25 -> entry
  | 0x2a -> Expander
  | 0x30 -> Butterfly Left
  | 0x31 -> Butterfly Up
  | 0x32 -> Butterfly Right
  | 0x33 -> Butterfly Down
  | 0x3a -> Amoeba
  | 0x3e -> Slime
  | i -> failwith ("tile " ^ string_of_int i)

(*
 * http://www.bd-fans.com/Files/FanStuff/Programming/decodecaves.c
 *)
let split i = i land 0xff, i lsr 8
let random (seed1, seed2) =
  let tmp1 = (!seed1 land 0x01) lsl 7 in
  let tmp2 = (!seed2 lsr 1) land 0x7f in
  let result, carry = split (!seed2 + (!seed2 land 0x01) lsl 7) in
  let result, carry = split (result + carry + 0x13) in
  seed2 := result;
  let result, carry = split (!seed1 + carry + tmp1) in
  let result, _carry = split (result + carry + tmp2) in
  seed1 := result;
  result


let count = Array.length data

(*
 * http://www.gratissaugen.de/erbsen/BD-Inside-FAQ.html
 *)
let level i difficulty =
  let s1, s2 = data.(i) in
  let col = Array.init (String.length s1) (fun i -> Char.code s1.[i]) in
  let data = Array.init (String.length s2) (fun i -> Char.code s2.[i]) in
  let bd1 = i < 20 in

  let mill_time = float_of_int data.(if bd1 then 0x01 else 0x00) in
  let amoeba_time = float_of_int data.(if bd1 then 0x01 else 0x00) in
  let value = data.(if bd1 then 0x02 else 0x01) in
  let extra = data.(if bd1 then 0x03 else 0x02) in
  let seeds = ref 0, ref data.((if bd1 then 0x04 else 0x0d) + difficulty - 1) in
  let needed = data.((if bd1 then 0x09 else 0x08) + difficulty - 1) in
  let time = float_of_int (data.((if bd1 then 0x0e else 0x03) + difficulty - 1)) in
  let color1 = colors.(if bd1 then data.(0x13) else col.(0x00)) in
  let color2 = colors.(if bd1 then data.(0x14) else col.(0x01)) in
  let color3 = colors.(if bd1 then data.(0x15) - 8 else 1) in
  let randoms = Array.init 4 (fun i -> data.((if bd1 then 0x18 else 0x16) + i)) in
  let probability = Array.init 4 (fun i -> data.((if bd1 then 0x1c else 0x12) + i)) in

  (* Timings are rough estimates *)
  let intermission = (i + 1) mod 5 = 0 in
  let j = i mod 20 in
  let letter = Char.chr (if intermission then j/5 + 49 else (j + 1)*4/5 + 65) in
  let name = (if bd1 then "1" else "2") ^ String.make 1 letter in
  let speed = float (7 + difficulty + 2 * Bool.to_int intermission) in
  let width, height = if intermission then 20, 12 else 40, 22 in
  let cave = Cave.make
    width height name difficulty intermission speed needed value extra
    time mill_time amoeba_time 8
  in

  let single tile x y =
    if x < width && y < height then  (* clip for intermissions *)
      cave.map.(y).(x).tile <- tile;
    if tile = Cave.entry then cave.rockford.pos <- (x, y)
  in
  let line tile x y len dx dy =
    for i = 0 to len - 1 do
      single tile (x + i*dx) (y + i*dy)
    done
  in
  let rect tile x y w h =
    line tile x y w 1 0;
    line tile x (y + h - 1) w 1 0;
    line tile x y h 0 1;
    line tile (x + w - 1) y h 0 1
  in
  let fill tile x y w h =
    for i = 0 to h - 1 do
      line tile x (y + i) w 1 0
    done
  in
  let raster tile x y w h dx dy =
    for j = 0 to h - 1 do
      for i = 0 to w - 1 do
        single tile (x + i*dx) (y + j*dy)
      done
    done
  in
  let delta i =
    [| 0, -1; +1, -1; +1, 0; +1, +1; 0, +1; -1, +1; -1, 0; -1, -1|].(i)
  in

  let rec interpret1 i =
    if data.(i) <> 0xff then
    let code = data.(i) lsr 6 in
    let tile = tiles (data.(i) land 0x3f) in
    let x = data.(i + 1) in
    let y = data.(i + 2) - 2 in
    match code with
    | 0 ->
      single tile x y;
      interpret1 (i + 3)
    | 1 ->
      let len = data.(i + 3) in
      let dir = data.(i + 4) in
      let dx, dy = delta dir in
      line tile x y len dx dy;
      interpret1 (i + 5)
    | 2 ->
      let w = data.(i + 3) in
      let h = data.(i + 4) in
      let filler = tiles data.(i + 5) in
      rect tile x y w h;
      fill filler (x + 1) (y + 1) (w - 2) (h - 2);
      interpret1 (i + 6)
    | 3 ->
      let w = data.(i + 3) in
      let h = data.(i + 4) in
      rect tile x y w h;
      interpret1 (i + 5)
    | _ -> failwith "Levels.interpret1"
  in

  let rec interpret2 i =
    if data.(i) <> 0xff then
    let code = data.(i) in
    let tile = if code <= 6 then tiles (data.(i + 1)) else Space in
    let y = if code <= 4 then data.(i + 2) else -1 in
    let x = if code <= 4 then data.(i + 3) else -1 in
    match code with
    | 0 ->
      let dir = data.(i + 4) lsr 1 in
      let len = data.(i + 5) in
      let dx, dy = delta dir in
      line tile x y len dx dy;
      interpret2 (i + 6)
    | 1 ->
      let h = data.(i + 4) in
      let w = data.(i + 5) in
      rect tile x y w h;
      interpret2 (i + 6)
    | 2 ->
      let h = data.(i + 4) in
      let w = data.(i + 5) in
      let filler = tiles data.(i + 6) in
      rect tile x y w h;
      fill filler (x + 1) (y + 1) (w - 2) (h - 2);
      interpret2 (i + 7)
    | 3 ->
      single tile x y;
      interpret2 (i + 4)
    | 4 ->
      let h = data.(i + 4) in
      let w = data.(i + 5) in
      let dy = data.(i + 6) in
      let dx = data.(i + 7) in
      raster tile x y w h dx dy;
      interpret2 (i + 8)
    | 6 ->
      let tile' = tiles data.(i + 2) in
      let d = data.(i + 3) in
      for y = 0 to height - 1 do
        for x = 0 to width - 1 do
          if cave.map.(y).(x).tile = tile then
            single tile' ((x + d) mod width) (y + (x + d) / width)
        done
      done;
      interpret2 (i + 4)
    | 7 ->
      let _permeability = data.(i + 1) in
      (* TODO *)
      interpret2 (i + 2)
    | _ -> failwith "Levels.interpret2"
  in

  for y = 1 to height - 2 do
    for x = 0 to width - 1 do
      let tile = ref Cave.Dirt in
      let k = random seeds in
      for i = 0 to Array.length randoms - 1 do
        if k < probability.(i) then tile := tiles randoms.(i)
      done;
      single !tile x y
    done
  done;
  rect Cave.Steel 0 0 width height;
  if bd1 then interpret1 0x20 else interpret2 0x1a;

  cave, (color1, color2, color3)
