vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)


-- BREADCRUMBS NATIVOS USANDO LSP documentSymbol y winbar
-- Agregar esto a tu autocomando LspAttach después de los keymaps

-- BREADCRUMBS EN WINBAR (contexto como VS Code)
    if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentSymbol) then
      -- Variables para cache de símbolos
      local symbols_cache = {}
      local last_update_tick = 0
      
      -- Función para obtener símbolos del documento
      local function get_document_symbols()
        local params = { textDocument = vim.lsp.util.make_text_document_params() }
        
        client.request(vim.lsp.protocol.Methods.textDocument_documentSymbol, params, function(err, result)
          if err or not result then
            return
          end
          
          symbols_cache = result
          last_update_tick = vim.api.nvim_buf_get_changedtick(event.buf)
          update_winbar()
        end, event.buf)
      end
      
      -- Función para encontrar el símbolo actual basado en la posición del cursor
      local function find_current_symbols(symbols, line, col)
        local breadcrumbs = {}
        
        local function traverse(symbols_list, path)
          for _, symbol in ipairs(symbols_list) do
            local range = symbol.location and symbol.location.range or symbol.range
            if range then
              local start_line = range.start.line
              local end_line = range['end'].line
              local start_col = range.start.character
              local end_col = range['end'].character
              
              -- Verificar si el cursor está dentro del rango del símbolo
              if line >= start_line and line <= end_line then
                if line == start_line and col < start_col then
                  -- No está dentro de este símbolo
                elseif line == end_line and col > end_col then
                  -- No está dentro de este símbolo
                else
                  -- Está dentro del símbolo
                  local new_path = vim.tbl_extend('force', {}, path)
                  table.insert(new_path, {
                    name = symbol.name,
                    kind = symbol.kind,
                    icon = get_symbol_icon(symbol.kind)
                  })
                  
                  -- Si tiene hijos, buscar recursivamente
                  if symbol.children then
                    local child_result = traverse(symbol.children, new_path)
                    if #child_result > 0 then
                      return child_result
                    end
                  end
                  
                  breadcrumbs = new_path
                end
              end
            end
          end
          return breadcrumbs
        end
        
        return traverse(symbols, {})
      end
      
      -- Función para obtener íconos de símbolos
      function get_symbol_icon(kind)
        local icons = {
          [1] = "📁", -- File
          [2] = "📦", -- Module  
          [3] = "📂", -- Namespace
          [4] = "📦", -- Package
          [5] = "🏷️", -- Class
          [6] = "⚙️", -- Method
          [7] = "🔧", -- Property
          [8] = "🏷️", -- Field
          [9] = "👷", -- Constructor
          [10] = "📊", -- Enum
          [11] = "🔗", -- Interface
          [12] = "🔧", -- Function
          [13] = "📊", -- Variable
          [14] = "📊", -- Constant
          [15] = "📝", -- String
          [16] = "🔢", -- Number
          [17] = "✅", -- Boolean
          [18] = "📋", -- Array
          [19] = "🗝️", -- Object
          [20] = "🔑", -- Key
          [21] = "❓", -- Null
          [22] = "📐", -- EnumMember
          [23] = "📊", -- Struct
          [24] = "📅", -- Event
          [25] = "⚡", -- Operator
          [26] = "🔤" -- TypeParameter
        }
        return icons[kind] or "❓"
      end
      
      -- Función para actualizar el winbar
      function update_winbar()
        if vim.bo[event.buf].buftype ~= '' then
          return
        end
        
        local cursor = vim.api.nvim_win_get_cursor(0)
        local line = cursor[1] - 1  -- LSP usa 0-indexado
        local col = cursor[2]
        
        if #symbols_cache == 0 then
          vim.wo.winbar = ""
          return
        end
        
        local breadcrumbs = find_current_symbols(symbols_cache, line, col)
        
        if #breadcrumbs == 0 then
          vim.wo.winbar = ""
          return
        end
        
        -- Construir la cadena del winbar
        local parts = {}
        for i, crumb in ipairs(breadcrumbs) do
          local part = crumb.icon .. " " .. crumb.name
          if i < #breadcrumbs then
            part = part .. " › "
          end
          table.insert(parts, part)
        end
        
        -- Truncar si es muy largo
        local winbar_text = table.concat(parts, "")
        local max_width = vim.api.nvim_win_get_width(0) - 10
        if #winbar_text > max_width then
          winbar_text = "..." .. string.sub(winbar_text, -(max_width - 3))
        end
        
        vim.wo.winbar = winbar_text
      end
      
      -- Obtener símbolos inicialmente
      get_document_symbols()
      
      -- Autocomandos para actualizar breadcrumbs
      local breadcrumb_group = vim.api.nvim_create_augroup('lsp-breadcrumbs-' .. event.buf, { clear = true })
      
      -- Actualizar cuando el cursor se mueve
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = breadcrumb_group,
        callback = function()
          if #symbols_cache > 0 then
            update_winbar()
          end
        end,
      })
  
  -- Actualizar cuando el contenido cambia
  vim.api.nvim_create_autocmd({ 'TextChanged', 'TextChangedI' }, {
    buffer = event.buf,
    group = breadcrumb_group,
    callback = function()
      local current_tick = vim.api.nvim_buf_get_changedtick(event.buf)
      if current_tick ~= last_update_tick then
        -- Esperar un poco antes de actualizar para evitar spam
        vim.defer_fn(get_document_symbols, 500)
      end
    end,
  })
  
  -- Limpiar winbar cuando se salga del buffer
  vim.api.nvim_create_autocmd('BufLeave', {
    buffer = event.buf,
    group = breadcrumb_group,
    callback = function()
      vim.wo.winbar = ""
    end,
  })
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
          local info = vim.fn.complete_info({'selected'})
          
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
                local winData = vim.api.nvim__complete_set(info.selected, {info = doc_value})
                
                -- Configurar el popup window si es válido
                if winData and winData.winid and vim.api.nvim_win_is_valid(winData.winid) then
                  vim.api.nvim_win_set_config(winData.winid, {border = 'rounded'})
                  
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
    
    -- KEYMAPS AVANZADOS (requiere which-key plugin)
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
