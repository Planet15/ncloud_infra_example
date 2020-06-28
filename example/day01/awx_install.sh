# @martinjuhl "https://awx.wiki/blog/new-build-server-new-installer-new-maintainers-same-project"
#!/bin/bash
iresult=`yum install python36 -y`
checkresult_c='*Complete*'

    if  [[ "$iresult" == $checkresult_c ]]; then
        curl -o /root/awx-setup https://raw.githubusercontent.com/MrMEEE/awx-rpm/master/awx-setup
        chmod +x /root/awx-setup
        yes | /root/awx-setup -i
    fi
