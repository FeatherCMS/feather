//
//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import AuthDomain

extension MagicLink {

    var asDetail: MagicLinkDetail {
        .init(
            id: id,
            email: email,
            token: token,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            isUsed: isUsed,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
