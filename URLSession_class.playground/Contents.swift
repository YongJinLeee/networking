import UIKit

// URLSesstion

// 1. URLSesstionConfiguration
// 2. URLSession
// 3. URLSessionTask

// URLSessionTask
/*
 - dataTask
 - uploadTask
 - downloadTask
*/

// configuration으로 session을 만들고
let config = URLSessionConfiguration.default
let session = URLSession(configuration: config)

//메소드를 호출해 session이 할 일을 지정한다.
//let dataTask = session.dataTask(with: <#T##URLRequest#>)
// 네트워킹 할 URL을 파라미터로 받아 요청 후. 후행작업을 comprehend handler에서 처리

// let urlstring = "https://itunes.apple.com/search?media=music&entity=song&term=Gdragon"

var urlcomponents = URLComponents(string: "https://itunes.apple.com/search?")!
let mediaQuery = URLQueryItem(name: "media", value: "music")
let entityQuery = URLQueryItem(name: "entity", value: "song")
let termQuery = URLQueryItem(name: "term", value: "지드래곤")

urlcomponents.queryItems?.append(mediaQuery)
urlcomponents.queryItems?.append(entityQuery)
urlcomponents.queryItems?.append(termQuery)
let requestURL = urlcomponents.url!

let dataTask = session.dataTask(with: requestURL) { (data, response, error) in
    
    guard error == nil else { return }
    
    //error 가 없을 경우에 다음 task 실행하도록 설계
    
    // status Code 확인하기, HTTPURLResponse로 다운캐스팅, status code 가져오기
    guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
    // 성공여부 바운더리 설정 == 2XX 인 경우만 성공 -> (300~ Redirection, 404~ client errors, 501~ server errors 등..실패 메시지)
    let successRange = 200..<300
    
    guard successRange.contains(statusCode) else {
        // 아니면 handler response error
        return
    }
    
    guard let resultData =  data else { return }
    let resultString = String(data: resultData, encoding: .utf8)
    
    
    print("----> result :  \(resultData)")
    print("----> statusCode : \(statusCode)")
//    print("---> result String : \(resultString)")
    
}

dataTask.resume()
