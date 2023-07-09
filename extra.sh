#!/bin/bash

curl -Sk https://raw.githubusercontent.com/chrishazfun/installarch/main/.bashrc >> ~/.bashrc
source ~/.bashrc

nc=$(grep -c ^processor /proc/cpuinfo)
sed -i "s/#MAKEFLAGS=\"-j2\"/MAKEFLAGS=\"-j$nc\"/g" /etc/makepkg.conf
sed -i "s/COMPRESSXZ=(xz -c -z -)/COMPRESSXZ=(xz -c -T $nc -z -)/g" /etc/makepkg.conf

# read command needed for lsp/zam shortcut flush
echo '[Desktop Entry]
Hidden=true' > /tmp/1
find /usr -name "*lsp_plug*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}
find /usr -name "*zam*desktop" 2>/dev/null | cut -f 5 -d '/' | xargs -I {} cp /tmp/1 ~/.local/share/applications/{}

# read command needed for qemu vm setup
pacman -S --needed qemu virt-manager virt-viewer dnsmasq vde2 bridge-utils libguestfs ovmf swtpm openbsd-netcat
sed -i 's/^#unix_sock_group = \"libvirt\"/unix_sock_group = \"libvirt\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_ro_perms = \"0777\"/unix_sock_ro_perms = \"0777\"/' /etc/libvirt/libvirtd.conf
sed -i 's/^#unix_sock_rw_perms = \"0770\"/unix_sock_rw_perms = \"0770\"/' /etc/libvirt/libvirtd.conf
usermod -aG libvirt $USERNAME
sudo systemctl enable libvirtd

# flatpak apps i like
# sh.cider.Cider

ffmpeg "-hide_banner" "-i" "C:/Users/lowle/Downloads/gemmabetty1.mp4" "-sws_flags" "spline+accurate_rnd+full_chroma_int" "-color_trc" "1" "-colorspace" "1" "-color_primaries" "1" "-filter_complex" "tvai_up=model=iris-1:scale=0:w=2560:h=1440:preblur=0:noise=0:details=0:halo=0:blur=0:compression=0:estimate=20:device=0:vram=0.9:instances=0,scale=w=2560:h=1440:flags=lanczos:threads=0,scale=out_color_matrix=bt709" "-c:v" "h264_nvenc" "-profile:v" "high" "-preset" "medium" "-pix_fmt" "yuv420p" "-b:v" "0" "-an" "-map_metadata" "0" "-map_metadata:s:v" "0:s:v" "-movflags" "frag_keyframe+empty_moov+delay_moov+use_metadata_tags+write_colr" "-metadata" "videoai=Enhanced using iris-1 auto with recover details at 0; dehalo at 0; reduce noise at 0; sharpen at 0; revert compression at 0; anti-alias/deblur at 0. Changed resolution to 2560x1440" "C:/Users/lowle/Downloads/gemmabetty1-upres_temp.mp4"

# xbox-xcloud may be renamed as greenlight or greenlight-bin

# locale for australia
# en_AU.UTF-8
# en_AU ISO-8859-1