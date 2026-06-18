//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 23..
//

import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct AuthRegisterSchema: ObjectSchemaRepresentable {

    var propertyMap: SchemaMap {
        [
            "email": UserAccountEmailField().reference(),
            "password": UserAccountPasswordField().reference(),
        ]
    }
}
