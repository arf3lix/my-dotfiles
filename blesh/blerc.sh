color_bg="#000005"
color_fg="#D6DBE5"
color0="#000005"
color1="#323A49"
color2="#423E48"
color3="#5A5D6B"
color4="#566B8E"
color5="#768299"
color6="#8A98B4"
color7="#BCC3D1"
color8="#848992"





































# === CONFIGURACIÓN DE FACES DE BLESH ===

# Colores de edición y regiones
ble-face -s region "fg=${color7},bg=${color8}"
ble-face -s region_target "fg=${color_bg},bg=${color3}"
ble-face -s region_match "fg=${color7},bg=${color5}"
ble-face -s region_insert "fg=${color4},bg=${color_bg}"
ble-face -s disabled "fg=${color1}"
ble-face -s overwrite_mode "fg=${color_bg},bg=${color6}"
ble-face -s prompt_status_line "fg=${color7},bg=${color0}"

# Highlighting de sintaxis básica
ble-face -s syntax_default "none"
ble-face -s syntax_command "fg=${color3}"
ble-face -s syntax_quoted "fg=${color2}"
ble-face -s syntax_quotation "fg=${color2},bold"
ble-face -s syntax_escape "fg=${color5}"
ble-face -s syntax_expr "fg=${color4}"
ble-face -s syntax_error "fg=${color7},bg=${color1}"
ble-face -s syntax_varname "fg=${color6}"
ble-face -s syntax_delimiter "bold"
ble-face -s syntax_param_expansion "fg=${color5}"
ble-face -s syntax_history_expansion "fg=${color7},bg=${color3}"
ble-face -s syntax_function_name "fg=${color4},bold"
ble-face -s syntax_comment "fg=${color1}"
ble-face -s syntax_glob "fg=${color1},bold"
ble-face -s syntax_brace "fg=${color6},bold"
ble-face -s syntax_tilde "fg=${color5},bold"
ble-face -s syntax_document "fg=${color2}"
ble-face -s syntax_document_begin "fg=${color2},bold"

# Tipos de comandos
ble-face -s command_builtin_dot "fg=${color1},bold"
ble-face -s command_builtin "fg=${color1}"
ble-face -s command_alias "fg=${color6}"
ble-face -s command_function "fg=${color4}"
ble-face -s command_file "fg=${color2}"
ble-face -s command_keyword "fg=${color4}"
ble-face -s command_jobs "fg=${color1},bold"
ble-face -s command_directory "fg=${color4},underline"
ble-face -s command_suffix "fg=${color7},bg=${color2}"
ble-face -s command_suffix_new "fg=${color7},bg=${color1}"

# Información de comandos
ble-face -s cmdinfo_cd_cdpath "fg=${color4},bg=${color2}"

# Nombres de archivos
ble-face -s filename_directory "fg=${color4},underline"
ble-face -s filename_directory_sticky "fg=${color7},bg=${color4},underline"
ble-face -s filename_executable "fg=${color2},underline"
ble-face -s filename_link "fg=${color6},underline"
ble-face -s filename_orphan "fg=${color_bg},bg=${color3},underline"
ble-face -s filename_other "underline"
ble-face -s filename_socket "fg=${color6},bg=${color_bg},underline"
ble-face -s filename_pipe "fg=${color2},bg=${color_bg},underline"
ble-face -s filename_character "fg=${color7},bg=${color_bg},underline"
ble-face -s filename_block "fg=${color3},bg=${color_bg},underline"
ble-face -s filename_warning "fg=${color1},underline"
ble-face -s filename_url "fg=${color4},underline"
ble-face -s filename_ls_colors "underline"
ble-face -s filename_setuid "fg=${color_bg},bg=${color3},underline"
ble-face -s filename_setgid "fg=${color_bg},bg=${color3},underline"

# Variables
ble-face -s varname_array "fg=${color3},bold"
ble-face -s varname_empty "fg=${color4}"
ble-face -s varname_export "fg=${color1},bold"
ble-face -s varname_expr "fg=${color4},bold"
ble-face -s varname_hash "fg=${color2},bold"
ble-face -s varname_new "fg=${color4}"
ble-face -s varname_number "fg=${color6}"
ble-face -s varname_readonly "fg=${color1}"
ble-face -s varname_transform "fg=${color2},bold"
ble-face -s varname_unset "fg=${color1}"

# Autocompletado y menús
ble-face -s auto_complete "fg=${color4},bg=${color_bg}"
ble-face -s menu_complete_match "bold"
ble-face -s menu_complete_selected "reverse"
ble-face -s menu_desc_default "none"
ble-face -s menu_desc_quote "ref:syntax_quoted"
ble-face -s menu_desc_type "ref:syntax_delimiter"
ble-face -s menu_filter_fixed "bold"
ble-face -s menu_filter_input "fg=${color_bg},bg=${color3}"

# Argumentos
ble-face -s argument_option "fg=${color6}"
ble-face -s argument_error "fg=${color_bg},bg=${color1}"

# Campana visual (vbell)
ble-face -s vbell "reverse"
ble-face -s vbell_erase "bg=${color0}"
ble-face -s vbell_flash "fg=${color2},reverse"


bleopt prompt_ps1_transient='always:trim'

bleopt prompt_ps1_final='$(starship module custom.character)'


