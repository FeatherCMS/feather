//
//  MockAuthorizer.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application

actor MockAuthorizer: Authorizer {
    private(set) var canCallCount = 0
    private let result: Bool

    init(result: Bool) {
        self.result = result
    }

    func can(
        subject: Subject,
        perform action: any Action
    ) async throws -> Bool {
        canCallCount += 1
        return result
    }
}
