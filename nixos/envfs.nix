{ ... }: {
  # Emulates paths /bin/xxx and /usr/bin/xxx by searching for the binaries in
  # $PATH. Useful for things like bash scripts with '#!/bin/bash' hardcoded.
  # Only applies to binaries, nothing else.
  services.envfs.enable = true;
}
