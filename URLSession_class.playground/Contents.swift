import UIKit
import Foundation
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

// data 받을 struct 구현

struct Response: Codable {
    let resultCount: Int
    let tracks: [Track]
    
    enum CodingKeys: String, CodingKey {
        case tracks = "results"
        case resultCount
    }
}

struct Track: Codable {
    let title: String
    let artistName: String
    let thumbnailPath: String
    // 썸네일 이미지가 있는 곳에 가서 받아와야하기 때문에 주소로 적음

    enum CodingKeys: String, CodingKey {
        case title = "trackName"
        case artistName
        case thumbnailPath = "artworkUrl30"
    }
}



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
    
    
    // 받아온 데이터로 필요한 오브젝트로 구성
    // 1. data -> Track 목록으로 가져오기 : [Track]
    // 2. Track object 생성
    // 3. response된 data 형태에서 struct로 파싱 -> Codable 사용
    //  - Json 파일, 데이터 -> 오브젝트로 구성할 때 codable로 파싱
    // 4. 검색 결과(results)로 들고 있는 내용들을 재구성
    //  - Response ( [Track] ) 의 형태로 오브젝트

    // 구체적 시행
    // -> response와 Track의 Struct 생성
    // -> struct의 프로퍼티 이름과 실제 데이터의 키 이름 맞추기 (for decoding)
    // -> 파싱(Decoding)
    // -> 트랙리스트 가져오기 완료

    // - codable 파싱
    // try do catch
    do {
        let decoder = JSONDecoder()
        let response = try decoder.decode(Response.self, from: resultData)
        
        let tracks = response.tracks
        
        print("Track Count: \(tracks.count)개 ")
    } catch let error { // 예외처리
        print("error: \(error.localizedDescription)")
    }

    print("----> result :  \(resultData)")
    print("----> statusCode : \(statusCode)")
//    print("---> result String : \(resultString)")
    
}

dataTask.resume()
