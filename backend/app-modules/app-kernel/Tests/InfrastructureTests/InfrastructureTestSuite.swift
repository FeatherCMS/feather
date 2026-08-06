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
        var builder = EventHandlerRegistryBuilder<String>()
        try builder.register(TestEvent.self, id: "first") { event, context in
            await recorder.append("\(context):\(event.value):first")
        }
        try builder.register(TestEvent.self, id: "second") { event, context in
            await recorder.append("\(context):\(event.value):second")
        }
        try builder.register(OtherEvent.self, id: "other") { _, _ in
            await recorder.append("other")
        }

        try await builder.build()
            .dispatcher(context: "context")
            .dispatch(TestEvent(value: "value"))

        #expect(
            await recorder.values == [
                "context:value:first",
                "context:value:second",
            ]
        )
    }

    @Test
    func rejectsDuplicateHandlerIDsForTheSameEvent() throws {
        var builder = EventHandlerRegistryBuilder<VoidContext>()
        try builder.register(TestEvent.self, id: "duplicate") { _, _ in }

        #expect(
            throws: EventHandlerRegistryError.duplicateHandler(
                eventType: String(reflecting: TestEvent.self),
                handlerID: "duplicate"
            )
        ) {
            try builder.register(TestEvent.self, id: "duplicate") { _, _ in }
        }
    }

    @Test
    func validatesRequiredHandlers() throws {
        let builder = EventHandlerRegistryBuilder<VoidContext>()

        #expect(
            throws: EventHandlerRegistryError.missingRequiredHandler(
                eventType: String(reflecting: TestEvent.self),
                handlerID: "required"
            )
        ) {
            try builder.require(TestEvent.self, id: "required")
        }
    }

    @Test
    func unhandledEventsAreNoOp() async throws {
        let registry = EventHandlerRegistryBuilder<VoidContext>().build()

        try await registry
            .dispatcher(context: .init())
            .dispatch(TestEvent(value: "value"))
    }

    @Test
    func stopsAfterAHandlerThrows() async throws {
        let recorder = Recorder()
        var builder = EventHandlerRegistryBuilder<VoidContext>()
        try builder.register(TestEvent.self, id: "failing") { _, _ in
            await recorder.append("failing")
            throw TestError.failed
        }
        try builder.register(TestEvent.self, id: "later") { _, _ in
            await recorder.append("later")
        }

        await #expect(throws: EventDispatchError.self) {
            try await builder.build()
                .dispatcher(context: .init())
                .dispatch(TestEvent(value: "value"))
        }
        #expect(await recorder.values == ["failing"])
    }
}

extension InfrastructureTestSuite {

    fileprivate struct TestEvent: Event {
        let value: String
    }

    fileprivate struct OtherEvent: Event {}

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
