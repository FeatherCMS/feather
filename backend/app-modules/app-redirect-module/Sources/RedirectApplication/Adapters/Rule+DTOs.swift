//
//  Rule+DTOs.swift
//  app-redirect-module
//
//  Created by Binary Birds on 2026. 06. 18.

import RedirectDomain

extension Rule {

    var asDetail: RuleDetail {
        .init(
            id: id,
            source: source,
            destination: destination,
            statusCode: statusCode,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
