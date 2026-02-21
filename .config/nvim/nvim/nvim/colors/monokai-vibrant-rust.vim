" ===============================================================
" monokai-vibrant-rust
"
" URL: https://github.com/DioxusLabs/monokai-vibrant-rust
" Author: DioxusLabs
" License: MIT
" Last Change: 2025
" ===============================================================

set background=dark
hi clear
if exists("syntax_on")
  syntax reset
endif
let g:colors_name="monokai-vibrant-rust"

" ===============================================================
" Color Palette
" ===============================================================
let s:bg0        = '#16171D'
let s:bg1        = '#1F2328'
let s:bg2        = '#21252B'
let s:bg3        = '#282c34'
let s:bg4        = '#3B3C40'

let s:fg0        = '#f8f8f0'
let s:fg1        = '#F6F6F6'
let s:fg2        = '#D7DAE0'
let s:fg3        = '#bdbdbd'
let s:fg4        = '#9da5b4'

let s:red        = '#FF3F4F'
let s:green      = '#81F900'
let s:yellow     = '#FFD945'
let s:orange     = '#FF9700'
let s:blue       = '#00a0e4'
let s:cyan       = '#19D1E5'
let s:purple     = '#E373CE'
let s:pink       = '#E542FF'

let s:comment    = '#5c6370'
let s:selection  = '#3E4451'
let s:error      = '#c24038'

" ===============================================================
" Helper Functions
" ===============================================================
function! s:HL(group, fg, ...)
  " Arguments: group, guifg, guibg, gui, guisp
  let fg = a:fg

  if a:0 >= 1
    let bg = a:1
  else
    let bg = ""
  endif

  if a:0 >= 2 && strlen(a:2)
    let attr = a:2
  else
    let attr = ""
  endif

  let cmd = "hi " . a:group
  if strlen(fg)
    let cmd .= " guifg=" . fg
  endif
  if strlen(bg)
    let cmd .= " guibg=" . bg
  endif
  if strlen(attr)
    let cmd .= " gui=" . attr . " cterm=" . attr
  endif
  exec cmd
endfunction

" ===============================================================
" Vim Editor Colors
" ===============================================================
call s:HL("Normal",       s:fg0,      s:bg0)
call s:HL("Bold",         "",         "",         "bold")
call s:HL("Debug",        s:red,      "")
call s:HL("Directory",    s:blue,     "")
call s:HL("Error",        s:error,    s:bg0)
call s:HL("ErrorMsg",     s:error,    s:bg0)
call s:HL("Exception",    s:red,      "")
call s:HL("FoldColumn",   s:cyan,     s:bg1)
call s:HL("Folded",       s:comment,  s:bg1)
call s:HL("IncSearch",    s:bg0,      s:orange)
call s:HL("Italic",       "",         "",         "italic")
call s:HL("Macro",        s:red,      "")
call s:HL("MatchParen",   "",         s:bg3)
call s:HL("ModeMsg",      s:green,    "")
call s:HL("MoreMsg",      s:green,    "")
call s:HL("Question",     s:blue,     "")
call s:HL("Search",       s:bg0,      s:yellow)
call s:HL("Substitute",   s:bg0,      s:yellow)
call s:HL("SpecialKey",   s:comment,  "")
call s:HL("TooLong",      s:red,      "")
call s:HL("Underlined",   s:red,      "")
call s:HL("Visual",       "",         s:selection)
call s:HL("VisualNOS",    s:red,      "")
call s:HL("WarningMsg",   s:red,      "")
call s:HL("WildMenu",     s:red,      s:yellow)
call s:HL("Title",        s:blue,     "")
call s:HL("Conceal",      s:blue,     s:bg0)
call s:HL("Cursor",       s:bg0,      s:fg0)
call s:HL("NonText",      s:comment,  "")
call s:HL("LineNr",       s:comment,  s:bg0)
call s:HL("SignColumn",   s:comment,  s:bg0)
call s:HL("StatusLine",   s:fg4,      s:bg2)
call s:HL("StatusLineNC", s:comment,  s:bg1)
call s:HL("Tabline",      s:comment,  s:bg1)
call s:HL("TabLineFill",  s:comment,  s:bg1)
call s:HL("TabLineSel",   s:green,    s:bg1)
call s:HL("VertSplit",    s:bg2,      s:bg0)
call s:HL("ColorColumn", "",          s:bg1)
call s:HL("CursorColumn", "",         s:bg1)
call s:HL("CursorLine",   "",         s:bg1)
call s:HL("CursorLineNr", s:yellow,   s:bg1)
call s:HL("QuickFixLine", "",         s:bg1)
call s:HL("PMenu",        s:fg0,      s:bg2)
call s:HL("PMenuSel",     s:fg0,      s:bg3)
call s:HL("PMenuSbar",    "",         s:bg2)
call s:HL("PMenuThumb",   "",         s:bg4)

" ===============================================================
" Standard Syntax Highlighting
" ===============================================================
call s:HL("Boolean",      s:purple,   "")
call s:HL("Character",    s:red,      "")
call s:HL("Comment",      s:comment,  "",         "italic")
call s:HL("Conditional",  s:red,      "",         "italic")
call s:HL("Constant",     s:purple,   "")
call s:HL("Define",       s:red,      "",         "italic")
call s:HL("Delimiter",    s:fg4,      "")
call s:HL("Float",        s:purple,   "")
call s:HL("Function",     s:green,    "")
call s:HL("Identifier",   s:red,      "",         "italic")
call s:HL("Include",      s:blue,     "")
call s:HL("Keyword",      s:red,      "",         "italic")
call s:HL("Label",        s:yellow,   "")
call s:HL("Number",       s:purple,   "")
call s:HL("Operator",     s:red,      "")
call s:HL("PreProc",      s:yellow,   "")
call s:HL("Repeat",       s:red,      "",         "italic")
call s:HL("Special",      s:cyan,     "")
call s:HL("SpecialChar",  s:fg4,      "")
call s:HL("Statement",    s:red,      "",         "italic")
call s:HL("StorageClass", s:cyan,     "",         "italic")
call s:HL("String",       s:yellow,   "")
call s:HL("Structure",    s:red,      "",         "italic")
call s:HL("Tag",          s:yellow,   "")
call s:HL("Todo",         s:yellow,   s:bg1)
call s:HL("Type",         s:cyan,     "")
call s:HL("Typedef",      s:yellow,   "")

" ===============================================================
" Language-specific Highlighting
" ===============================================================

" Rust
call s:HL("rustSelf",           s:red,      "",     "italic")
call s:HL("rustKeyword",        s:red,      "",     "italic")
call s:HL("rustStorage",        s:red,      "",     "italic")
call s:HL("rustModPath",        s:blue,     "")
call s:HL("rustLifetime",       s:orange,   "",     "italic")
call s:HL("rustType",           s:cyan,     "")
call s:HL("rustTrait",          s:cyan,     "")
call s:HL("rustMacro",          s:green,    "")
call s:HL("rustFunction",       s:green,    "")
call s:HL("rustFuncCall",       s:green,    "")
call s:HL("rustString",         s:yellow,   "")
call s:HL("rustNumber",         s:purple,   "")
call s:HL("rustBoolean",        s:purple,   "")
call s:HL("rustConstant",       s:purple,   "")
call s:HL("rustAttribute",      s:comment,  "",     "italic")

" JavaScript/TypeScript
call s:HL("jsFunction",         s:red,      "",     "italic")
call s:HL("jsReturn",           s:red,      "",     "italic")
call s:HL("jsThis",             s:red,      "",     "italic")
call s:HL("jsClassKeyword",     s:red,      "",     "italic")
call s:HL("jsExtendsKeyword",   s:red,      "",     "italic")
call s:HL("jsExportDefault",    s:red,      "",     "italic")
call s:HL("jsTemplateBraces",   s:red,      "")
call s:HL("jsGlobalNodeObjects", s:cyan,    "")
call s:HL("jsGlobalObjects",    s:cyan,     "")

" Python
call s:HL("pythonBuiltin",      s:cyan,     "")
call s:HL("pythonFunction",     s:green,    "")
call s:HL("pythonDecorator",    s:orange,   "")
call s:HL("pythonDecoratorName", s:blue,    "")

" HTML
call s:HL("htmlTag",            s:red,      "")
call s:HL("htmlEndTag",         s:red,      "")
call s:HL("htmlTagName",        s:red,      "")
call s:HL("htmlArg",            s:green,    "")
call s:HL("htmlScriptTag",      s:red,      "")

" CSS
call s:HL("cssProp",            s:cyan,     "")
call s:HL("cssUIAttr",          s:yellow,   "")
call s:HL("cssAuralAttr",       s:yellow,   "")
call s:HL("cssColor",           s:yellow,   "")
call s:HL("cssAuralProp",       s:cyan,     "")
call s:HL("cssBoxProp",         s:cyan,     "")
call s:HL("cssTextProp",        s:cyan,     "")
call s:HL("cssRenderProp",      s:cyan,     "")
call s:HL("cssGeneratedContentProp", s:cyan, "")

" JSON
call s:HL("jsonKeyword",        s:blue,     "")
call s:HL("jsonQuote",          s:comment,  "")
call s:HL("jsonBraces",         s:fg0,      "")
call s:HL("jsonString",         s:green,    "")

" Markdown
call s:HL("markdownCode",           s:green,    "")
call s:HL("markdownError",          s:fg0,      s:bg0)
call s:HL("markdownCodeBlock",      s:green,    "")
call s:HL("markdownHeadingDelimiter", s:blue,   "")
call s:HL("markdownRule",           s:comment,  "")
call s:HL("markdownHeadingRule",    s:comment,  "")
call s:HL("markdownH1",             s:blue,     "",         "bold")
call s:HL("markdownH2",             s:blue,     "",         "bold")
call s:HL("markdownH3",             s:blue,     "",         "bold")
call s:HL("markdownH4",             s:blue,     "",         "bold")
call s:HL("markdownH5",             s:blue,     "",         "bold")
call s:HL("markdownH6",             s:blue,     "",         "bold")
call s:HL("markdownIdDelimiter",    s:red,      "")
call s:HL("markdownId",             s:red,      "")
call s:HL("markdownBlockquote",     s:comment,  "")
call s:HL("markdownItalic",         s:red,      "",         "italic")
call s:HL("markdownBold",           s:red,      "",         "bold")
call s:HL("markdownListMarker",     s:red,      "")
call s:HL("markdownOrderedListMarker", s:red,   "")
call s:HL("markdownIdDeclaration",  s:blue,     "")
call s:HL("markdownLinkText",       s:blue,     "")
call s:HL("markdownLinkDelimiter",  s:fg4,      "")
call s:HL("markdownUrl",            s:red,      "")

" ===============================================================
" Git Highlighting
" ===============================================================
call s:HL("gitcommitComment",       s:comment,  "")
call s:HL("gitcommitUnmerged",      s:green,    "")
call s:HL("gitcommitOnBranch",      s:comment,  "")
call s:HL("gitcommitBranch",        s:red,      "")
call s:HL("gitcommitDiscardedType", s:red,      "")
call s:HL("gitcommitSelectedType",  s:green,    "")
call s:HL("gitcommitHeader",        s:comment,  "")
call s:HL("gitcommitUntrackedFile", s:cyan,     "")
call s:HL("gitcommitDiscardedFile", s:red,      "")
call s:HL("gitcommitSelectedFile",  s:green,    "")
call s:HL("gitcommitUnmergedFile",  s:yellow,   "")
call s:HL("gitcommitFile",          s:fg0,      "")

" ===============================================================
" Plugin Support
" ===============================================================

" GitGutter
call s:HL("GitGutterAdd",          s:green,    "")
call s:HL("GitGutterChange",       s:yellow,   "")
call s:HL("GitGutterDelete",       s:red,      "")
call s:HL("GitGutterChangeDelete", s:red,      "")

" vim-signify
call s:HL("SignifySignAdd",        s:green,    "")
call s:HL("SignifySignChange",     s:yellow,   "")
call s:HL("SignifySignDelete",     s:red,      "")

" ALE
call s:HL("ALEError",              s:error,    "")
call s:HL("ALEWarning",            s:yellow,   "")
call s:HL("ALEInfo",               s:blue,     "")
call s:HL("ALEErrorSign",          s:error,    "")
call s:HL("ALEWarningSign",        s:yellow,   "")
call s:HL("ALEInfoSign",           s:blue,     "")

" LSP
call s:HL("LspDiagnosticsDefaultError",       s:error,    "")
call s:HL("LspDiagnosticsDefaultWarning",     s:yellow,   "")
call s:HL("LspDiagnosticsDefaultInformation", s:blue,     "")
call s:HL("LspDiagnosticsDefaultHint",        s:cyan,     "")
call s:HL("LspDiagnosticsVirtualTextError",   s:error,    "")
call s:HL("LspDiagnosticsVirtualTextWarning", s:yellow,   "")
call s:HL("LspDiagnosticsVirtualTextInformation", s:blue, "")
call s:HL("LspDiagnosticsVirtualTextHint",    s:cyan,     "")
call s:HL("LspDiagnosticsUnderlineError",     s:error,    "")
call s:HL("LspDiagnosticsUnderlineWarning",   s:yellow,   "")
call s:HL("LspDiagnosticsUnderlineInformation", s:blue,   "")
call s:HL("LspDiagnosticsUnderlineHint",      s:cyan,     "")

" Neovim built-in LSP
call s:HL("DiagnosticError",                  s:error,    "")
call s:HL("DiagnosticWarn",                   s:yellow,   "")
call s:HL("DiagnosticInfo",                   s:blue,     "")
call s:HL("DiagnosticHint",                   s:cyan,     "")
call s:HL("DiagnosticVirtualTextError",       s:error,    "")
call s:HL("DiagnosticVirtualTextWarn",        s:yellow,   "")
call s:HL("DiagnosticVirtualTextInfo",        s:blue,     "")
call s:HL("DiagnosticVirtualTextHint",        s:cyan,     "")
call s:HL("DiagnosticUnderlineError",         s:error,    "",         "underline")
call s:HL("DiagnosticUnderlineWarn",          s:yellow,   "",         "underline")
call s:HL("DiagnosticUnderlineInfo",          s:blue,     "",         "underline")
call s:HL("DiagnosticUnderlineHint",          s:cyan,     "",         "underline")

" Treesitter
call s:HL("TSAnnotation",         s:orange,   "")
call s:HL("TSAttribute",          s:orange,   "")
call s:HL("TSBoolean",            s:purple,   "")
call s:HL("TSCharacter",          s:yellow,   "")
call s:HL("TSComment",            s:comment,  "",         "italic")
call s:HL("TSConstructor",        s:cyan,     "")
call s:HL("TSConditional",        s:red,      "",         "italic")
call s:HL("TSConstant",           s:purple,   "")
call s:HL("TSConstBuiltin",       s:purple,   "")
call s:HL("TSConstMacro",         s:purple,   "")
call s:HL("TSError",              s:error,    "")
call s:HL("TSException",          s:red,      "")
call s:HL("TSField",              s:blue,     "")
call s:HL("TSFloat",              s:purple,   "")
call s:HL("TSFunction",           s:green,    "")
call s:HL("TSFuncBuiltin",        s:cyan,     "")
call s:HL("TSFuncMacro",          s:green,    "")
call s:HL("TSInclude",            s:red,      "",         "italic")
call s:HL("TSKeyword",            s:red,      "",         "italic")
call s:HL("TSKeywordFunction",    s:red,      "",         "italic")
call s:HL("TSKeywordOperator",    s:red,      "",         "italic")
call s:HL("TSLabel",              s:orange,   "")
call s:HL("TSMethod",             s:green,    "")
call s:HL("TSNamespace",          s:cyan,     "")
call s:HL("TSNone",               s:fg0,      "")
call s:HL("TSNumber",             s:purple,   "")
call s:HL("TSOperator",           s:red,      "")
call s:HL("TSParameter",          s:orange,   "",         "italic")
call s:HL("TSParameterReference", s:orange,   "")
call s:HL("TSProperty",           s:blue,     "")
call s:HL("TSPunctDelimiter",     s:fg4,      "")
call s:HL("TSPunctBracket",       s:fg4,      "")
call s:HL("TSPunctSpecial",       s:fg4,      "")
call s:HL("TSRepeat",             s:red,      "",         "italic")
call s:HL("TSString",             s:yellow,   "")
call s:HL("TSStringRegex",        s:yellow,   "")
call s:HL("TSStringEscape",       s:cyan,     "")
call s:HL("TSSymbol",             s:purple,   "")
call s:HL("TSTag",                s:red,      "")
call s:HL("TSTagDelimiter",       s:fg4,      "")
call s:HL("TSText",               s:fg0,      "")
call s:HL("TSStrong",             s:fg0,      "",         "bold")
call s:HL("TSEmphasis",           s:fg0,      "",         "italic")
call s:HL("TSUnderline",          s:fg0,      "",         "underline")
call s:HL("TSStrike",             s:fg0,      "",         "strikethrough")
call s:HL("TSTitle",              s:blue,     "",         "bold")
call s:HL("TSLiteral",            s:green,    "")
call s:HL("TSURI",                s:blue,     "",         "underline")
call s:HL("TSType",               s:cyan,     "")
call s:HL("TSTypeBuiltin",        s:cyan,     "",         "italic")
call s:HL("TSVariable",           s:fg0,      "")
call s:HL("TSVariableBuiltin",    s:red,      "",         "italic")

" ===============================================================
" Terminal Colors (Neovim)
" ===============================================================
if has('nvim')
  let g:terminal_color_0 = s:bg0
  let g:terminal_color_1 = s:red
  let g:terminal_color_2 = s:green
  let g:terminal_color_3 = s:yellow
  let g:terminal_color_4 = s:blue
  let g:terminal_color_5 = s:purple
  let g:terminal_color_6 = s:cyan
  let g:terminal_color_7 = s:fg0
  let g:terminal_color_8 = s:bg4
  let g:terminal_color_9 = s:red
  let g:terminal_color_10 = s:green
  let g:terminal_color_11 = s:yellow
  let g:terminal_color_12 = s:blue
  let g:terminal_color_13 = s:purple
  let g:terminal_color_14 = s:cyan
  let g:terminal_color_15 = s:fg1
endif

" ===============================================================
" Cleanup
" ===============================================================
delfunc s:HL
