def bwsession [] {
  with-env { BW_SESSION: ($env.BW_SESSION? | default (bw unlock --raw)) } { nu }
}
