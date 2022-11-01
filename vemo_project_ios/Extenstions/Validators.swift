//
//  Validators.swift
//  vemo_project_ios
//
//  Created by Акжан Калиматов on 31.10.2022.
//


import Foundation


class Validators {
    
    static func isFilledReg(username: String?, surename: String?, email: String?, password: String?) -> Bool {
        guard !(username ?? "").isEmpty,
            !(surename ?? "").isEmpty,
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty
                else {
                return false
        }
        return true
    }
    
    static func isFilledEditUser(username: String?, email: String?, password: String?) -> Bool {
        guard !(username ?? "").isEmpty,
            !(email ?? "").isEmpty,
            !(password ?? "").isEmpty
            else {
                return false
        }
        return true
    }
   
    
    static func isSimpleEmail(_ email: String) -> Bool {
        let emailRegEx = "^.+@.+\\..{2,}$"
        return check(text: email, regEx: emailRegEx)
    }
    
    private static func check(text: String, regEx: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regEx)
        return predicate.evaluate(with: text)
    }
}
