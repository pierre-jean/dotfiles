$env.HOMEBREW_PREFIX = "/home/linuxbrew/.linuxbrew"
$env.HOMEBREW_CELLAR = "/home/linuxbrew/.linuxbrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/home/linuxbrew/.linuxbrew/Homebrew"
$env.HOMEBREW_BIN = $"($env.HOMEBREW_PREFIX)/bin"
$env.HOMEBREW_SBIN = $"($env.HOMEBREW_PREFIX)/sbin"
$env.PATH = ($env.PATH | split row (char esep) | prepend ($env.HOMEBREW_SBIN) | prepend ($env.HOMEBREW_BIN))
$env.INFOPATH = $env.INFOPATH? | default [] | prepend $"($env.HOMEBREW_PREFIX)/share/info"
