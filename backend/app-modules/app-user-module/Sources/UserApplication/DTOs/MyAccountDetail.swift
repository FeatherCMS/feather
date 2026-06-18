//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import Application

public struct MyAccountDetail: DTO {
    public var user: AccountDetail
    public var roles: [String]
    public var permissions: [String]
}
