//
//  AppEventHandlers+Build.swift
//  backend
//

import AccountInfrastructure
import Infrastructure
import UserApplication

func buildAppEventHandlers() throws -> EventHandlerRegistry<AppEventContext> {
    var eventHandlers = EventHandlerRegistryBuilder<AppEventContext>()

    try eventHandlers.register(
        UserAccountDidInsert.self,
        id: "account.create-default-settings"
    ) { event, context in
        try await AccountSettingsEventHandlers.createDefaultSettings(
            accountID: event.accountID,
            connection: context.connection
        )
    }

    try eventHandlers.require(
        UserAccountDidInsert.self,
        id: "account.create-default-settings"
    )

    return eventHandlers.build()
}
