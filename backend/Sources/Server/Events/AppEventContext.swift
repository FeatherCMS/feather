//
//  AppEventContext.swift
//  backend
//

import FeatherDatabase

struct AppEventContext: Sendable {
    let connection: any DatabaseConnection
}
