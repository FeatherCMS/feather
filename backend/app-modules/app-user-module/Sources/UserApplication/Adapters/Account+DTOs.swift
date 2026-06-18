//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import UserDomain

extension Account.Status {

    var asAccountStatus: AccountStatus {
        .init(rawValue: rawValue)!
    }
}

extension Account {

    var asDetail: AccountDetail {
        .init(
            id: id,
            email: email,
            status: status.asAccountStatus,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
