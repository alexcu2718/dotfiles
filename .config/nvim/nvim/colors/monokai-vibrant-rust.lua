-- ===============================================================
-- monokai-vibrant-rust.lua
--
-- URL: https://github.com/DioxusLabs/monokai-vibrant-rust
-- Author: DioxusLabs
-- License: MIT
-- Last Change: 2024
-- ===============================================================

local M = {}

-- Color Palette
local colors = {
  bg0        = '#16171D',
  bg1        = '#1F2328',
  bg2        = '#21252B',
  bg3        = '#282c34',
  bg4        = '#3B3C40',

  fg0        = '#f8f8f0',
  fg1        = '#F6F6F6',
  fg2        = '#D7DAE0',
  fg3        = '#bdbdbd',
  fg4        = '#9da5b4',

  red        = '#FF3F4F',
  green      = '#81F900',
  yellow     = '#FFD945',
  orange     = '#FF9700',
  blue       = '#00a0e4',
  cyan       = '#19D1E5',
  purple     = '#E373CE',
  pink       = '#E542FF',

  comment    = '#5c6370',
  selection  = '#3E4451',
  error      = '#c24038',
}

-- Helper function to set highlights
local function hl(group, opts)
  opts = opts or {}
  vim.api.nvim_set_hl(0, group, opts)
end

-- Setup function
function M.setup()
  vim.cmd('hi clear')
  if vim.fn.exists('syntax_on') then
    vim.cmd('syntax reset')
  end

  vim.o.background = 'dark'
  vim.g.colors_name = 'monokai-vibrant-rust'

  -- Editor Colors
  hl('Normal', { fg = colors.fg0, bg = colors.bg0 })
  hl('Bold', { bold = true })
  hl('Debug', { fg = colors.red })
  hl('Directory', { fg = colors.blue })
  hl('Error', { fg = colors.error, bg = colors.bg0 })
  hl('ErrorMsg', { fg = colors.error, bg = colors.bg0 })
  hl('Exception', { fg = colors.red })
  hl('FoldColumn', { fg = colors.cyan, bg = colors.bg1 })
  hl('Folded', { fg = colors.comment, bg = colors.bg1 })
  hl('IncSearch', { fg = colors.bg0, bg = colors.orange })
  hl('Italic', { italic = true })
  hl('Macro', { fg = colors.red })
  hl('MatchParen', { bg = colors.bg3 })
  hl('ModeMsg', { fg = colors.green })
  hl('MoreMsg', { fg = colors.green })
  hl('Question', { fg = colors.blue })
  hl('Search', { fg = colors.bg0, bg = colors.yellow })
  hl('Substitute', { fg = colors.bg0, bg = colors.yellow })
  hl('SpecialKey', { fg = colors.comment })
  hl('TooLong', { fg = colors.red })
  hl('Underlined', { fg = colors.red, underline = true })
  hl('Visual', { bg = colors.selection })
  hl('VisualNOS', { fg = colors.red })
  hl('WarningMsg', { fg = colors.red })
  hl('WildMenu', { fg = colors.red, bg = colors.yellow })
  hl('Title', { fg = colors.blue })
  hl('Conceal', { fg = colors.blue, bg = colors.bg0 })
  hl('Cursor', { fg = colors.bg0, bg = colors.fg0 })
  hl('NonText', { fg = colors.comment })
  hl('LineNr', { fg = colors.comment, bg = colors.bg0 })
  hl('SignColumn', { fg = colors.comment, bg = colors.bg0 })
  hl('StatusLine', { fg = colors.fg4, bg = colors.bg2 })
  hl('StatusLineNC', { fg = colors.comment, bg = colors.bg1 })
  hl('Tabline', { fg = colors.comment, bg = colors.bg1 })
  hl('TabLineFill', { fg = colors.comment, bg = colors.bg1 })
  hl('TabLineSel', { fg = colors.green, bg = colors.bg1 })
  hl('VertSplit', { fg = colors.bg2, bg = colors.bg0 })
  hl('ColorColumn', { bg = colors.bg1 })
  hl('CursorColumn', { bg = colors.bg1 })
  hl('CursorLine', { bg = colors.bg1 })
  hl('CursorLineNr', { fg = colors.yellow, bg = colors.bg1 })
  hl('QuickFixLine', { bg = colors.bg1 })
  hl('PMenu', { fg = colors.fg0, bg = colors.bg2 })
  hl('PMenuSel', { fg = colors.fg0, bg = colors.bg3 })
  hl('PMenuSbar', { bg = colors.bg2 })
  hl('PMenuThumb', { bg = colors.bg4 })

  -- Standard Syntax Highlighting
  hl('Boolean', { fg = colors.purple })
  hl('Character', { fg = colors.red })
  hl('Comment', { fg = colors.comment, italic = true })
  hl('Conditional', { fg = colors.red, italic = true })
  hl('Constant', { fg = colors.purple })
  hl('Define', { fg = colors.red, italic = true })
  hl('Delimiter', { fg = colors.fg4 })
  hl('Float', { fg = colors.purple })
  hl('Function', { fg = colors.green })
  hl('Identifier', { fg = colors.red, italic = true })
  hl('Include', { fg = colors.blue })
  hl('Keyword', { fg = colors.red, italic = true })
  hl('Label', { fg = colors.yellow })
  hl('Number', { fg = colors.purple })
  hl('Operator', { fg = colors.red })
  hl('PreProc', { fg = colors.yellow })
  hl('Repeat', { fg = colors.red, italic = true })
  hl('Special', { fg = colors.cyan })
  hl('SpecialChar', { fg = colors.fg4 })
  hl('Statement', { fg = colors.red, italic = true })
  hl('StorageClass', { fg = colors.cyan, italic = true })
  hl('String', { fg = colors.yellow })
  hl('Structure', { fg = colors.red, italic = true })
  hl('Tag', { fg = colors.yellow })
  hl('Todo', { fg = colors.yellow, bg = colors.bg1 })
  hl('Type', { fg = colors.cyan })
  hl('Typedef', { fg = colors.yellow })

  -- Language-specific Highlighting

  -- Rust
  hl('rustSelf', { fg = colors.red, italic = true })
  hl('rustKeyword', { fg = colors.red, italic = true })
  hl('rustStorage', { fg = colors.red, italic = true })
  hl('rustModPath', { fg = colors.blue })
  hl('rustLifetime', { fg = colors.orange, italic = true })
  hl('rustType', { fg = colors.cyan })
  hl('rustTrait', { fg = colors.cyan })
  hl('rustMacro', { fg = colors.green })
  hl('rustFunction', { fg = colors.green })
  hl('rustFuncCall', { fg = colors.green })
  hl('rustString', { fg = colors.yellow })
  hl('rustNumber', { fg = colors.purple })
  hl('rustBoolean', { fg = colors.purple })
  hl('rustConstant', { fg = colors.purple })
  hl('rustAttribute', { fg = colors.comment, italic = true })

  -- JavaScript/TypeScript
  hl('jsFunction', { fg = colors.red, italic = true })
  hl('jsReturn', { fg = colors.red, italic = true })
  hl('jsThis', { fg = colors.red, italic = true })
  hl('jsClassKeyword', { fg = colors.red, italic = true })
  hl('jsExtendsKeyword', { fg = colors.red, italic = true })
  hl('jsExportDefault', { fg = colors.red, italic = true })
  hl('jsTemplateBraces', { fg = colors.red })
  hl('jsGlobalNodeObjects', { fg = colors.cyan })
  hl('jsGlobalObjects', { fg = colors.cyan })

  -- Python
  hl('pythonBuiltin', { fg = colors.cyan })
  hl('pythonFunction', { fg = colors.green })
  hl('pythonDecorator', { fg = colors.orange })
  hl('pythonDecoratorName', { fg = colors.blue })

  -- HTML
  hl('htmlTag', { fg = colors.red })
  hl('htmlEndTag', { fg = colors.red })
  hl('htmlTagName', { fg = colors.red })
  hl('htmlArg', { fg = colors.green })
  hl('htmlScriptTag', { fg = colors.red })

  -- CSS
  hl('cssProp', { fg = colors.cyan })
  hl('cssUIAttr', { fg = colors.yellow })
  hl('cssAuralAttr', { fg = colors.yellow })
  hl('cssColor', { fg = colors.yellow })
  hl('cssAuralProp', { fg = colors.cyan })
  hl('cssBoxProp', { fg = colors.cyan })
  hl('cssTextProp', { fg = colors.cyan })
  hl('cssRenderProp', { fg = colors.cyan })
  hl('cssGeneratedContentProp', { fg = colors.cyan })

  -- JSON
  hl('jsonKeyword', { fg = colors.blue })
  hl('jsonQuote', { fg = colors.comment })
  hl('jsonBraces', { fg = colors.fg0 })
  hl('jsonString', { fg = colors.green })

  -- Markdown
  hl('markdownCode', { fg = colors.green })
  hl('markdownError', { fg = colors.fg0, bg = colors.bg0 })
  hl('markdownCodeBlock', { fg = colors.green })
  hl('markdownHeadingDelimiter', { fg = colors.blue })
  hl('markdownRule', { fg = colors.comment })
  hl('markdownHeadingRule', { fg = colors.comment })
  hl('markdownH1', { fg = colors.blue, bold = true })
  hl('markdownH2', { fg = colors.blue, bold = true })
  hl('markdownH3', { fg = colors.blue, bold = true })
  hl('markdownH4', { fg = colors.blue, bold = true })
  hl('markdownH5', { fg = colors.blue, bold = true })
  hl('markdownH6', { fg = colors.blue, bold = true })
  hl('markdownIdDelimiter', { fg = colors.red })
  hl('markdownId', { fg = colors.red })
  hl('markdownBlockquote', { fg = colors.comment })
  hl('markdownItalic', { fg = colors.red, italic = true })
  hl('markdownBold', { fg = colors.red, bold = true })
  hl('markdownListMarker', { fg = colors.red })
  hl('markdownOrderedListMarker', { fg = colors.red })
  hl('markdownIdDeclaration', { fg = colors.blue })
  hl('markdownLinkText', { fg = colors.blue })
  hl('markdownLinkDelimiter', { fg = colors.fg4 })
  hl('markdownUrl', { fg = colors.red })

  -- Git Highlighting
  hl('gitcommitComment', { fg = colors.comment })
  hl('gitcommitUnmerged', { fg = colors.green })
  hl('gitcommitOnBranch', { fg = colors.comment })
  hl('gitcommitBranch', { fg = colors.red })
  hl('gitcommitDiscardedType', { fg = colors.red })
  hl('gitcommitSelectedType', { fg = colors.green })
  hl('gitcommitHeader', { fg = colors.comment })
  hl('gitcommitUntrackedFile', { fg = colors.cyan })
  hl('gitcommitDiscardedFile', { fg = colors.red })
  hl('gitcommitSelectedFile', { fg = colors.green })
  hl('gitcommitUnmergedFile', { fg = colors.yellow })
  hl('gitcommitFile', { fg = colors.fg0 })

  -- Plugin Support

  -- GitGutter
  hl('GitGutterAdd', { fg = colors.green })
  hl('GitGutterChange', { fg = colors.yellow })
  hl('GitGutterDelete', { fg = colors.red })
  hl('GitGutterChangeDelete', { fg = colors.red })

  -- vim-signify
  hl('SignifySignAdd', { fg = colors.green })
  hl('SignifySignChange', { fg = colors.yellow })
  hl('SignifySignDelete', { fg = colors.red })

  -- ALE
  hl('ALEError', { fg = colors.error })
  hl('ALEWarning', { fg = colors.yellow })
  hl('ALEInfo', { fg = colors.blue })
  hl('ALEErrorSign', { fg = colors.error })
  hl('ALEWarningSign', { fg = colors.yellow })
  hl('ALEInfoSign', { fg = colors.blue })

  -- LSP (legacy)
  hl('LspDiagnosticsDefaultError', { fg = colors.error })
  hl('LspDiagnosticsDefaultWarning', { fg = colors.yellow })
  hl('LspDiagnosticsDefaultInformation', { fg = colors.blue })
  hl('LspDiagnosticsDefaultHint', { fg = colors.cyan })
  hl('LspDiagnosticsVirtualTextError', { fg = colors.error })
  hl('LspDiagnosticsVirtualTextWarning', { fg = colors.yellow })
  hl('LspDiagnosticsVirtualTextInformation', { fg = colors.blue })
  hl('LspDiagnosticsVirtualTextHint', { fg = colors.cyan })
  hl('LspDiagnosticsUnderlineError', { fg = colors.error })
  hl('LspDiagnosticsUnderlineWarning', { fg = colors.yellow })
  hl('LspDiagnosticsUnderlineInformation', { fg = colors.blue })
  hl('LspDiagnosticsUnderlineHint', { fg = colors.cyan })

  -- Neovim built-in LSP
  hl('DiagnosticError', { fg = colors.error })
  hl('DiagnosticWarn', { fg = colors.yellow })
  hl('DiagnosticInfo', { fg = colors.blue })
  hl('DiagnosticHint', { fg = colors.cyan })
  hl('DiagnosticVirtualTextError', { fg = colors.error })
  hl('DiagnosticVirtualTextWarn', { fg = colors.yellow })
  hl('DiagnosticVirtualTextInfo', { fg = colors.blue })
  hl('DiagnosticVirtualTextHint', { fg = colors.cyan })
  hl('DiagnosticUnderlineError', { fg = colors.error, underline = true })
  hl('DiagnosticUnderlineWarn', { fg = colors.yellow, underline = true })
  hl('DiagnosticUnderlineInfo', { fg = colors.blue, underline = true })
  hl('DiagnosticUnderlineHint', { fg = colors.cyan, underline = true })

  -- Treesitter
  hl('@annotation', { fg = colors.orange })
  hl('@attribute', { fg = colors.orange })
  hl('@boolean', { fg = colors.purple })
  hl('@character', { fg = colors.yellow })
  hl('@comment', { fg = colors.comment, italic = true })
  hl('@constructor', { fg = colors.cyan })
  hl('@conditional', { fg = colors.red, italic = true })
  hl('@constant', { fg = colors.purple })
  hl('@constant.builtin', { fg = colors.purple })
  hl('@constant.macro', { fg = colors.purple })
  hl('@error', { fg = colors.error })
  hl('@exception', { fg = colors.red })
  hl('@field', { fg = colors.blue })
  hl('@float', { fg = colors.purple })
  hl('@function', { fg = colors.green })
  hl('@function.builtin', { fg = colors.cyan })
  hl('@function.macro', { fg = colors.green })
  hl('@include', { fg = colors.red, italic = true })
  hl('@keyword', { fg = colors.red, italic = true })
  hl('@keyword.function', { fg = colors.red, italic = true })
  hl('@keyword.operator', { fg = colors.red, italic = true })
  hl('@label', { fg = colors.orange })
  hl('@method', { fg = colors.green })
  hl('@namespace', { fg = colors.cyan })
  hl('@none', { fg = colors.fg0 })
  hl('@number', { fg = colors.purple })
  hl('@operator', { fg = colors.red })
  hl('@parameter', { fg = colors.orange, italic = true })
  hl('@parameter.reference', { fg = colors.orange })
  hl('@property', { fg = colors.blue })
  hl('@punctuation.delimiter', { fg = colors.fg4 })
  hl('@punctuation.bracket', { fg = colors.fg4 })
  hl('@punctuation.special', { fg = colors.fg4 })
  hl('@repeat', { fg = colors.red, italic = true })
  hl('@string', { fg = colors.yellow })
  hl('@string.regex', { fg = colors.yellow })
  hl('@string.escape', { fg = colors.cyan })
  hl('@symbol', { fg = colors.purple })
  hl('@tag', { fg = colors.red })
  hl('@tag.delimiter', { fg = colors.fg4 })
  hl('@text', { fg = colors.fg0 })
  hl('@text.strong', { fg = colors.fg0, bold = true })
  hl('@text.emphasis', { fg = colors.fg0, italic = true })
  hl('@text.underline', { fg = colors.fg0, underline = true })
  hl('@text.strike', { fg = colors.fg0, strikethrough = true })
  hl('@text.title', { fg = colors.blue, bold = true })
  hl('@text.literal', { fg = colors.green })
  hl('@text.uri', { fg = colors.blue, underline = true })
  hl('@type', { fg = colors.cyan })
  hl('@type.builtin', { fg = colors.cyan, italic = true })
  hl('@variable', { fg = colors.fg0 })
  hl('@variable.builtin', { fg = colors.red, italic = true })

  -- Terminal Colors
  vim.g.terminal_color_0 = colors.bg0
  vim.g.terminal_color_1 = colors.red
  vim.g.terminal_color_2 = colors.green
  vim.g.terminal_color_3 = colors.yellow
  vim.g.terminal_color_4 = colors.blue
  vim.g.terminal_color_5 = colors.purple
  vim.g.terminal_color_6 = colors.cyan
  vim.g.terminal_color_7 = colors.fg0
  vim.g.terminal_color_8 = colors.bg4
  vim.g.terminal_color_9 = colors.red
  vim.g.terminal_color_10 = colors.green
  vim.g.terminal_color_11 = colors.yellow
  vim.g.terminal_color_12 = colors.blue
  vim.g.terminal_color_13 = colors.purple
  vim.g.terminal_color_14 = colors.cyan
  vim.g.terminal_color_15 = colors.fg1
end

-- Call setup function
M.setup()

return M
