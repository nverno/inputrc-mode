#!/usr/bin/awk -f

function fill_paragraph(text, maxlen) {
  paragraphs = split(text, para, "\n\n")
  for (i = 1; i <= paragraphs; i++) {
    num_words = split(para[i], words, " ")
    filled_para = words[1]
    line_length = length(words[1])

    for (j = 2; j <= num_words; j++) {
      if (line_length + 1 + length(words[j]) <= maxlen) {
        filled_para = filled_para " " words[j]
        line_length += 1 + length(words[j])
      }
      else {
        filled_para = filled_para "\n" words[j]
        line_length = length(words[j])
      }
    }
    return filled_para
  }
}

function escape(str) {
  gsub(/\\/, "\\\\", str)
  gsub(/"/, "\\\"", str)
  return str
}

function print_description(desc) {
  if (length(acc) == 0)
    return
  gsub(/^\s+|.|‐/, "", desc)
  gsub(/\s+/, " ", desc)
  printf " \"%s\")\n", fill_paragraph(escape(desc), 80)
  acc = ""
}

BEGIN {
  variables = commands = var_idx = 0
  acc = ""
  print "("
}

# Sections
/^\s+VVaarriiaabblleess/ {
  print "(variables "
  variables = 1; next
}

/^\s+CCoonnddiittiioonnaall/ {
  print_description(acc);
  print ")" # close variables
  variables = 0; next
}

/^\s+CCoommmmaannddss ffoorr MMoovviinngg/ {
  print "(commands "
  commands = 1; next
}

/^\S/ {
  variables = conditional = commands = var_idx = 0;
  next
}

(commands || variables) && $0 ~ /^ {7}(([a-z])+)/ {
  if (var_idx++) 
    print_description(acc)
  gsub(/^\s*|./,"")
  printf "(\"%s\" ", $1
  $1 = ""

  # Extract default
  sub(/^\s+/, "")
  gsub(/[)(]/,"")
  printf "\"%s\"", escape($0)
  next
}
# Variable/command descriptions
(commands || variables) && var_idx {
  acc = acc $0
}

END {
  print_description(acc);
  print "))"  # close commands
}
