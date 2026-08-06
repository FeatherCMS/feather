//
//  MockEventDispatcher.swift
//  app-user-module
//

import Application
import UserApplication

actor MockEventDispatcher: EventDispatcher {

    private let shouldFail: Bool
    private(set) var dispatchCallCount = 0
    private(set) var accountIDs: [String] = []

    init(
        shouldFail: Bool = false
    ) {
        self.shouldFail = shouldFail
    }

    func dispatch<E: Event>(
        _ event: E
    ) async throws {
        dispatchCallCount += 1
        if shouldFail {
            throw Failure.requested
        }
        if let event = event as? UserAccountDidInsert {
            accountIDs.append(event.accountID)
        }
    }
}

extension MockEventDispatcher {

    fileprivate enum Failure: Error {
        case requested
    }
}
