import FeatherContracts
//
//  AppEventHandlers+Build.swift
//  application
//

import AccountInfrastructure

func buildAppEventPublisher() -> any EventPublisher {
    var events = EventRegistry()

    AccountInfrastructure.EventHandlers.register(in: &events)

    return events
}
