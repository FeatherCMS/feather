import FeatherContracts
//
//  AppEventHandlers+Build.swift
//  application
//

import AccountInfrastructure
import FeatherApplication
import FeatherInfrastructure
import FeatherDomain

func buildAppEventPublisher() -> any EventPublisher {
    var events = EventRegistry()

    AccountInfrastructure.EventHandlers.register(in: &events)

    return events
}
