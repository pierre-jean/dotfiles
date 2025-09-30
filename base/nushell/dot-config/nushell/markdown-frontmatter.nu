def "to mdfm" [cell_path = "body"] {
  let md = $in;
  let header = $md | reject --optional $cell_path | to yaml | str trim;
  let body = $md | get --optional $cell_path | to text;

$"---
($header)
---

($body)"
}

def "from mdfm" (cell_path = "body") {
  let header = $in | lines | skip | take until { |i|  $i == "---" } | str join (char nl) | from yaml;
  let body = $in | lines | skip | skip until { |i| $i == "---" } | skip | str join (char nl) | wrap $cell_path;

  $header | merge $body 
}

