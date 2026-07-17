//
//  Invitation+DTOs.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import UserDomain

extension Invitation {

    var asDetail: InvitationDetail {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
