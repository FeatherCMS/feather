//
//  Identity.Model+DTOs.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

public import UserDomain
public import UserModule

extension Identity.Model {

    public var asDetail: Identity.Detail.Output {
        .init(
            id: id,
            name: name,
            status: status,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
