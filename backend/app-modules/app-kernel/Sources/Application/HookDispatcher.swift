//
//  HookDispatcher.swift
//  app-kernel
//

public protocol HookDispatcher: Sendable {

    func dispatch<H: Hook>(
        _ hook: H
    ) async throws
}
