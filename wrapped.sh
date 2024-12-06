echo '\x1b[36m  ______                    _             __ ';
echo ' /_  __/__  _________ ___  (_)___  ____ _/ / ';
echo '  / / / _ \/ ___/ __ `__ \/ / __ \/ __ `/ /  ';
echo ' / / /  __/ /  / / / / / / / / / / /_/ / /   ';
echo '/_/  \___/_/  /_/ /_/ /_/_/_/ /_/\__,_/_/    ';
echo '\x1b[32m                                             ';
echo ' _       __                                __';
echo '| |     / /________ _____  ____  ___  ____/ /';
echo '| | /| / / ___/ __ `/ __ \/ __ \/ _ \/ __  / ';
echo '| |/ |/ / /  / /_/ / /_/ / /_/ /  __/ /_/ /  ';
echo '|__/|__/_/   \__,_/ .___/ .___/\___/\__,_/   ';
echo '                 /_/   /_/                   ';
echo '\x1b[31m          ___   ____ ___  __ __              ';
echo '         |__ \ / __ \__ \/ // /              ';
echo '         __/ // / / /_/ / // /_              ';
echo '        / __// /_/ / __/__  __/              ';
echo '       /____/\____/____/ /_/                 ';
echo '\x1b[0m' # Clear

# 2024 Jan 1st Timestamp
SMALLEST_DATE=$(date -j 010100002024 "+%s")

TOTAL_THIS_YEAR=$(cat $HISTFILE | awk "(\$2 > $SMALLEST_DATE)" | grep "" -c)


TOP_TEN=$(cat $HISTFILE | awk "(\$2 > $SMALLEST_DATE)" | iconv -f utf-8 -t utf-8 -c | awk -F";| " '{count[$3]++} END {for (word in count) print word, count[word]}' | sort -r -n -k2 | head -n 10)

rounddate()
{
  echo $((($1 / 86400) * 86400))
}

BUSIEST_DATE=$(cat $HISTFILE | awk "(\$2 > $SMALLEST_DATE)" | iconv -f utf-8 -t utf-8 -c | grep -oE "\d{10}" |\
 while IFS= read -r date; do rounddate $date; done | \
 awk -F "%" '{count[$1]++} END {for (word in count) print word, count[word]}' | sort -r -n -k2 | head -n 1 | \
 awk -F" " '{ cmd="date -j -f %s "$1 " \"+%a %-d %B\"" ; cmd | getline mydate ; close(cmd); print "Hard at work! Your busiest day was", mydate, "with",$2,"commands" }')

echo "Wow! This year you ran \x1b[1m$TOTAL_THIS_YEAR\x1b[0m commands\n"

echo "Here are your top five commands:"
echo "$TOP_TEN" | column -t

echo ""
echo "$BUSIEST_DATE"