//
//
//  File.swift
//  app-user-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import AuthDomain

extension Session {

    var asDetail: SessionDetail {
        .init(
            id: id,
            token: token,
            accountId: accountId,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }

    var asListItem: SessionList.Item {
        .init(
            id: id,
            token: token,
            accountId: accountId,
            expiresAt: expiresAt,
            isPersistent: isPersistent,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
