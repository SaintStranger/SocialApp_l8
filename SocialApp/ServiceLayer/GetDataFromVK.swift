//
//  GetDataOperation.swift
//  SocialApp
//
//  Created by test on 21.06.2022.
//


import Foundation
import Alamofire

class GetDataFromVK: GetDataAsync {

    
    var request: DataRequest
    var data: Data?
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    init(request: DataRequest) {
        self.request = request
    }
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            print("Данные из вк получены")
            self?.state = .finished
        }
        
    }

}
