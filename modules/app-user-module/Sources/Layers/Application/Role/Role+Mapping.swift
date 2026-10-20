//
//  Role.Model+DTOs.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//
//

import UserDomain
import UserModule

extension Role.Model {

    var asDetail: Role.Detail.Output {
        .init(
            id: id,
            key: key,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
