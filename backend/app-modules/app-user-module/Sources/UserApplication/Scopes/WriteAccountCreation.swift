//
//  WriteAccountCreation.swift
//  app-user-module
//

import Application
import UserDomain

public struct WriteAccountCreation: Scope {

    public let account: any AccountRepository
    public let events: any EventDispatcher

    public init(
        account: any AccountRepository,
        events: any EventDispatcher
    ) {
        self.account = account
        self.events = events
    }
}
