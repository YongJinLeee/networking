import UIKit
import Foundation
import GLKit


// queue - Main, Global, Custom

//Main Queue
DispatchQueue.main.async {
    //  ex: UI 업데이트
    let view = UIView()
    view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
}

// Global - QoS(userInteractive,userIntitiated, default, utility,
DispatchQueue.global(qos: .userInteractive).async {
    // 지금 당장 실행되어야 하는
}
DispatchQueue.global(qos: .userInitiated).async {
    // 유저가 값을 기다리고 있는
}

// default
DispatchQueue.global(qos: .default).async {
    DispatchQueue.global().async {
        //디폴트는 QoS지정 없어도 가능
    }
}

DispatchQueue.global(qos: .utility).async {
    // 시간이 좀 걸리는 작업들. 사용자가 당장 기다리지 않는 것.
    // 네트워킹, 크기가 큰 파일 불러오기 등
}

DispatchQueue.global(qos: .background).async {
    // 사용자에게 지금 당장 인식 시키지 않아도 되는 것들.
    // 뉴스 데이터 미리 업데이트, 위치 업데이트
}


//Custom Queue - 실무 사용빈도는 낮음
let concurrentQueue = DispatchQueue(label: "concurent", qos: .background, attributes: .concurrent)
let serialQueue = DispatchQueue(label: "serial", qos: .userInteractive)

// sync, Async 복합적인 상황
// 예제코드 >>
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

// sync, Async
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

// -> 두번째 큐가 훨씬 더 먼저 나오는 경향을 보임
