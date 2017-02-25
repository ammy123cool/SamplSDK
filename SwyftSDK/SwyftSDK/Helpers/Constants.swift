//
//  Constants.swift
//  SwyftSDK
//
//  Created by Amit Dhawan on 24/02/17.
//  Copyright © 2017 Swyft Media. All rights reserved.
//

enum apiError: Error {
    case UnkownError
    case Success
    case NotFound
    case InternalServerError
    case InvalidToken
    
    static func checkErrorCode(_ errorCode: Int) -> apiError {
        switch errorCode {
        case 200:
            return .Success
        case 401:
            return .InvalidToken
        case 404:
            return .NotFound
        case 500:
            return .InvalidToken
        //bla bla bla
        default:
            return .UnkownError
        }
    }
}

