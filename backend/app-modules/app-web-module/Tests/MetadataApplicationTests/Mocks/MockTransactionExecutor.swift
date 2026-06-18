//
//  File.swift
//  app-metadata-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import Application
import Domain
import WebDomain

actor MockTransactionExecutor<S: Scope>: TransactionExecutor {

    private(set) var runCallCount = 0
    private let context: S
    private let error: Error?

    init(context: S, error: Error? = nil) {
        self.context = context
        self.error = error
    }

    func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        runCallCount += 1
        if let error {
            throw error
        }
        return try await body(context)
    }
}
