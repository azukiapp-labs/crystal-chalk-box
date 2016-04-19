# :nodoc:
module ChalkBox::Styles::Colors
  # Foreground colors
  #   8 default, 3 alias for gray and more 8 for extends
  FORE_DEFAULT       = ["39", "39"]
  FORE_BLACK         = ["30", "39"]
  FORE_RED           = ["31", "39"]
  FORE_GREEN         = ["32", "39"]
  FORE_YELLOW        = ["33", "39"]
  FORE_BLUE          = ["34", "39"]
  FORE_MAGENTA       = ["35", "39"]
  FORE_CYAN          = ["36", "39"]
  FORE_GRAY          = ["37", "39"]
  FORE_GREY          = FORE_GRAY
  FORE_LIGHT_GRAY    = FORE_GRAY
  FORE_LIGHT_GREY    = FORE_GRAY
  FORE_DARK_GRAY     = ["90", "39"]
  FORE_DARK_GREY     = FORE_DARK_GRAY
  FORE_LIGHT_RED     = ["91", "39"]
  FORE_LIGHT_GREEN   = ["92", "39"]
  FORE_LIGHT_YELLOW  = ["93", "39"]
  FORE_LIGHT_BLUE    = ["94", "39"]
  FORE_LIGHT_MAGENTA = ["95", "39"]
  FORE_LIGHT_CYAN    = ["96", "39"]
  FORE_WHITE         = ["97", "39"]

  # Background colors
  #   8 default, 3 alias for gray and more 8 for extends
  BACK_DEFAULT       = ["49", "49"]
  BACK_BLACK         = ["40", "49"]
  BACK_RED           = ["41", "49"]
  BACK_GREEN         = ["42", "49"]
  BACK_YELLOW        = ["43", "49"]
  BACK_BLUE          = ["44", "49"]
  BACK_MAGENTA       = ["45", "49"]
  BACK_CYAN          = ["46", "49"]
  BACK_GRAY          = ["47", "49"]
  BACK_GREY          = BACK_GRAY
  BACK_LIGHT_GRAY    = BACK_GRAY
  BACK_LIGHT_GREY    = BACK_GRAY
  BACK_DARK_GRAY     = ["100", "49"]
  BACK_DARK_GREY     = BACK_DARK_GRAY
  BACK_LIGHT_RED     = ["101", "49"]
  BACK_LIGHT_GREEN   = ["102", "49"]
  BACK_LIGHT_YELLOW  = ["103", "49"]
  BACK_LIGHT_BLUE    = ["104", "49"]
  BACK_LIGHT_MAGENTA = ["105", "49"]
  BACK_LIGHT_CYAN    = ["106", "49"]
  BACK_WHITE         = ["107", "49"]

  # Modifiers
  MOD_DEFAULT   = ["0", "0"]
  MOD_BOLD      = ["1", "22"]
  MOD_BRIGHT    = ["1", "22"] # Bold conflict
  MOD_DIM       = ["2", "23"]
  MOD_UNDERLINE = ["4", "34"]
  MOD_BLINK     = ["5", "27"]
  MOD_REVERSE   = ["7", "28"]
  MOD_HIDDEN    = ["8", "29"]

  COLORS    = %w(black red green yellow blue magenta cyan gray grey light_gray light_grey dark_gray dark_grey light_red light_green light_yellow light_blue light_magenta light_cyan white)
  MODIFIERS = %w(bold bright dim underline blink reverse hidden)
end
