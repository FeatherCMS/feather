//
//  Event.swift
//  feather-core
//

public protocol Event<Output>: Sendable {
    associatedtype Output: Sendable = Void
}
