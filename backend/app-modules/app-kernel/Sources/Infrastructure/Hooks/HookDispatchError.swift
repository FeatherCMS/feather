//
//  HookDispatchError.swift
//  app-kernel
//

public struct HookDispatchError: Error {

    public let hookType: String
    public let handlerID: String
    public let underlyingError: any Error

    public init(
        hookType: String,
        handlerID: String,
        underlyingError: any Error
    ) {
        self.hookType = hookType
        self.handlerID = handlerID
        self.underlyingError = underlyingError
    }
}
