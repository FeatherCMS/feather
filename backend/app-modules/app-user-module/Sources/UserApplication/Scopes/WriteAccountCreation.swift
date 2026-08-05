//
//  WriteAccountCreation.swift
//  app-user-module
//

import Application
import UserDomain

public struct WriteAccountCreation: Scope {

    public let account: any AccountRepository
    public let hooks: any HookDispatcher

    public init(
        account: any AccountRepository,
        hooks: any HookDispatcher
    ) {
        self.account = account
        self.hooks = hooks
    }
}
