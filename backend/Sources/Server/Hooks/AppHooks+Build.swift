//
//  AppHooks+Build.swift
//  backend
//

import AccountInfrastructure
import Infrastructure
import UserApplication

func buildAppHooks() throws -> HookRegistry<AppHookContext> {
    var hooks = HookRegistryBuilder<AppHookContext>()

    try hooks.register(
        UserAccountDidInsert.self,
        id: "account.create-default-settings"
    ) { hook, context in
        try await AccountSettingsHooks.createDefaultSettings(
            accountID: hook.accountID,
            connection: context.connection
        )
    }

    try hooks.require(
        UserAccountDidInsert.self,
        id: "account.create-default-settings"
    )

    return hooks.build()
}
