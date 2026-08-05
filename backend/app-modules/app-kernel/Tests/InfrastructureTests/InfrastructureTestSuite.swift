//
//  InfrastructureTestSuite.swift
//  app-kernel
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import Testing

@testable import Infrastructure

@Suite
struct InfrastructureTestSuite {

    @Test
    func dispatchesMatchingHandlersInRegistrationOrder() async throws {
        let recorder = Recorder()
        var builder = HookRegistryBuilder<String>()
        try builder.register(TestHook.self, id: "first") { hook, context in
            await recorder.append("\(context):\(hook.value):first")
        }
        try builder.register(TestHook.self, id: "second") { hook, context in
            await recorder.append("\(context):\(hook.value):second")
        }
        try builder.register(OtherHook.self, id: "other") { _, _ in
            await recorder.append("other")
        }

        try await builder.build()
            .dispatcher(context: "context")
            .dispatch(TestHook(value: "value"))

        #expect(
            await recorder.values == [
                "context:value:first",
                "context:value:second",
            ]
        )
    }

    @Test
    func rejectsDuplicateHandlerIDsForTheSameHook() throws {
        var builder = HookRegistryBuilder<VoidContext>()
        try builder.register(TestHook.self, id: "duplicate") { _, _ in }

        #expect(throws: HookRegistryError.self) {
            try builder.register(TestHook.self, id: "duplicate") { _, _ in }
        }
    }

    @Test
    func validatesRequiredHandlers() throws {
        let builder = HookRegistryBuilder<VoidContext>()

        #expect(throws: HookRegistryError.self) {
            try builder.require(TestHook.self, id: "required")
        }
    }

    @Test
    func unhandledHooksAreNoOp() async throws {
        let registry = HookRegistryBuilder<VoidContext>().build()

        try await registry
            .dispatcher(context: .init())
            .dispatch(TestHook(value: "value"))
    }

    @Test
    func stopsAfterAHandlerThrows() async throws {
        let recorder = Recorder()
        var builder = HookRegistryBuilder<VoidContext>()
        try builder.register(TestHook.self, id: "failing") { _, _ in
            await recorder.append("failing")
            throw TestError.failed
        }
        try builder.register(TestHook.self, id: "later") { _, _ in
            await recorder.append("later")
        }

        await #expect(throws: HookDispatchError.self) {
            try await builder.build()
                .dispatcher(context: .init())
                .dispatch(TestHook(value: "value"))
        }
        #expect(await recorder.values == ["failing"])
    }
}

extension InfrastructureTestSuite {

    fileprivate struct TestHook: Hook {
        let value: String
    }

    fileprivate struct OtherHook: Hook {}

    fileprivate struct VoidContext: Sendable {}

    fileprivate enum TestError: Error {
        case failed
    }

    fileprivate actor Recorder {
        private(set) var values: [String] = []

        func append(
            _ value: String
        ) {
            values.append(value)
        }
    }
}
