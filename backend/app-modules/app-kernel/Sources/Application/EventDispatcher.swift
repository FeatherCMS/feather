//
//  EventDispatcher.swift
//  app-kernel
//

public protocol EventDispatcher: Sendable {

    func dispatch<E: Event>(
        _ event: E
    ) async throws
}
