vim.filetype.add({ extension = { ino = 'arduino' } })

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'arduino',
    group = vim.api.nvim_create_augroup('my.arduino', { clear = true }),
    callback = function(args)
        local opts = { buffer = args.buf, silent = true }

        local NODEMCU_FQBN = 'esp8266:esp8266:nodemcuv2'

        -- Returns { port, fqbn } . A recognized board (e.g. Uno) wins over an unrecognized one.
        local function detect_board()
            local handle = io.popen('arduino-cli board list --format json 2>/dev/null')
            if not handle then return nil end
            local result = handle:read('*a')
            handle:close()

            local ok, data = pcall(vim.json.decode, result)
            if not (ok and type(data) == 'table') then return nil end

            local fallback
            for _, entry in ipairs(data.detected_ports or data) do
                if entry.port and entry.port.protocol == 'serial' and entry.port.address then
                    local board = entry.matching_boards and entry.matching_boards[1]
                    if board and board.fqbn then
                        return { port = entry.port.address, fqbn = board.fqbn }
                    end
                    fallback = fallback or { port = entry.port.address, fqbn = nil }
                end
            end
            return fallback
        end

        -- Priority: manual override > detected board > NodeMCU
        local function resolve()
            local b = detect_board()
            local port = (b and b.port) or vim.g.arduino_port
            local fqbn = vim.g.arduino_fqbn or (b and b.fqbn) or NODEMCU_FQBN
            return port, fqbn
        end

        local function sketch_dir()
            return vim.fn.shellescape(vim.fn.expand('%:p:h'))
        end

        vim.keymap.set('n', '<leader>ac', function()
            local _, fqbn = resolve()
            vim.notify('Compiling for ' .. fqbn)
            vim.cmd('!arduino-cli compile --fqbn ' .. fqbn .. ' ' .. sketch_dir())
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Compile' }))

        vim.keymap.set('n', '<leader>au', function()
            local port, fqbn = resolve()
            if not port then
                vim.notify('No serial port found. Is the board plugged in?', vim.log.levels.ERROR)
                return
            end
            vim.notify('Uploading to ' .. port .. ' as ' .. fqbn)
            vim.cmd('!arduino-cli compile --fqbn ' .. fqbn .. ' --upload -v -p ' .. port .. ' ' .. sketch_dir())
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Compile + Upload' }))

        vim.keymap.set('n', '<leader>sm', function()
            local port = resolve()
            if not port then
                vim.notify('No serial port found.', vim.log.levels.ERROR)
                return
            end
            vim.cmd('split | terminal arduino-cli monitor -p ' .. port)
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Serial Monitor' }))

        vim.keymap.set('n', '<leader>bl', function()
            vim.cmd('!arduino-cli board list')
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: List Boards' }))

        vim.keymap.set('n', '<leader>fqb', function()
            vim.ui.input({ prompt = 'FQBN override (empty = auto): ', default = vim.g.arduino_fqbn or '' }, function(input)
                if input == nil then return end
                vim.g.arduino_fqbn = (input ~= '') and input or nil
            end)
        end, vim.tbl_extend('force', opts, { desc = 'Arduino: Set/Clear FQBN override' }))
    end,
})
