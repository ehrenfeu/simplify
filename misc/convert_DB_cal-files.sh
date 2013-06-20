grep ^DESCRIPTION $1 | \
sed 's,\\n,\n,g' | \
sed '/^DESC.*/d ; /^Datum:/d ; /^-$/d ; /^Alle Angaben ohne/d ; s/Dauer: \([0-9:]*\) .*Umsteige.* \([0-9]*\)/\nDauer: \1, Umsteigen: \2/' | \
sed 's,\(.*\) (\([^)]*\))$,\2:\n\1, ; s,- Gleis \([0-9a-z]*\),[\1],' | \
sed 's,^a[bn] , , ; s,([^)]*),, ; s, Hbf,,' | \
sed 's,  *, ,'
