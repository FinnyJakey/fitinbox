## 프로젝트 수행 목적

### (1) 프로젝트 정의

수신한 이메일을 LLM을 통해 개인에게 맞추어 필터링하고 지정된 이메일 주소로 전달해주는 서비스

### (2) 프로젝트 배경

오늘날 이메일은 업무 및 개인 생활에서 핵심적인 의사소통 도구로 사용되고 있다.

그러나 빠르게 증가하는 이메일의 양과 다양한 종류의 메시지들로 인해 혼란스럽고 효율적인 관리가 어려워지고 있다.

따라서 사용자가 중요한 이메일을 빠르게 식별하고 효율적으로 관리할 수 있는 개인화된 서비스를 제공하려고 한다.

### (3) 프로젝트 목표

1. 이메일 서버 구축
    1. AWS의 Simple Email Service를 통해 비교적 간단하고 빠르게 이메일 서버 구축
    2. fitinbox 관련 도메인 구입 및 이메일 서버에 활용
2. AWS Lambda를 이용해 이메일 수신 트리거, 발신 기능 작성
    1. 이메일 수신 트리거 → GPT를 통해 메일 필터링
    2. 발신 기능 → 사용자 주소 지정 이메일 전달
3. Cloud Function을 이용해 OpenAI API 연동 및 프롬프팅
4. FCM을 통해 Push 서비스 제공

## 프로젝트 결과물의 개요

### (1) 프로젝트 구조

![47조_이미지_주요 적용 기술 및 구조.png](https://github.com/user-attachments/assets/f9e583d2-5aeb-4458-8fee-1439016f8544)

### (2) 결과물

![47조_이미지_작품 소개 사진.png](https://github.com/user-attachments/assets/77854cd2-bcf3-4d28-bc6a-1f05c5012107)
