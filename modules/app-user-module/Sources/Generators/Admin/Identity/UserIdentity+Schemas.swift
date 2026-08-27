//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

struct UserIdentityListItemSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserIdentityIDField().reference(),
            "status": UserIdentityStatusField().reference(),
            "roles": UserIdentityRoleIDListSchema().reference(),
        ]
    }
}

struct UserIdentityListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserIdentityListItemSchema().reference()
    }
}

struct UserIdentityRoleIdsField: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserRoleIdField().reference()
    }
}

struct UserIdentityDetailSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "id": UserIdentityIDField().reference(),
            "status": UserIdentityStatusField().reference(),
            "roleIds": UserIdentityRoleIdsField().reference(),
        ]
    }
}

struct UserIdentityCreateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "status": UserIdentityStatusField().reference(required: false)
        ]
    }
}

struct UserIdentityUpdateSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "status": UserIdentityStatusField().reference(required: false),
            "roleIds": UserIdentityRoleIdsField().reference(required: false),
        ]
    }
}

struct UserIdentityPatchSchema: ObjectSchemaRepresentable {
    var propertyMap: SchemaMap {
        [
            "status": UserIdentityStatusField().reference(required: false),
            "roleIds": UserIdentityRoleIdsField().reference(required: false),
        ]
    }
}
