#!/bin/bash
CURRENT_DIR="$1"

# 1. один раз собираем даты
DATA=$(find "$CURRENT_DIR" -type f -printf "%TY-%Tm-%Td\n" 2>/dev/null)

# ----------------------
# YEAR
# ----------------------
YEAR=$(echo "$DATA" \
  | cut -d'-' -f1 \
  | sort -u \
  | fzf --prompt="Год > " --height=10 --border)

[ -z "$YEAR" ] && exit 0

# ----------------------
# MONTH (фильтруем уже YEAR)
# ----------------------
MONTH=$(echo "$DATA" \
  | grep "^$YEAR" \
  | cut -d'-' -f2 \
  | sort -u \
  | fzf --prompt="Месяц (Enter=все) > " --height=10 --border)

# ----------------------
# DAY (если есть месяц)
# ----------------------
if [ -z "$MONTH" ]; then
  PATTERN="$YEAR"
else
  DAY=$(echo "$DATA" \
    | grep "^$YEAR-$MONTH" \
    | cut -d'-' -f3 \
    | sort -u \
    | fzf --prompt="День (Enter=все) > " --height=10 --border)

  PATTERN="$YEAR-$MONTH${DAY:+-$DAY}"
fi

echo "$PATTERN" > /tmp/yazi-date-filter
