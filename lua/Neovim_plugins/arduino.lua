return {
  cmd = {
    "arduino-language-server",
    "-cli", "arduino-cli",
    "-cli-config", vim.fn.expand("~/.arduino15/arduino-cli.yaml"),
    "-fqbn", "esp8266:esp8266:nodemcuv2", -- your board's FQBN
  },
  filetypes = { "arduino" },
}
