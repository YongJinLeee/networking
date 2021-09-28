import UIKit

// URL

let urlstring = "https://itunes.apple.com/search?media=music&entity=song&term=Gdragon"
let url = URL(string: urlstring)

//실제 주소
url?.absoluteString
// 어떤 방식으로 네트워킹 중인지? (http, https
url?.scheme
// 제공자 확인
url?.host
// 파일이 불려온 경로(위 url의 경우에는 검색을 통해)
url?.path
// 요청 보낸 쿼리문
url?.query
//
url?.baseURL

// baseURL이 보이지 않는다면 직접 설정 가능

let baseURL = URL(string: "https://itunes.apple.com")
let relativeURL = URL(string: "search?media=music&entity=song&term=Gdragon", relativeTo: baseURL)

relativeURL?.absoluteString
relativeURL?.scheme
relativeURL?.host
relativeURL?.path
relativeURL?.query
relativeURL?.baseURL


