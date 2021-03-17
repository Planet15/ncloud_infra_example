## simplehttpserver
> Creator: changan.song@navercorp.com
> Date: 2021/3/16

## Description
* simplehttpserver는 간단한 http 서버에 대한 코드 입니다.

* compiler.py         : python compiler 코드
* deployment-web.yaml : Naver Cloud Platform의 쿠버네티스서비스와 배포 연동을 위한 yaml 파일
* Dockerfile          : python2 컨테이너 이미지 이며, simplehttpserver를 구동하기 위한 환경 구성
* README.md           : README 파일
* requirements.txt    : 컨테이너 이미지 생성시, pip를 통해서 simplehttpserver를 동작하기 위한
                        요구 사항을 명세한 파일
* webserver.py        : simplehttpserver 코드

## Howto
* 본 예제는 Naver Cloud Platform 에서 제공 하는 
*  Kubernetes Service + SourceCommit + SourceBuild + SourceDeploy + SourcePipeline + Container Registry
*  와 연동 되는 예제 입니다.
*  SourceCommit는 private SSH 키를 통해 git push 를 하게 되며,
*  https://docs.ncloud.com/ko/devtools/devtools-2-1.html 에서 SSH 접속용 자격증명 발급 (KEY-Pair)을 참조 합니다.
*  Kubernetes Service 와 Container Registry 연동에서는 private Container Registry 이므로 API 키를 통해 인증이 진행됩니다.
*  kubectl create secret docker-registry regcred --docker-server=jwqth0r4.kr.private-ncr.ntruss.com --docker-username=AccessKeyID --docker-password=Secret Key --docker-email=example@navercorp.com 
*  AccessKeyID/Secret Key는 마이페이지>인증키관리에서 확인이 가능하며, 없는 경우 신규 API 인증키 생성을 하시면 됩니다.
*  전체 코드들은 각자의 SourceCommit 에git push를 하여 사용 하면 되며,
*  deployment-web.yaml 는 continer image의 endpoint를 구성하신 Container Registry 의endpoint를 구성하셔야 합니다.
*  Dockerfile는 사용하시는 APP 마다 다르게 구성이 필요하며, 현재의 예제에서는 python2 기반으로 구성 하였습니다.  

