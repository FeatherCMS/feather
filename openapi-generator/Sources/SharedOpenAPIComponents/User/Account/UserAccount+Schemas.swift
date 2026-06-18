//
//  UserAccount+Schemas.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import OpenAPIKit30

// MARK: - fields

public struct UserAccountIDField: StringSchemaRepresentable {
    public var example: String? = "usr_a9x1f7Qk2m"

    public init() {}
}

public struct UserAccountEmailField: StringSchemaRepresentable {
    public var example: String? = "admin@example.com"

    public init() {}
}

public struct UserAccountPasswordField: StringSchemaRepresentable {
    public var example: String? = "root"

    public init() {}
}

struct UserAccountRoleIDField: StringSchemaRepresentable {}

struct UserAccountRoleIDListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserAccountRoleIDField()
    }
}

struct UserAccountPermissionIDField: StringSchemaRepresentable {}

struct UserAccountPermissionIDListSchema: ArraySchemaRepresentable {
    var items: SchemaRepresentable? {
        UserAccountPermissionIDField()
    }
}

// MARK: - objects

public struct UserAccountDetailSchema: ObjectSchemaRepresentable {

    public var propertyMap: SchemaMap {
        [
            "id": UserAccountIDField().reference(),
            "email": UserAccountEmailField().reference(),
            "roleIds": UserAccountRoleIDListSchema().reference(required: false),
        ]
    }

    public init() {}
}
