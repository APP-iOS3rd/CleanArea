//
//  APIModelView.swift
//  CleanArea
//
//  Created by 김지훈 on 2023/12/06.
//

import SwiftUI

import SwiftUI

class APIViewModel: ObservableObject {
    @Published var result: [YouthPolicy]?
    @Published var policy: Policy?

    //query: 정책명,정책소개 정보검색, bizTycdSel: 정책분야, srchPolyBizSecd: 주거지 ,keyword: 키워드
    func search(vm: StartVM) {

        let residence = vm.residence?.rawValue ?? ""
        let employmentStatus = vm.employmentStatus
        let educationLevel = vm.educationLevel
        let age = vm.age
        let policyName = vm.policyName
        
        print(residence)
        print(employmentStatus)
        print(educationLevel)
        print(age)
        print(policyName)
        
        var urlComponents = URLComponents(string: "http://120.50.73.116:3000/youth-policies")
        urlComponents?.queryItems = [
            URLQueryItem(name: "residence", value: residence),
            URLQueryItem(name: "employmentStatus", value: employmentStatus),
            URLQueryItem(name: "educationLevel", value: educationLevel),
            URLQueryItem(name: "age", value: age),
            URLQueryItem(name: "policyName", value: policyName)
        ]
        
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return
        }
            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    print("Error with fetching data: \(error)")
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode),
                      let data = data else {
                    print("Error with the response, unexpected status code: \(String(describing: response))")
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    // 여기서 YouthPolicy 배열로 디코드하도록 수정
                    let policies = try decoder.decode([YouthPolicy].self, from: data)
                    DispatchQueue.main.async {
                        // SwiftUI 뷰를 업데이트하는 코드
                        print(policies)
                        self.result = policies
                        let policy = Policy()
                        policy.getPolicy(policies)
                        self.policy = policy
                    }
                } catch {
                    print("JSON Decoding Error: \(error)")
                }
            }

            task.resume()
//        }
    }
}
