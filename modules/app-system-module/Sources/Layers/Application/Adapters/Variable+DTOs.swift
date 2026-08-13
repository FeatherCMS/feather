//
//  Variable+DTOs.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11.
//

import SystemDomain

extension Variable {

    var asDetail: VariableDetail {
        .init(
            id: id,
            value: value,
            name: name,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
