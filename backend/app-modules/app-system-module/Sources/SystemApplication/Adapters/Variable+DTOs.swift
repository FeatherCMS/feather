//
//  File.swift
//  app-system-module
//
//  Created by Tibor Bödecs on 2026. 04. 11..
//

import SystemDomain

extension Variable {

    var asDetail: VariableDetail {
        .init(
            id: id,
            name: name,
            value: value,
            notes: notes,
            createdAt: createdAt,
            updatedAt: updatedAt
        )
    }
}
