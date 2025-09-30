def --env gotmp [] {
  mktemp --directory | cd $in
}
