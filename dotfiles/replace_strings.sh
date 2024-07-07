# /usr/bin/env nix-shell
# nix-shell -i bash -p bash stow findutils file moreutils


set -euo pipefail


export PATH="$coreutils/bin:$gnugrep/bin:$findutils/bin:$gnused/bin"

cp -r $original $out

chmod -R +rw $out 

#ls -lha ./temp/nitrogen


while IFS= read -r line; do
parts=($line)
if [ ${#parts[@]} -eq 2 ]; then
    f="${parts[0]}"
    s="${parts[1]}"
    echo "Replace: $f, With: $s"
    grep -Rl "$f" $out | xargs sed -i "s/$f/$s/g"
else
    echo "Invalid input: $line"
    exit 1
fi

done <<< "$replacements"
