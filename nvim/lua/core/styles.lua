-- Primero configuramos los highlight groups para floating windows
local function setup_lsp_highlights()
  -- Configurar colores para floating windows
  vim.api.nvim_set_hl(0, 'NormalFloat', {
    bg = '#1e1e1e',  -- Fondo negro/gris oscuro para todo el popup
    fg = '#ffffff'   -- Texto blanco
  })

  vim.api.nvim_set_hl(0, 'FloatBorder', {
    bg = '#1e1e1e',  -- Mismo fondo que NormalFloat
    fg = '#6080ff'   -- Borde azul para contraste
  })

  -- Mejorar el contraste de docstrings en markdown dentro de popups
  vim.api.nvim_set_hl(0, 'markdownCode', {
    bg = '#2d2d2d',
    fg = '#98c379'
  })

  vim.api.nvim_set_hl(0, 'markdownCodeBlock', {
    bg = '#2d2d2d',
    fg = '#98c379'
  })

  -- Resaltar mejor los comentarios/docstrings
  vim.api.nvim_set_hl(0, '@comment', {
    fg = '#7c7c7c',
    italic = true
  })

  -- Nuevo en 0.11: grupo para resaltar referencias
  vim.api.nvim_set_hl(0, 'LspReferenceTarget', {
    bg = '#404040',
    underline = true
  })
end

-- Configurar handlers personalizados para hover y signature help
local function setup_lsp_handlers()
  -- Handler personalizado para hover con borde y mejor styling
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",  -- Opciones: "none", "single", "double", "rounded", "solid", "shadow"
    max_width = 80,
    max_height = 30,
    -- Configuración adicional del popup
    focusable = true,    -- Permite navegar dentro del popup
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
    -- Estilo personalizado
    style = "minimal",
    wrap = true,
  })

  -- Handler personalizado para signature help
  vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
    max_width = 80,
    max_height = 15,
    focusable = false,   -- No queremos focus en signature help normalmente
    close_events = { "CursorMoved", "BufHidden", "InsertLeave" },
    style = "minimal",
    wrap = true,
  })
end

-- Función para aplicar highlights después de cambios de colorscheme
local function setup_colorscheme_autocmd()
  vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup('lsp-highlights', { clear = true }),
    callback = function()
      setup_lsp_highlights()
    end,
  })
end

-- Aplicar configuración inicial
setup_lsp_highlights()
setup_lsp_handlers()
setup_colorscheme_autocmd()
