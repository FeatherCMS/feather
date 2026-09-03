//
//  Identity+DTOs.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import UserDomain

extension Identity.Status {

    var asIdentityStatus: IdentityStatus {
        .init(rawValue: rawValue)!
    }
}

extension Identity {

    public var asDetail: IdentityDetail {
        .init(
            id: id,
            name: name,
            status: status.asIdentityStatus,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
