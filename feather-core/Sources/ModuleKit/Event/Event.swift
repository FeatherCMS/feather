//
//  Event.swift
//  feather-core
//

public protocol Event: Sendable {
    associatedtype Output: Sendable = Void
}
