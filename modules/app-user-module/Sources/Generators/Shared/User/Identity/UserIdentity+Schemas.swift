//
//  UserIdentity+Schemas.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 02. 12..
//

import FeatherOpenAPI
import FeatherOpenAPIGenerator
import OpenAPIKit30

// MARK: - fields

public struct UserIdentityIDField: StringSchemaRepresentable {
    public var example: String? = "usr_a9x1f7Qk2m"

    public init() {}
}

public struct UserIdentityNameField: StringSchemaRepresentable {
    public var example: String? = "Root User"

    public init() {}
}

public struct UserIdentityStatusField: StringSchemaRepresentable {
    public var allowedValues: [String]? = [
        "invited",
        "active",
        "suspended",
        "deactivated",
        "anonymized",
    ]
    public var example: String? = "active"

    public init() {}
}

public struct UserIdentityRoleIDField: StringSchemaRepresentable {
    public init() {}
}

public struct UserIdentityRoleIDListSchema: ArraySchemaRepresentable {
    public init() {}

    public var items: SchemaRepresentable? {
        UserIdentityRoleIDField()
    }
}

public struct UserIdentityPermissionIDField: StringSchemaRepresentable {
    public init() {}
}

public struct UserIdentityPermissionIDListSchema: ArraySchemaRepresentable {
    public init() {}

    public var items: SchemaRepresentable? {
        UserIdentityPermissionIDField()
    }
}

// MARK: - objects

public struct UserIdentityDetailSchema: ObjectSchemaRepresentable {

    public var propertyMap: SchemaMap {
        [
            "id": UserIdentityIDField().reference(),
            "name": UserIdentityNameField().reference(),
            "status": UserIdentityStatusField().reference(),
            "roleIds": UserIdentityRoleIDListSchema()
                .reference(required: false),
        ]
    }

    public init() {}
}
