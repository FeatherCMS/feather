//
//  HookRegistryError.swift
//  app-kernel
//

public enum HookRegistryError: Error, Equatable, Sendable {
    case duplicateHandler(hookType: String, handlerID: String)
    case missingRequiredHandler(hookType: String, handlerID: String)
    case invalidHookType(expected: String, actual: String)
}
