//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

struct UserAuthSessionTimestampField: DoubleSchemaRepresentable {}

struct UserAuthSessionPersistentField: BoolSchemaRepresentable {}

struct UserAuthSessionAuthenticationTypeField: StringSchemaRepresentable {}

struct UserAuthSessionAuthenticationReferenceField: StringSchemaRepresentable {}

struct UserAuthSessionListItemsField: ArraySchemaRepresentable {
    var items: (any SchemaRepresentable)? {
        UserAuthSessionListItemSchema().reference()
    }
}

struct UserAuthSessionListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserIdentityIDField().reference(),
            "authenticationType": UserAuthSessionAuthenticationTypeField()
                .reference(),
            "authenticationReference":
                UserAuthSessionAuthenticationReferenceField().reference(),
            "expiresAt": UserAuthSessionTimestampField().reference(),
            "isPersistent": UserAuthSessionPersistentField().reference(),
            "createdAt": UserAuthSessionTimestampField().reference(),
            "updatedAt": UserAuthSessionTimestampField().reference(),
        ]
    }
}

struct UserAuthSessionListSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "items": UserAuthSessionListItemsField().reference()
        ]
    }
}
