//
//  UserAccountDidInsert.swift
//  app-user-module
//

import Application

public struct UserAccountDidInsert: Hook {

    public let accountID: String

    public init(
        accountID: String
    ) {
        self.accountID = accountID
    }
}
