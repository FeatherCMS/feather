import FeatherModuleKit
//
//  AppEventHandlers+Build.swift
//  application
//

import AccountInfrastructure

func buildAppEventPublisher() -> any EventPublisher {
    var events = EventRegistry()

    AccountModule.Event.Handlers.register(in: &events)

    return events
}
