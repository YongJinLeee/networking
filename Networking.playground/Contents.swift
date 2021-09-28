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


