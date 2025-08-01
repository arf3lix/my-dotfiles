-- Configuración para Pyright LSP en Neovim
-- Agregar esto a tu init.lua o init.vim

-- Configurar Pyright
return {
  -- Comando para iniciar el servidor
  cmd = { 'pyright-langserver', '--stdio' },

  -- Tipos de archivo que se adjuntarán automáticamente
  filetypes = { 'python' },

  -- Marcadores de directorio raíz para determinar el workspace
  -- Neovim buscará estos archivos/directorios hacia arriba para determinar
  -- la raíz del proyecto
  root_markers = {
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    'pyrightconfig.json',
    '.git'
  },

  -- Configuraciones específicas del servidor
  settings = {
    python = {
      analysis = {
        -- Configuración de análisis de código
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly", -- o "workspace"
        typeCheckingMode = "basic", -- "off", "basic", "strict"
      }
    }
  },

  -- Capacidades del cliente (opcional)
  capabilities = {
    textDocument = {
      publishDiagnostics = {
        relatedInformation = true,
        versionSupport = false,
        tagSupport = {
          valueSet = {
            1, -- Deprecated
            2, -- Unnecessary
          }
        }
      }
    }
  }
}
