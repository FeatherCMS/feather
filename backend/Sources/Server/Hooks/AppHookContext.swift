//
//  AppHookContext.swift
//  backend
//

import FeatherDatabase

struct AppHookContext: Sendable {
    let connection: any DatabaseConnection
}
