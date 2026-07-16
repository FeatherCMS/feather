//
//  MenuItem+DTOs.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import WebDomain

extension MenuItem {

    var asDetail: MenuItemDetail {
        .init(
            id: id,
            menuId: menuId,
            label: label,
            url: url,
            priority: priority,
            isBlank: isBlank,
            permission: permission,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
