//
//  IdentityStatus.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public enum IdentityStatus: String, Sendable, CaseIterable {
    case invited
    case active
    case suspended
    case deactivated
    case anonymized
}
