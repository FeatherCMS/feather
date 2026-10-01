//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

import AuthSharedOpenAPIGenerator
public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserSharedOpenAPIGenerator

public protocol UserIdentityOperation: BearerProtectedOperation {
}

extension UserIdentityOperation {
    public var tags: [any TagRepresentable] { [UserIdentityTag()] }
}

public protocol UserIdentitySessionOperation: UserIdentityOperation {}

extension UserIdentitySessionOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            UserIdentityIdParameter().reference()
        ]
    }
}

public protocol UserIdentitySessionIdOperation: UserIdentitySessionOperation {}

extension UserIdentitySessionIdOperation {
    public var parameters: [any ParameterRepresentable] {
        [
            UserIdentityIdParameter().reference(),
            UserIdentitySessionIdParameter().reference(),
        ]
    }
}

struct UserIdentitySessionListOperation: UserIdentitySessionOperation {

    var responseMap: ResponseMap {
        [
            200: UserIdentitySessionListResponse().reference(),
            404: CustomResponse(description: "UserIdentity not found"),
        ]
    }
}

struct UserIdentitySessionRemoveOperation: UserIdentitySessionOperation,
    DeleteOperation
{
}
