vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),

  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)



    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
      if client.server_capabilities.documentSymbolProvider then
        local navic = require("nvim-navic")
        navic.attach(client, event.buf)
      end

    end

    -- AUTOCOMPLETADO NATIVO CON PREVIEW DE DOCUMENTACIÓN
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_completion) then
      vim.opt.completeopt = {
        'menu',     -- Muestra el menú de completado aunque haya una sola opción
        'menuone',  -- Muestra el menú incluso con una sola coincidencia
        'noinsert', -- No inserta automáticamente la primera opción
        'noselect', -- No preselecciona ningún item (IMPORTANTE para popup)
        'fuzzy',    -- Permite búsqueda difusa/aproximada (NUEVO en 0.11)
        'popup'     -- Muestra documentación en ventana popup (NUEVO en 0.11)
      }


      vim.keymap.set('i', '<Down>', function()
        return vim.fn.pumvisible() == 1 and '<C-n>' or '<Down>'
      end, { buffer = event.buf, expr = true })

      vim.keymap.set('i', '<Up>', function()
        return vim.fn.pumvisible() == 1 and '<C-p>' or '<Up>'
      end, { buffer = event.buf, expr = true })

      vim.lsp.completion.enable(true, client.id, event.buf, { autotrigger = true })

      -- AUTOCOMANDO PARA MOSTRAR DOCUMENTACIÓN EN EL POPUP
      vim.api.nvim_create_autocmd('CompleteChanged', {
        buffer = event.buf,
        callback = function()
          local info = vim.fn.complete_info({ 'selected' })

          -- Verificar que hay un item seleccionado
          if info.selected == -1 then
            return
          end

          -- Obtener el completion item del LSP
          local completionItem = vim.tbl_get(vim.v.completed_item, 'user_data', 'nvim', 'lsp', 'completion_item')
          if not completionItem then
            return
          end

          -- Si ya tiene documentación, no necesitamos resolver
          if completionItem.documentation then
            return
          end

          -- Hacer request para resolver la documentación
          client.request(vim.lsp.protocol.Methods.completionItem_resolve, completionItem, function(err, result)
            if err or not result then
              return
            end

            -- Si el resultado tiene documentación, mostrarla en el popup
            if result.documentation then
              local doc_value = ''
              if type(result.documentation) == 'string' then
                doc_value = result.documentation
              elseif result.documentation.value then
                doc_value = result.documentation.value
              end

              if doc_value ~= '' then
                -- Usar la API interna para actualizar el popup
                local winData = vim.api.nvim__complete_set(info.selected, { info = doc_value })

                -- Configurar el popup window si es válido
                if winData and winData.winid and vim.api.nvim_win_is_valid(winData.winid) then
                  vim.api.nvim_win_set_config(winData.winid, { border = 'rounded' })

                  -- Aplicar sintaxis markdown si el contenido lo amerita
                  if winData.bufnr and vim.api.nvim_buf_is_valid(winData.bufnr) then
                    vim.treesitter.start(winData.bufnr, 'markdown')
                    vim.wo[winData.winid].conceallevel = 3
                  end
                end
              end
            end
          end, event.buf)
        end
      })

      vim.keymap.set('i', '<C-Space>', function()
        vim.lsp.completion.get()
      end, { buffer = event.buf })
    end

    -- KEYMAPS BÁSICOS LSP
    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end
    map("gl", vim.diagnostic.open_float, "Open Diagnostic Float")
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("gs", vim.lsp.buf.signature_help, "Signature Documentation")
    map("gD", vim.lsp.buf.declaration, "Goto Declaration")
    map("<leader>v", "<cmd>vsplit | lua vim.lsp.buf.definition()<cr>", "Goto Definition in Vertical Split")
    --
    -- -- KEYMAPS AVANZADOS (requiere which-key plugin)
    local wk = require("which-key")
    wk.add({
      { "<leader>la", vim.lsp.buf.code_action, desc = "Code Action" },
      { "<leader>lr", vim.lsp.buf.rename,      desc = "Rename all references" },
      { "<leader>lf", vim.lsp.buf.format,      desc = "Format" },
    })

    -- HIGHLIGHT DE REFERENCIAS (resalta palabra bajo cursor)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- INLAY HINTS (muestra tipos inline)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
      map('<leader>th', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
      end, 'Toggle Inlay Hints')
    end
  end,
})
