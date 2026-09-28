return {
  cmd = {
    "arduino-language-server",
    "-cli", "arduino-cli",
    "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
    "-fqbn", "arduino:avr:uno" , "esp8266:esp8266:nodemcuv2", -- your board's FQBN
  },
  filetypes = { "arduino" },
}
