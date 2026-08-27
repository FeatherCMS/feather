//
//  Invitation+DTOs.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AccountDomain

extension Invitation {

    var asDetail: InvitationDetail {
        .init(
            id: id,
            userId: userId,
            email: email,
            token: token,
            roleIDs: roleIDs,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
