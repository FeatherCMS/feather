//
//  WebInfrastructureTestSuite.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherContracts
import SystemApplication
import Testing

@testable import WebInfrastructure

@Suite
struct WebInfrastructureTestSuite {

    @Test
    func moduleIsReadyForInfrastructureFeatures() {
        _ = MetadataDatabaseRepository.self
    }

    @Test
    func variableSeedUsesRegisteredPublicBaseURL() async throws {
        let publicBaseURL = "https://example.com"
        var events = EventRegistry()
        EventHandlers.register(
            in: &events,
            publicBaseURL: publicBaseURL
        )

        let variables =
            try await events.trigger(
                event: VariableSeedProvider(),
                using: EventContext()
            )
            .flatMap { $0 }

        #expect(
            variables.first(where: {
                $0.key == "web-settings-public-base-url"
            })?
            .value == publicBaseURL
        )
    }
}
