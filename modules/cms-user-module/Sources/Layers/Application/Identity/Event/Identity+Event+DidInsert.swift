public import FeatherModuleKit
public import UserModule

//
//  Identity+Event+DidInsert.swift
//  cms-user-module
//

extension Identity.Event {
    public struct DidInsert: FeatherModuleKit.Event {

        public let identityID: String

        public init(identityID: String) {
            self.identityID = identityID
        }
    }
}
