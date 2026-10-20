public import FeatherModuleKit
public import UserModule

//
//  Identity.Event.DidInsert.swift
//  app-user-module
//

extension Identity.Event {
    public struct DidInsert: FeatherModuleKit.Event {

        public let identityID: String

        public init(identityID: String) {
            self.identityID = identityID
        }
    }
}
