//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

import FeatherOpenAPI
import OpenAPIKit30
import SharedOpenAPIComponents

struct UserAuthSessionTimestampField: DoubleSchemaRepresentable {}

struct UserAuthSessionPersistentField: BoolSchemaRepresentable {}

struct UserAuthSessionListItemsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserAuthSessionListItemSchema().reference()
    }
}

struct UserAccountListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserAccountIDField().reference(),
            "email": UserAccountEmailField().reference(),
        ]
    }
}

struct UserAccountListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserAccountListItemSchema().reference()
    }
}

struct UserAccountRoleIdsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserRoleIdField().reference()
    }
}

struct UserAccountDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserAccountIDField().reference(),
            "email": UserAccountEmailField().reference(),
            "roleIds": UserAccountRoleIdsField().reference(),
        ]
    }
}

struct UserAccountCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserAccountEmailField().reference(),
            "password": UserAccountPasswordField().reference(),
        ]
    }
}

struct UserAccountUpdateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserAccountEmailField().reference(),
            "password": UserAccountPasswordField().reference(),
            "roleIds": UserAccountRoleIdsField().reference(required: false),
        ]
    }
}

struct UserAccountPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "email": UserAccountEmailField().reference(required: false),
            "password": UserAccountPasswordField().reference(required: false),
            "roleIds": UserAccountRoleIdsField().reference(required: false),
        ]
    }
}

struct UserAuthSessionListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserAuthSessionIDField().reference(),
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
