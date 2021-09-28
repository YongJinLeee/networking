# networking
iOS app URL handler
fastcampus

-------------
## URL

HTTP (protocol)
REST (API)
JSON (File formet)

HTTP 동작(method)
-POST : 정보 요청
-GET : 정보 취득, 수신
-UPDATE : 정보 변동 체크, 업데이트
-DELETE

HTTP Request를 통해 정보를 요청(POST)
by URL(Uniform Resource Locator)

### Request 구성
두가지로 구성됨
#### Header - 상태코드(응답이 제대로 들어왔는가에 대한 내용) 콘텐츠 타입이 전송됨
##### 콘텐츠 타입
- text/html
- application/json
- image/확장자(png, jpg 등등)
- video/확장자

#### Body - 실제 파일

##### 최근 스트리밍 서비스의 통신 포멧은 HLS(HTTP Live Streaming, 라이브 스트리밍 프로토콜)이 주로 사용됨

------------

## GCD

~~~
GCD provides and manages FIFO queue to which your application can submit task in the form of a block objects. 
Work submitted to dispatch queues are executive on a pool of threads fully managed by the system. 
No guarantee is made as to the thread on which a task executes.
~~~

GCD는 애플리케이션이 블록 객체 형태로 작업을 제출할 수 있는 FIFO 대기열을 제공하고 관리해주는 모듈. 


### Dispatch Queue 종류
#### 1. Main Queue : 메인 쓰레드에서 작동하는 대기열. UI, 사용자 인터페이스등 화면 관련)
~~~Swift
DispatchQueue.main.async
~~~

#### 2. Global Queue : managed by system. 
        - QoS(Quality of Service) class에 의해 시스템에서 수행될 작업(task)의 우선순위를 정하는 concurrent Queue
        - 5가지로 우선순위 표시
          (1) userInterface : 사용자의 인터페이스 입력(touch, typing 등)가장 즉시 수행되어야 하는 작업
          (2) userInitiated : 사용자가 입력,요청 등을 보내고 결과를 기다리는 작업(검색 등)
          (3) defalut
          (4) utility : 수 초 ~ 수 분에 걸쳐 걸리는 작업 (비교적 무거운 작업들 - 파일 불러오기, 전송 등등)
          (5) background : 사용자에게 당장 인식시킬 필요가 없는 작업 ( 다음날 아침의 뉴스 불러오기, 백그라운드 업데이트 등 )
~~~Swift
// Global Queue
DispatchQueue.global(qos: .background).async
~~~
      
#### 3. Custom Queue : 필요에 의해 사용자가 직접 생성하고 사용하는 대기열 종류
        - 용도에 따라 Qos, attributes 직업 설정 가능
         
~~~Swift
//Costom Queue
let concurrentQueue = DispatchQueue(label: "concurrent", qos: .background, attributes: .concurrnt
let serialQueue = DispatchQueue(label: "serial", qos: .background)
~~~

### 두개의 Queue 같이 쓰기 : 두 작업간 상호 의존성이 있을 경우
ex : 이미지를 어디에선가 불러오고(받아오고) / 그 이미지를 화면에 띄우는 작업을 해야할 때 메소드 형태로


~~~Swift
func downloadImageFromServer() -> UIImage {
    //heavy task
    return UIImage()
}
func updateUI(image: UIImage) {
}

DispatchQueue.global(qos: .background).async {
    let image = downloadImageFromServer()
    
    DispatchQueue.main.async {
        // update UI 이므로 메인스레드에서 일어나도록
        updateUI(image: image)
    }
}

~~~

-----------

### sync, Async

> Async

~~~Swift
DispatchQueue.global(qos: .background).async {
    for i in 0...5 {
        print ("😂 웃픔")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("🐈 고앵")
    }
}
~~~

실행 결과 : 

<img width="158" alt="스크린샷 2021-09-29 02 36 25" src="https://user-images.githubusercontent.com/40759743/135137474-7f2c8120-d021-4ae7-be75-4cc26f4edd40.png">

QoS가 userInteractive인 '고앵' 이 대체적으로 먼저 실행됨을 확인


> sync

~~~Swift
DispatchQueue.global(qos: .background).sync {
    for i in 0...5 {
        print ("😂 웃픔")
    }
}

DispatchQueue.global(qos: .userInteractive).async {
    for i in 0...5 {
        print("🐈 고앵")
    }
}
~~~

실행 결과 :

<img width="138" alt="스크린샷 2021-09-29 02 38 40" src="https://user-images.githubusercontent.com/40759743/135137775-8476cdb5-a02d-455f-b7c8-3a70106f9a9c.png">

sync 인 "웃픔"이 전부 실행되고 나서 "고앵" 이 실행됨

-----------

## URLSession 

- URLSessionConfiguration Class 사용-> URLSession 생성 -> URLSessionTask 로 제어 (URL 진행상태를 Delegate 를 통해 확인할 수 있음)

### URLSessionConfiguration Class

Networking
1. Default 
2. Ephemeral : Cookie 또는 Ceche를 저장하지 않는 작업일 경우
3. Background : 컨텐츠 등의 다운로드-업로드 할 때 사용

URLSessionTask - 실제 서버통신 작업 방식 분류
1. URLSesstionDataTask : 기본적 Data 통신 작업. Response data를  메모리에서 처리하도록 함. 단, Background 지원 안됨
2. URLUploadTask / DownloadTask : request body 제공
