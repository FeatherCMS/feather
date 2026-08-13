//
//  Menu+DTOs.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import WebDomain

extension Menu {

    var asDetail: MenuDetail {
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
