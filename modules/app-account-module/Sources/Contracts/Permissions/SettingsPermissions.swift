//
//  SettingsPermissions.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

import FeatherContracts

public enum SettingsPermissions: PermissionProvider {

    public enum Settings: PermissionProvider {
        public static let read = PermissionKey("account:settings:read")
        public static let update = PermissionKey("account:settings:update")

        public static func allPermissions() -> Set<PermissionKey> {
            [read, update]
        }
    }

    public static func allPermissions() -> Set<PermissionKey> {
        Settings.allPermissions()
    }
}
