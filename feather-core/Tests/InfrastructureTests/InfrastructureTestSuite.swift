//
//  InfrastructureTestSuite.swift
//  feather-core
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import Testing

@testable import FeatherInfrastructure

@Suite
struct InfrastructureTestSuite {

    @Test
    func collectsTypedResultsInRegistrationOrder() async throws {
        var events = EventRegistry()

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):first"
        }

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):second"
        }

        var options = EventTriggerOptions()
        options[.invocationPolicy] = .all
        let results = try await events.trigger(
            event: TestEvent(value: "value"),
            using: TestContext(prefix: "context"),
            options: options
        )

        #expect(
            results == [
                "context:value:first",
                "context:value:second",
            ]
        )
    }

    @Test
    func triggerFirstStopsAfterFirstCompatibleHandler() async throws {
        let recorder = Recorder()
        var events = EventRegistry()

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):first"
        }

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { _, _ in
            await recorder.increment()
            return "second"
        }

        var options = EventTriggerOptions()
        options[.invocationPolicy] = .first
        let results = try await events.trigger(
            event: TestEvent(value: "value"),
            using: TestContext(prefix: "context"),
            options: options
        )

        #expect(results == ["context:value:first"])
        #expect(await recorder.callCount == 0)
    }

    @Test
    func triggerDiscardsVoidResults() async throws {
        let recorder = Recorder()
        var events = EventRegistry()

        events.register(
            event: VoidEvent.self,
            context: TestContext.self
        ) { _, _ in
            await recorder.increment()
        }

        try await events
            .trigger(
                event: VoidEvent(),
                using: TestContext(prefix: "context")
            )

        #expect(await recorder.callCount == 1)
    }

    @Test
    func triggerStopsAtIncompatibleContext() async {
        var events = EventRegistry()

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):transaction"
        }

        events.register(
            event: TestEvent.self,
            context: OtherContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):query"
        }

        await #expect(throws: EventError.self) {
            _ = try await events.trigger(
                event: TestEvent(value: "value"),
                using: TestContext(prefix: "context")
            )
        }
    }

    @Test
    func triggerSkipsIncompatibleContexts() async throws {
        var events = EventRegistry()

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):first"
        }

        events.register(
            event: TestEvent.self,
            context: OtherContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):incompatible"
        }

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { event, context in
            "\(context.prefix):\(event.value):last"
        }

        var options = EventTriggerOptions()
        options[.contextPolicy] = .skipIncompatible
        let results = try await events.trigger(
            event: TestEvent(value: "value"),
            using: TestContext(prefix: "context"),
            options: options
        )

        #expect(
            results == [
                "context:value:first",
                "context:value:last",
            ]
        )
    }

    @Test
    func triggerReturnsEmptyResultsForUnregisteredEvent() async throws {
        let events = EventRegistry()

        let results = try await events.trigger(
            event: UnregisteredEvent(),
            using: TestContext(prefix: "context")
        )

        #expect(results.isEmpty)
    }

    @Test
    func triggerWrapsHandlerFailure() async {
        var events = EventRegistry()

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { _, _ in
            throw TestFailure.expected
        }

        do {
            _ = try await events.trigger(
                event: TestEvent(value: "value"),
                using: TestContext(prefix: "context")
            )
            Issue.record("Expected the handler failure to be thrown")
        }
        catch let error as EventError {
            guard case .failure(let eventType, let underlyingError) = error
            else {
                Issue.record("Expected EventError.failure")
                return
            }

            #expect(eventType == String(reflecting: TestEvent.self))
            #expect(underlyingError is TestFailure)
        }
        catch {
            Issue.record("Expected EventError, received \(error)")
        }
    }

    @Test
    func triggerStopsAfterHandlerFailure() async {
        let recorder = Recorder()
        var events = EventRegistry()

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { _, _ in
            throw TestFailure.expected
        }

        events.register(
            event: TestEvent.self,
            context: TestContext.self
        ) { _, _ in
            await recorder.increment()
            return "second"
        }

        _ = try? await events.trigger(
            event: TestEvent(value: "value"),
            using: TestContext(prefix: "context")
        )

        #expect(await recorder.callCount == 0)
    }

    @Test
    func handlerRejectsInvalidEventType() async {
        let handler = AnyEventHandler(
            event: TestEvent.self
        ) {
            (
                event: TestEvent,
                context: TestContext
            ) in
            "\(context.prefix):\(event.value)"
        }

        await #expect(throws: EventError.self) {
            _ = try await handler.trigger(
                UnregisteredEvent(),
                TestContext(prefix: "context")
            )
        }
    }

}

extension InfrastructureTestSuite {

    private struct TestContext: TransactionContext {
        let prefix: String
    }

    private struct OtherContext: QueryContext {
        let prefix: String
    }

    private struct TestEvent: Event {
        typealias Output = String

        let value: String
    }

    private struct VoidEvent: Event {}

    private struct UnregisteredEvent: Event {
        typealias Output = String
    }

    private enum TestFailure: Error {
        case expected
    }

    private actor Recorder {
        private(set) var callCount = 0

        func increment() {
            callCount += 1
        }
    }

}
