#!/bin/sh

# /usr/local/etc/ntk.tar.gz file이 없다면 해당 경로로 다운을 받음
if [ ! -f /usr/local/etc/ntk.tar.gz ]; then
   wget http://repo.ncloud.com/etc/vmcheck/ntk.tar.gz  -O /usr/local/etc/ntk.tar.gz  
fi

# /usr/local/etc/ntk.tar.gz 압축을 /usr/local/etc/ 경로로 압축을 해제 한다.
if [ ! -f /usr/local/etc/ntk/core/ntk ]; then
    tar xvzf /usr/local/etc/ntk.tar.gz -C /usr/local/etc/
fi

# 사용 편의성을 위해 /usr/local/etc/ntk/core/ntk 의 실행 파일을 /usr/sbin/ntk으로 옮김.
if [ ! -f /usr/sbin/ntk ]; then
    ln -s /usr/local/etc/ntk/core/ntk /usr/sbin/ntk
fi
