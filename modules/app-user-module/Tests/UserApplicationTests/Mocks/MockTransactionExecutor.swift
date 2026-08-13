//
//  MockTransactionExecutor.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts

actor MockTransactionExecutor<S: Scope>: ContextualTransactionExecutor {
    private(set) var runCallCount = 0
    private let context: S

    init(context: S) {
        self.context = context
    }

    func run<T: Sendable>(
        _ body: @Sendable (S) async throws -> T
    ) async throws -> T {
        runCallCount += 1
        return try await body(context)
    }

    func run<T: Sendable>(
        _ body:
            @Sendable (
                S,
                any TransactionContext
            ) async throws -> T
    ) async throws -> T {
        runCallCount += 1
        return try await body(
            context,
            MockTransactionContext()
        )
    }
}
