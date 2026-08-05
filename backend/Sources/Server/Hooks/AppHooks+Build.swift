//
//  AppHooks+Build.swift
//  backend
//

import AccountInfrastructure
import Infrastructure
import UserEvents

func buildAppHooks() throws -> HookRegistry<AppHookContext> {
    var hooks = HookRegistryBuilder<AppHookContext>()

    try hooks.register(
        UserAccountDidInsert.self,
        id: "account.create-default-settings"
    ) { hook, context in
        try await DatabaseAccountSettingsRepository(
            connection: context.connection
        )
        .create(
            accountID: hook.accountID
        )
    }

    try hooks.require(
        UserAccountDidInsert.self,
        id: "account.create-default-settings"
    )

    return hooks.build()
}
