;;; inputrc-mode.el --- Major mode for readline configuration -*- lexical-binding: t; -*-

;; Author: Noah Peart <noah.v.peart@gmail.com>
;; URL: https://github.com/nverno/inputrc-mode
;; Version: 0.1.0
;; Package-Requires: ((emacs "27.1"))
;; Created: 30 November 2023
;; Keywords: languages, readline, config

;; This file is not part of GNU Emacs.
;;
;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License as
;; published by the Free Software Foundation; either version 3, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
;; General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth
;; Floor, Boston, MA 02110-1301, USA.

;;; Commentary:
;;
;; Major mode for readline(3) configuration - inputrc files.
;;
;; Features:
;; - font-locking
;; - indentation
;; - completion-at-point for readline variables + commands
;;
;;; Code:

(eval-when-compile
  (require 'cl-lib)
  (require 'lisp-mode))
(require 'conf-mode)
(require 'smie)

(defcustom inputrc-mode-indent-level 2
  "Number of spaces for each indentation step."
  :group 'inputrc
  :type 'integer
  :safe 'integerp)


(defvar inputrc-mode-variables)
(defvar inputrc-mode-commands)
(defvar inputrc-mode-docs)

(let-when-compile
    ((info
      '((variables
         ("active-region-start-color" "" "A string variable that controls the text color and background when display ing
the text in the active region (see the description of enable-active-re gion
below). This string must not take up any physical character positions on the
display, so it should consist only of terminal escape sequences. It is output to
the terminal before displaying the text in the active region. This variable is
reset to the default value whenever the terminal type changes. The default value
is the string that puts the terminal in stand out mode, as obtained from the
terminal's terminfo description. A sample value might be \"\\e[01;33m\".")
         ("active-region-end-color" "" "A string variable that \"undoes\" the effects of active-region-start-color and
restores \"normal\" terminal display appearance after displaying text in the
active region. This string must not take up any physical character po sitions on
the display, so it should consist only of terminal escape se quences. It is
output to the terminal after displaying the text in the ac tive region. This
variable is reset to the default value whenever the ter minal type changes. The
default value is the string that restores the ter minal from standout mode, as
obtained from the terminal's terminfo descrip tion. A sample value might be
\"\\e[0m\".")
         ("bell-style" "audible" "Controls what happens when readline wants to ring the terminal bell. If set to
none, readline never rings the bell. If set to visible, readline uses a visible
bell if one is available. If set to audible, readline at tempts to ring the
terminal's bell.")
         ("bind-tty-special-chars" "On" "If set to On (the default), readline attempts to bind the control charac ters
treated specially by the kernel's terminal driver to their readline equivalents.")
         ("blink-matching-paren" "Off" "If set to On, readline attempts to briefly move the cursor to an opening
parenthesis when a closing parenthesis is inserted.")
         ("colored-completion-prefix" "Off" "If set to On, when listing completions, readline displays the common prefix of
the set of possible completions using a different color. The color def initions
are taken from the value of the LS_COLORS environment variable. If there is a
color definition in $LS_COLORS for the custom suffix \"read
line-colored-completion-prefix\", readline uses this color for the common prefix
instead of its default.")
         ("colored-stats" "Off" "If set to On, readline displays possible completions using different colors to
indicate their file type. The color definitions are taken from the value of the
LS_COLORS environment variable.")
         ("comment-begin" "``#''" "The string that is inserted in vi mode when the insert-comment command is
executed. This command is bound to M-# in emacs mode and to # in vi com mand
mode.")
         ("completion-display-width" "-1" "The number of screen columns used to display possible matches when perform ing
completion. The value is ignored if it is less than 0 or greater than the
terminal screen width. A value of 0 will cause matches to be displayed one per
line. The default value is -1.")
         ("completion-ignore-case" "Off" "If set to On, readline performs filename matching and completion in a
case-insensitive fashion.")
         ("completion-map-case" "Off" "If set to On, and completion-ignore-case is enabled, readline treats hy phens
(-) and underscores (_) as equivalent when performing case-insensi tive filename
matching and completion.")
         ("completion-prefix-display-length" "0" "The length in characters of the common prefix of a list of possible comple tions
that is displayed without modification. When set to a value greater than zero,
common prefixes longer than this value are replaced with an el lipsis when
displaying possible completions.")
         ("completion-query-items" "100" "This determines when the user is queried about viewing the number of possi ble
completions generated by the possible-completions command. It may be set to any
integer value greater than or equal to zero. If the number of possible
completions is greater than or equal to the value of this vari able, readline
will ask whether or not the user wishes to view them; other wise they are simply
listed on the terminal. A negative value causes read line to never ask.")
         ("convert-meta" "On" "If set to On, readline will convert characters with the eighth bit set to an
ASCII key sequence by stripping the eighth bit and prefixing it with an escape
character (in effect, using escape as the meta prefix). The default is On, but
readline will set it to Off if the locale contains eight-bit characters. This
variable is dependent on the LC_CTYPE locale category, and may change if the
locale is changed.")
         ("disable-completion" "Off" "If set to On, readline will inhibit word completion. Completion characters will
be inserted into the line as if they had been mapped to self-insert.")
         ("echo-control-characters" "On" "When set to On, on operating systems that indicate they support it, read line
echoes a character corresponding to a signal generated from the key board.")
         ("editing-mode" "emacs" "Controls whether readline begins with a set of key bindings similar to Emacs or
vi. editing-mode can be set to either emacs or vi.")
         ("emacs-mode-string" "@" "If the show-mode-in-prompt variable is enabled, this string is displayed
immediately before the last line of the primary prompt when emacs editing mode
is active. The value is expanded like a key binding, so the standard set of
meta- and control prefixes and backslash escape sequences is avail able. Use the
\\1 and \\2 escapes to begin and end sequences of non-printing characters, which
can be used to embed a terminal control sequence into the mode string.")
         ("enable-active-region" "On" "The point is the current cursor position, and mark refers to a saved cursor
position. The text between the point and mark is referred to as the re gion.
When this variable is set to On, readline allows certain commands to designate
the region as active. When the region is active, readline high lights the text
in the region using the value of the active-re gion-start-color, which defaults
to the string that enables the terminal's standout mode. The active region shows
the text inserted by bracketed- paste and any matching text found by incremental
and non-incremental his tory searches.")
         ("enable-bracketed-paste" "On" "When set to On, readline configures the terminal to insert each paste into the
editing buffer as a single string of characters, instead of treating each
character as if it had been read from the keyboard. This prevents readline from
executing any editing commands bound to key sequences appear ing in the pasted
text.")
         ("enable-keypad" "Off" "When set to On, readline will try to enable the application keypad when it is
called. Some systems need this to enable the arrow keys.")
         ("enable-meta-key" "On" "When set to On, readline will try to enable any meta modifier key the ter minal
claims to support when it is called. On many terminals, the meta key is used to
send eight-bit characters.")
         ("expand-tilde" "Off" "If set to On, tilde expansion is performed when readline attempts word com
pletion.")
         ("history-preserve-point" "Off" "If set to On, the history code attempts to place point at the same location on
each history line retrieved with previous-history or next-history.")
         ("history-size" "unset" "Set the maximum number of history entries saved in the history list. If set to
zero, any existing history entries are deleted and no new entries are saved. If
set to a value less than zero, the number of history entries is not limited. By
default, the number of history entries is not limited. If an attempt is made to
set history-size to a non-numeric value, the maxi mum number of history entries
will be set to 500.")
         ("horizontal-scroll-mode" "Off" "When set to On, makes readline use a single line for display, scrolling the
input horizontally on a single screen line when it becomes longer than the
screen width rather than wrapping to a new line. This setting is automati cally
enabled for terminals of height 1.")
         ("input-meta" "Off" "If set to On, readline will enable eight-bit input (that is, it will not clear
the eighth bit in the characters it reads), regardless of what the terminal
claims it can support. The name meta-flag is a synonym for this variable. The
default is Off, but readline will set it to On if the locale contains eight-bit
characters. This variable is dependent on the LC_CTYPE locale category, and may
change if the locale is changed.")
         ("isearch-terminators" "``C-[ C-J''" "The string of characters that should terminate an incremental search with out
subsequently executing the character as a command. If this variable has not been
given a value, the characters ESC and C-J will terminate an incremental search.")
         ("keymap" "emacs" "Set the current readline keymap. The set of legal keymap names is emacs,
emacs-standard, emacs-meta, emacs-ctlx, vi, vi-move, vi-command, and vi-in sert.
vi is equivalent to vi-command; emacs is equivalent to emacs-stan dard. The
default value is emacs. The value of editing-mode also affects the default
keymap.")
         ("keyseq-timeout" "500" "Specifies the duration readline will wait for a character when reading an
ambiguous key sequence (one that can form a complete key sequence using the
input read so far, or can take additional input to complete a longer key
sequence). If no input is received within the timeout, readline will use the
shorter but complete key sequence. The value is specified in millisec onds, so a
value of 1000 means that readline will wait one second for addi tional input. If
this variable is set to a value less than or equal to zero, or to a non-numeric
value, readline will wait until another key is pressed to decide which key
sequence to complete.")
         ("mark-directories" "On" "If set to On, completed directory names have a slash appended.")
         ("mark-modified-lines" "Off" "If set to On, history lines that have been modified are displayed with a
preceding asterisk (*).")
         ("mark-symlinked-directories" "Off" "If set to On, completed names which are symbolic links to directories have a
slash appended (subject to the value of mark-directories).")
         ("match-hidden-files" "On" "This variable, when set to On, causes readline to match files whose names begin
with a `.' (hidden files) when performing filename completion. If set to Off,
the leading `.' must be supplied by the user in the filename to be completed.")
         ("menu-complete-display-prefix" "Off" "If set to On, menu completion displays the common prefix of the list of possible
completions (which may be empty) before cycling through the list.")
         ("output-meta" "Off" "If set to On, readline will display characters with the eighth bit set di rectly
rather than as a meta-prefixed escape sequence. The default is Off, but readline
will set it to On if the locale contains eight-bit characters. This variable is
dependent on the LC_CTYPE locale category, and may change if the locale is
changed.")
         ("page-completions" "On" "If set to On, readline uses an internal more-like pager to display a screenful
of possible completions at a time.")
         ("print-completions-horizontally" "Off" "If set to On, readline will display completions with matches sorted hori
zontally in alphabetical order, rather than down the screen.")
         ("revert-all-at-newline" "Off" "If set to On, readline will undo all changes to history lines before re turning
when accept-line is executed. By default, history lines may be modified and
retain individual undo lists across calls to readline.")
         ("show-all-if-ambiguous" "Off" "This alters the default behavior of the completion functions. If set to On,
words which have more than one possible completion cause the matches to be
listed immediately instead of ringing the bell.")
         ("show-all-if-unmodified" "Off" "This alters the default behavior of the completion functions in a fashion
similar to show-all-if-ambiguous. If set to On, words which have more than one
possible completion without any possible partial completion (the possi ble
completions don't share a common prefix) cause the matches to be listed
immediately instead of ringing the bell.")
         ("show-mode-in-prompt" "Off" "If set to On, add a string to the beginning of the prompt indicating the editing
mode: emacs, vi command, or vi insertion. The mode strings are user-settable
(e.g., emacs-mode-string).")
         ("skip-completed-text" "Off" "If set to On, this alters the default completion behavior when inserting a
single match into the line. It's only active when performing completion in the
middle of a word. If enabled, readline does not insert characters from the
completion that match characters after point in the word being com pleted, so
portions of the word following the cursor are not duplicated.")
         ("vi-cmd-mode-string" "cmd" "If the show-mode-in-prompt variable is enabled, this string is displayed
immediately before the last line of the primary prompt when vi editing mode is
active and in command mode. The value is expanded like a key binding, so the
standard set of meta- and control prefixes and backslash escape se quences is
available. Use the \\1 and \\2 escapes to begin and end sequences of
non-printing characters, which can be used to embed a terminal control sequence
into the mode string.")
         ("vi-ins-mode-string" "ins" "If the show-mode-in-prompt variable is enabled, this string is displayed
immediately before the last line of the primary prompt when vi editing mode is
active and in insertion mode. The value is expanded like a key binding, so the
standard set of meta- and control prefixes and backslash escape se quences is
available. Use the \\1 and \\2 escapes to begin and end sequences of
non-printing characters, which can be used to embed a terminal control sequence
into the mode string.")
         ("visible-stats" "Off" "If set to On, a character denoting a file's type as reported by stat(2) is
appended to the filename when listing possible completions."))
        (commands
         ("beginning-of-line" "C-a" "Move to the start of the current line.")
         ("end-of-line" "C-e" "Move to the end of the line.")
         ("forward-char" "C-f" "Move forward a character.")
         ("backward-char" "C-b" "Move back a character.")
         ("forward-word" "M-f" "Move forward to the end of the next word. Words are composed of alphanu meric
characters (letters and digits).")
         ("backward-word" "M-b" "Move back to the start of the current or previous word. Words are composed of
alphanumeric characters (letters and digits).")
         ("previous-screen-line" "" "Attempt to move point to the same physical screen column on the previous
physical screen line. This will not have the desired effect if the current
readline line does not take up more than one physical line or if point is not
greater than the length of the prompt plus the screen width.")
         ("next-screen-line" "" "Attempt to move point to the same physical screen column on the next physi cal
screen line. This will not have the desired effect if the current read line line
does not take up more than one physical line or if the length of the current
readline line is not greater than the length of the prompt plus the screen
width.")
         ("clear-display" "M-C-l" "Clear the screen and, if possible, the terminal's scrollback buffer, then redraw
the current line, leaving the current line at the top of the screen.")
         ("clear-screen" "C-l" "Clear the screen, then redraw the current line, leaving the current line at the
top of the screen. With an argument, refresh the current line without clearing
the screen.")
         ("redraw-current-line" "" "Refresh the current line. Commands for Manipulating the History")
         ("accept-line" "Newline, Return" "Accept the line regardless of where the cursor is. If this line is non- empty,
it may be added to the history list for future recall with add_his tory(). If
the line is a modified history line, the history line is re stored to its
original state.")
         ("previous-history" "C-p" "Fetch the previous command from the history list, moving back in the list.")
         ("next-history" "C-n" "Fetch the next command from the history list, moving forward in the list.")
         ("beginning-of-history" "M-<" "Move to the first line in the history.")
         ("end-of-history" "M->" "Move to the end of the input history, i.e., the line currently being en tered.")
         ("operate-and-get-next" "C-o" "Accept the current line for return to the calling application as if a new line
had been entered, and fetch the next line relative to the current line from the
history for editing. A numeric argument, if supplied, specifies the history
entry to use instead of the current line.")
         ("fetch-history" "" "With a numeric argument, fetch that entry from the history list and make it the
current line. Without an argument, move back to the first entry in the history
list.")
         ("reverse-search-history" "C-r" "Search backward starting at the current line and moving `up' through the history
as necessary. This is an incremental search.")
         ("forward-search-history" "C-s" "Search forward starting at the current line and moving `down' through the
history as necessary. This is an incremental search.")
         ("non-incremental-reverse-search-history" "M-p" "Search backward through the history starting at the current line using a
non-incremental search for a string supplied by the user.")
         ("non-incremental-forward-search-history" "M-n" "Search forward through the history using a non-incremental search for a string
supplied by the user.")
         ("history-search-backward" "" "Search backward through the history for the string of characters between the
start of the current line and the current cursor position (the point). The
search string must match at the beginning of a history line. This is a
non-incremental search.")
         ("history-search-forward" "" "Search forward through the history for the string of characters between the
start of the current line and the point. The search string must match at the
beginning of a history line. This is a non-incremental search.")
         ("history-substring-search-backward" "" "Search backward through the history for the string of characters between the
start of the current line and the current cursor position (the point). The
search string may match anywhere in a history line. This is a non-in cremental
search.")
         ("history-substring-search-forward" "" "Search forward through the history for the string of characters between the
start of the current line and the point. The search string may match any where
in a history line. This is a non-incremental search.")
         ("yank-nth-arg" "M-C-y" "Insert the first argument to the previous command (usually the second word on
the previous line) at point. With an argument n, insert the nth word from the
previous command (the words in the previous command begin with word 0). A
negative argument inserts the nth word from the end of the pre vious command.
Once the argument n is computed, the argument is extracted as if the \"!n\"
history expansion had been specified.")
         ("yank-last-arg" "M-., M-_" "Insert the last argument to the previous command (the last word of the pre vious
history entry). With a numeric argument, behave exactly like yank-nth-arg.
Successive calls to yank-last-arg move back through the his tory list, inserting
the last word (or the word specified by the argument to the first call) of each
line in turn. Any numeric argument supplied to these successive calls determines
the direction to move through the his tory. A negative argument switches the
direction through the history (back or forward). The history expansion
facilities are used to extract the last argument, as if the \"!$\" history
expansion had been specified. Commands for Changing Text end-of-file (usually
C-d) The character indicating end-of-file as set, for example, by ``stty''. If
this character is read when there are no characters on the line, and point is at
the beginning of the line, readline interprets it as the end of input and
returns EOF.")
         ("delete-char" "C-d" "Delete the character at point. If this function is bound to the same char acter
as the tty EOF character, as C-d commonly is, see above for the ef fects.")
         ("backward-delete-char" "Rubout" "Delete the character behind the cursor. When given a numeric argument, save the
deleted text on the kill ring.")
         ("forward-backward-delete-char" "" "Delete the character under the cursor, unless the cursor is at the end of the
line, in which case the character behind the cursor is deleted.")
         ("quoted-insert" "C-q, C-v" "Add the next character that you type to the line verbatim. This is how to insert
characters like C-q, for example.")
         ("tab-insert" "M-TAB" "Insert a tab character.")
         ("self-insert" "a, b, A, 1, !, ..." "Insert the character typed.")
         ("transpose-chars" "C-t" "Drag the character before point forward over the character at point, moving
point forward as well. If point is at the end of the line, then this transposes
the two characters before point. Negative arguments have no ef fect.")
         ("transpose-words" "M-t" "Drag the word before point past the word after point, moving point over that
word as well. If point is at the end of the line, this transposes the last two
words on the line.")
         ("upcase-word" "M-u" "Uppercase the current (or following) word. With a negative argument, up percase
the previous word, but do not move point.")
         ("downcase-word" "M-l" "Lowercase the current (or following) word. With a negative argument, low ercase
the previous word, but do not move point.")
         ("capitalize-word" "M-c" "Capitalize the current (or following) word. With a negative argument, cap
italize the previous word, but do not move point.")
         ("overwrite-mode" "" "Toggle overwrite mode. With an explicit positive numeric argument, switches to
overwrite mode. With an explicit non-positive numeric argu ment, switches to
insert mode. This command affects only emacs mode; vi mode does overwrite
differently. Each call to readline() starts in insert mode. In overwrite mode,
characters bound to self-insert replace the text at point rather than pushing
the text to the right. Characters bound to backward-delete-char replace the
character before point with a space. By default, this command is unbound.
Killing and Yanking")
         ("kill-line" "C-k" "Kill the text from point to the end of the line.")
         ("backward-kill-line" "C-x Rubout" "Kill backward to the beginning of the line.")
         ("unix-line-discard" "C-u" "Kill backward from point to the beginning of the line. The killed text is saved
on the kill-ring.")
         ("kill-whole-line" "" "Kill all characters on the current line, no matter where point is.")
         ("kill-word" "M-d" "Kill from point the end of the current word, or if between words, to the end of
the next word. Word boundaries are the same as those used by for ward-word.")
         ("backward-kill-word" "M-Rubout" "Kill the word behind point. Word boundaries are the same as those used by
backward-word.")
         ("unix-word-rubout" "C-w" "Kill the word behind point, using white space as a word boundary. The killed
text is saved on the kill-ring.")
         ("unix-filename-rubout" "" "Kill the word behind point, using white space and the slash character as the
word boundaries. The killed text is saved on the kill-ring.")
         ("delete-horizontal-space" "M-\\" "Delete all spaces and tabs around point.")
         ("kill-region" "" "Kill the text between the point and mark (saved cursor position). This text is
referred to as the region.")
         ("copy-region-as-kill" "" "Copy the text in the region to the kill buffer.")
         ("copy-backward-word" "" "Copy the word before point to the kill buffer. The word boundaries are the same
as backward-word.")
         ("copy-forward-word" "" "Copy the word following point to the kill buffer. The word boundaries are the
same as forward-word.")
         ("yank" "C-y" "Yank the top of the kill ring into the buffer at point.")
         ("yank-pop" "M-y" "Rotate the kill ring, and yank the new top. Only works following yank or
yank-pop. Numeric Arguments")
         ("digit-argument" "M-0, M-1, ..., M--" "Add this digit to the argument already accumulating, or start a new argu ment.
M-- starts a negative argument.")
         ("universal-argument" "" "This is another way to specify an argument. If this command is followed by one
or more digits, optionally with a leading minus sign, those digits de fine the
argument. If the command is followed by digits, executing univer sal-argument
again ends the numeric argument, but is otherwise ignored. As a special case, if
this command is immediately followed by a character that is neither a digit or
minus sign, the argument count for the next command is multiplied by four. The
argument count is initially one, so executing this function the first time makes
the argument count four, a second time makes the argument count sixteen, and so
on. Completing")
         ("complete" "TAB" "Attempt to perform completion on the text before point. The actual comple tion
performed is application-specific. Bash, for instance, attempts com pletion
treating the text as a variable (if the text begins with $), user name (if the
text begins with ~), hostname (if the text begins with @), or command (including
aliases and functions) in turn. If none of these pro duces a match, filename
completion is attempted. Gdb, on the other hand, allows completion of program
functions and variables, and only attempts filename completion under certain
circumstances.")
         ("possible-completions" "M-?" "List the possible completions of the text before point. When displaying
completions, readline sets the number of columns used for display to the value
of completion-display-width, the value of the environment variable COLUMNS, or
the screen width, in that order.")
         ("insert-completions" "M-*" "Insert all completions of the text before point that would have been gener ated
by possible-completions.")
         ("menu-complete" "" "Similar to complete, but replaces the word to be completed with a single match
from the list of possible completions. Repeated execution of menu-complete steps
through the list of possible completions, inserting each match in turn. At the
end of the list of completions, the bell is rung (subject to the setting of
bell-style) and the original text is re stored. An argument of n moves n
positions forward in the list of matches; a negative argument may be used to
move backward through the list. This command is intended to be bound to TAB, but
is unbound by default.")
         ("menu-complete-backward" "" "Identical to menu-complete, but moves backward through the list of possible
completions, as if menu-complete had been given a negative argument. This
command is unbound by default.")
         ("delete-char-or-list" "" "Deletes the character under the cursor if not at the beginning or end of the
line (like delete-char). If at the end of the line, behaves identi cally to
possible-completions. Keyboard Macros")
         ("start-kbd-macro" "C-x " "Begin saving the characters typed into the current keyboard macro.")
         ("end-kbd-macro" "C-x " "Stop saving the characters typed into the current keyboard macro and store the
definition.")
         ("call-last-kbd-macro" "C-x e" "Re-execute the last keyboard macro defined, by making the characters in the
macro appear as if typed at the keyboard.")
         ("print-last-kbd-macro" "" "Print the last keyboard macro defined in a format suitable for the inputrc file.
Miscellaneous")
         ("re-read-init-file" "C-x C-r" "Read in the contents of the inputrc file, and incorporate any bindings or
variable assignments found there.")
         ("abort" "C-g" "Abort the current editing command and ring the terminal's bell (subject to the
setting of bell-style).")
         ("do-lowercase-version" "M-A, M-B, M-x, ..." "If the metafied character x is uppercase, run the command that is bound to the
corresponding metafied lowercase character. The behavior is undefined if x is
already lowercase.")
         ("prefix-meta" "ESC" "Metafy the next character typed. ESC f is equivalent to Meta-f.")
         ("undo" "C-_, C-x C-u" "Incremental undo, separately remembered for each line.")
         ("revert-line" "M-r" "Undo all changes made to this line. This is like executing the undo com mand
enough times to return the line to its initial state.")
         ("tilde-expand" "M-&" "Perform tilde expansion on the current word.")
         ("set-mark" "C-@, M-<space>" "Set the mark to the point. If a numeric argument is supplied, the mark is set to
that position.")
         ("exchange-point-and-mark" "C-x C-x" "Swap the point with the mark. The current cursor position is set to the saved
position, and the old cursor position is saved as the mark.")
         ("character-search" "C-]" "A character is read and point is moved to the next occurrence of that char
acter. A negative argument searches for previous occurrences.")
         ("character-search-backward" "M-C-]" "A character is read and point is moved to the previous occurrence of that
character. A negative argument searches for subsequent occurrences.")
         ("skip-csi-sequence" "" "Read enough characters to consume a multi-key sequence such as those de fined
for keys like Home and End. Such sequences begin with a Control Se quence
Indicator (CSI), usually ESC-[. If this sequence is bound to \"\\[\", keys
producing such sequences will have no effect unless explicitly bound to a
readline command, instead of inserting stray characters into the edit ing
buffer. This is unbound by default, but usually bound to ESC-[.")
         ("insert-comment" "M-#" "Without a numeric argument, the value of the readline comment-begin vari able is
inserted at the beginning of the current line. If a numeric argu ment is
supplied, this command acts as a toggle: if the characters at the beginning of
the line do not match the value of comment-begin, the value is inserted,
otherwise the characters in comment-begin are deleted from the beginning of the
line. In either case, the line is accepted as if a new line had been typed. The
default value of comment-begin makes the current line a shell comment. If a
numeric argument causes the comment character to be removed, the line will be
executed by the shell.")
         ("dump-functions" "" "Print all of the functions and their key bindings to the readline output stream.
If a numeric argument is supplied, the output is formatted in such a way that it
can be made part of an inputrc file.")
         ("dump-variables" "" "Print all of the settable variables and their values to the readline output
stream. If a numeric argument is supplied, the output is formatted in such a way
that it can be made part of an inputrc file.")
         ("dump-macros" "" "Print all of the readline key sequences bound to macros and the strings they
output. If a numeric argument is supplied, the output is formatted in such a way
that it can be made part of an inputrc file.")
         ("emacs-editing-mode" "C-e" "When in vi command mode, this causes a switch to emacs editing mode.")
         ("vi-editing-mode" "M-C-j" "When in emacs editing mode, this causes a switch to vi editing mode."))))
     (var-info (assoc-default 'variables info))
     (cmd-info (assoc-default 'commands info))
     (cmds ())
     (vars ())
     (docs (let ((ht (make-hash-table :test #'equal)))
             (cl-loop for (var default doc) in var-info
                      do (puthash var `(:doc ,doc :default ,default) ht)
                      do (push var vars))
             (cl-loop for (cmd default doc) in cmd-info
                      do (puthash cmd `(:doc ,doc :default ,default) ht)
                      do (push cmd cmds))
             ht)))
  (let ((vars (eval-when-compile vars))
        (cmds (eval-when-compile cmds))
        (docs (eval-when-compile docs)))
    (defconst inputrc-mode-variables vars)
    (defconst inputrc-mode-commands cmds)
    (defconst inputrc-mode-docs docs)))

;;; Completion

(defun inputrc-mode--doc-buffer (arg)
  "Return documentation buffer for ARG."
  (cl-destructuring-bind (&key doc default)
      (gethash arg inputrc-mode-docs)
    (let ((doc (concat
                (propertize doc 'face 'font-lock-doc-face) "\n\n"
                (propertize "Default: " 'face 'bold)
                (propertize default 'face 'font-lock-type-face))))
      (if (fboundp 'company-doc-buffer)
          (funcall #'company-doc-buffer doc)
        (with-current-buffer (get-buffer-create "*inputrc-doc*")
          (erase-buffer)
          (save-excursion (insert doc))
          (current-buffer))))))

(defun inputrc-mode--annotation (arg)
  "Return annotation for completion candidate ARG."
  (when-let (def (plist-get (gethash arg inputrc-mode-docs) :default))
    (concat " " def)))

(defun inputrc-mode-completion-at-point ()
  "Completion at point for `inputrc-mode'."
  (unless (let* ((syn (syntax-ppss)))
            (or (car (setq syn (nthcdr 3 syn)))
                (car (setq syn (cdr syn)))
                (nth 3 syn)))
    (let* ((pos (point))
           (bol (line-beginning-position))
           (set-p)
           (cmd-p)
           (beg (condition-case nil
                    (save-excursion
                      (backward-sexp 1)
                      (setq set-p (ignore-errors
                                    (looking-back "^\\s-*set\\s-+" bol)))
                      (prog1 (point)
                        (skip-syntax-backward " " bol)
                        (setq cmd-p (eq ?: (char-before)))))
                  (scan-error nil)))
           (cond-p (eq ?$ (char-after beg))))
      (when (and pos beg (> pos beg)
                 (or set-p cond-p cmd-p))
        (nconc (list beg pos)
               (cond
                (cond-p
                 (list (completion-table-dynamic
                        (lambda (_s) (list "$if" "$endif" "$else" "$include")))))
                (cmd-p
                 (list (completion-table-dynamic (lambda (_s) inputrc-mode-commands))
                       :annotation-function #'inputrc-mode--annotation
                       :company-doc-buffer #'inputrc-mode--doc-buffer))
                (set-p
                 (list (completion-table-dynamic (lambda (_s) inputrc-mode-variables))
                       :annotation-function #'inputrc-mode--annotation
                       :company-doc-buffer #'inputrc-mode--doc-buffer))))))))

;;; Indentation

(defconst inputrc-mode-grammar
  (smie-prec2->grammar
   (smie-bnf->prec2
    '((exp)
      (cmd ("$if" exp "$endif")
           ("$if" exp "$else" exp "$endif")
           (exp))))))

(defun inputrc-mode-smie-rules (kind token)
  "Indentation rules for `inputrc-mode'.
See `smie-rules-function' for description of KIND and TOKEN."
  (pcase (cons kind token)
    (`(:elem . basic) inputrc-mode-indent-level)
    (`(:elem . args))
    (`(:after . ,(or "$if" "$else")) inputrc-mode-indent-level)
    (`(:list-intro . ,(or "$if" "$else" "")) t)
    (`(:close-all . ,_) t)))

(defun inputrc-mode-backward-token ()
  "Function for `smie-backward-token-function' to find previous token."
  (forward-comment (- (point)))
  (beginning-of-line)
  (skip-syntax-forward " " (line-end-position))
  (if (looking-at (rx (or "$if" "$else" "$endif")))
      (match-string 0)
    "\n"))

;;; Font-locking

(defvar inputrc-mode-font-lock-keywords
  `((,(rx bol (* space) (or (seq "$" (or "include" "if" "else" "endif")) "set") eow)
     . font-lock-keyword-face)
    ("^\\s-*$include[ \t]+\\([[:graph:]]+\\)" (1 font-lock-string-face))
    ;; set <variable> <value>
    (,(rx bow (or "on" "off") eow) . font-lock-constant-face)
    ("\\b[0-9]+\\b" . 'font-lock-number-face)
    ("^[ \t]*set[ \t]+\\([0-9a-z-]+\\)\\b[ \t]*\\([[:graph:]]*\\)?"
     (1 font-lock-variable-name-face)
     (2 font-lock-string-face))
    ;; $if ...
    ("^\\s-*\\$if[ \t]+\\(mode\\|term\\)\\(=\\)?\\(\\S-*\\)?"
     (1 font-lock-keyword-face)
     (2 'font-lock-operator-face)
     (3 'font-lock-variable-use-face))
    ("^\\s-*\\$if[ \t]+\\(version\\)[ \t]*\\(!=\\|[<=>]=\\|[<=>]\\)?"
     (1 font-lock-keyword-face)
     (2 'font-lock-operator-face))
    ("^\\s-*\\$if[ \t]+\\([[:graph:]]+\\)[ \t]+\\([!=]?=\\)[ \t]*\\([^\n]*\\)?"
     (1 'font-lock-variable-use-face)
     (2 'font-lock-operator-face))
    ("^\\s-*\\$if[ \t]+\\([[:alpha:]]+\\)" (1 font-lock-type-face))
    ;; Key-bindings
    ((lambda (lim)
       (and (re-search-forward "\\(\\\\[A-Za-z]\\(?:-[^\\]?\\)?\\)" lim t)
            (null (nth 4 (syntax-ppss (match-beginning 0))))))
     (1 'font-lock-type-face prepend))
    ;; "keyseq": function-name or macro
    ("^\\s-*\"[^\n:]+\"\\(:\\)[ \t]*\\([[:graph:]]+\\)?"
     (1 'font-lock-delimiter-face)
     (2 'font-lock-function-call-face))
    ;; keyname: function-name or macro
    ("^\\s-*\\([[:alpha:]-]+\\)[ \t]*\\(:\\)[ \t]*\\([[:graph:]]+\\)?"
     (1 font-lock-type-face)
     (2 'font-lock-delimiter-face)
     (3 'font-lock-function-call-face))))

(defun inputrc-mode--syntax-propertize (start end)
  "Apply syntax properties to text between START and END."
  (goto-char start)
  (funcall
   (syntax-propertize-rules
    ;; Font-lock ignored text after bindings as comment, eg.
    ;;   "\C-u": universal-argument  <any trailing text is ignored>
    ("\"?\\([[:graph:]]+\\)\"?[ \t]*:[ \t]*\"?\\([[:graph:]]+\\)\"?[ \t]+\\([^ \t\n]\\)"
     (3 "<")))
   (point) end))

;;; Syntax

(defvar inputrc-mode-syntax-table
  (let ((table (make-syntax-table)))
    (modify-syntax-entry ?$ "'" table)
    (modify-syntax-entry ?# "<" table)
    (modify-syntax-entry ?\n ">" table)
    table))

;;;###autoload
(define-derived-mode inputrc-mode conf-unix-mode "Conf[inputrc]"
  "Major mode for readline(3) configuration."
  :syntax-table inputrc-mode-syntax-table
  :group 'conf
  (conf-mode-initialize "#")
  (setq-local font-lock-defaults '(inputrc-mode-font-lock-keywords))
  (smie-setup inputrc-mode-grammar #'inputrc-mode-smie-rules
              :backward-token #'inputrc-mode-backward-token)
  (setq-local syntax-propertize-function #'inputrc-mode--syntax-propertize)
  (add-hook 'completion-at-point-functions #'inputrc-mode-completion-at-point nil t))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.?inputrc\\'" . inputrc-mode))

(provide 'inputrc-mode)
;; Local Variables:
;; coding: utf-8
;; indent-tabs-mode: nil
;; End:
;;; inputrc-mode.el ends here
