{
  lib,
  runCommand,
  keil-uvision,
}:
runCommand "keil-uvision-smoke-test"
  {
    nativeBuildInputs = [ keil-uvision ];
  }
  ''
    if [ ! -x "$(command -v keil-uvision)" ]; then
      echo "FAIL: keil-uvision not found in PATH"
      exit 1
    fi
    echo "PASS: keil-uvision wrapper is present and executable"
    mkdir -p "$out"
    echo "true" > "$out/success"
  ''
