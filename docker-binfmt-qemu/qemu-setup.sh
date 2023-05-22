mkdir /opt/qemu-user-static/binfmt
/qemu-generate.sh --qemu-path "/opt/qemu-user-static/bin" --qemu-suffix "-static" --debian --exportdir "/opt/qemu-user-static/binfmt"
update-binfmts --importdir "/opt/qemu-user-static/binfmt" --import
update-binfmts --display
update-binfmts --enable
echo $(update-binfmts --display)
