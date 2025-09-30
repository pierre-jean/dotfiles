
def --wrapped sops [--init: string, --from-stdin (-s), --type (-t): string, --init: string, ...rest:string] {
  mut input = $in
  mut extra_args = []
  if ( $type | is-not-empty) {
    $extra_args = $extra_args | append "--output-type" | append $type
  }

  if ($init | is-not-empty) {
    if ($input | is-empty) { $input = {} }
  }

  # sops decrypt -t yaml -i yolo.json
  if ($from_stdin) {
    if ( ($input | describe) != "string" ) {
      $input = $input | to json
      $extra_args = $extra_args | append "--input-type" | append "json"
    }
    $extra_args = $extra_args | append "/dev/stdin"
  }

  let result = ($input | ^sops ...($rest ++ $extra_args) )

  if ($init | is-not-empty) {
    $result | save $init
  } else {
    $result
  }

}

def "sops init" [file_path, ...rest] {
  if (("--type" in $rest) or ("-t" in $rest ) or ("--output-type" in $rest))  {
    {} | sops --from-stdin --encrypt ...$rest | save $file_path
  } else {
     let output_type = $file_path | path parse | get extension 
    {} | sops --type $output_type --from-stdin --encrypt ...$rest | save $file_path
  }
}
