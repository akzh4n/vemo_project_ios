//
//  AuthProcess.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 31.10.2022.
//

import Foundation

enum AuthError {
    case notFilled
    case invalidEmail
    case unknownError
    case passwordNotMatch
    case serverError
    case photoNotExist
}

extension AuthError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .notFilled:
            return NSLocalizedString("Please all fields required", comment: "")
        case .invalidEmail:
            return NSLocalizedString("This email is not valid", comment: "")
        case .passwordNotMatch:
            return NSLocalizedString("The passwords doen`t match!", comment: "")
        case .unknownError:
            /// we will use server_error key to display user internal error
            return NSLocalizedString("server_error", comment: "")
        case .serverError:
            return NSLocalizedString("server_error", comment: "")
            case .photoNotExist:
            return NSLocalizedString("The user not selected picture", comment: "")
        }
    }
}


enum AuthResult {
    case success
    case failure(Error)
}
