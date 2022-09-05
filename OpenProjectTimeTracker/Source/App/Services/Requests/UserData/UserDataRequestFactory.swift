//
//  UserRequestFactory.swift
//  OpenProjectTimeTracker
//
//  Created by Denis Shtangey on 15.08.22.
//

import Foundation

protocol UserDataRequestFactoryProtocol {
    
    func createUserDataRequestConfig() -> RequestConfig<UserDataParser>
}

final class UserDataRequestFactory: UserDataRequestFactoryProtocol {
    
    func createUserDataRequestConfig() -> RequestConfig<UserDataParser> {
        let request = UserDataRequest()
        let parser = UserDataParser()
        return RequestConfig(request: request, parser: parser)
    }
}
