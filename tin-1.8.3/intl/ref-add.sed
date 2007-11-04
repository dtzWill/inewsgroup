/^# Packages using this file: / {
  s/# Packages using this file://
  ta
  :a
  s/ tin / tin /
  tb
  s/ $/ tin /
  :b
  s/^/# Packages using this file:/
}
