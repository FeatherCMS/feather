import FeatherContracts

//
//  UserIdentityDidInsert.swift
//  app-user-module
//

public struct UserIdentityDidInsert: Event {

    public let identityID: String

    public init(
        identityID: String
    ) {
        self.identityID = identityID
    }
}
