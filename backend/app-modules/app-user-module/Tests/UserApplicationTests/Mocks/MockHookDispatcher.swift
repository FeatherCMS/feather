//
//  MockHookDispatcher.swift
//  app-user-module
//

import Application
import UserApplication

actor MockHookDispatcher: HookDispatcher {

    private let shouldFail: Bool
    private(set) var dispatchCallCount = 0
    private(set) var accountIDs: [String] = []

    init(
        shouldFail: Bool = false
    ) {
        self.shouldFail = shouldFail
    }

    func dispatch<H: Hook>(
        _ hook: H
    ) async throws {
        dispatchCallCount += 1
        if shouldFail {
            throw Failure.requested
        }
        if let hook = hook as? UserAccountDidInsert {
            accountIDs.append(hook.accountID)
        }
    }
}

extension MockHookDispatcher {

    fileprivate enum Failure: Error {
        case requested
    }
}
