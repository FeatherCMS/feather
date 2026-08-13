//
//  CurrentUserDetail.swift
//  app-auth-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import FeatherApplication
import FeatherContracts
import UserApplication

public struct CurrentUserDetail: DTO {
    public var user: IdentityDetail
    public var roles: [String]
    public var permissions: [String]
}
