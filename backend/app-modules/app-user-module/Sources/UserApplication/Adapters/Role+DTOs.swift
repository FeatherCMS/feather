//
//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import UserDomain

extension Role {

    var asDetail: RoleDetail {
        .init(
            id: id,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
