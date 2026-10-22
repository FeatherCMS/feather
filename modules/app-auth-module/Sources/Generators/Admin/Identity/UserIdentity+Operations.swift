//
//  File.swift
//  openapi-generator
//
//  Created by Tibor Bödecs on 2026. 03. 24..
//

public import FeatherOpenAPI
public import FeatherOpenAPIGenerator
import OpenAPIKit30
import UserOpenAPIGeneratorSupport

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

struct UserIdentitySessionListOperation: UserIdentitySessionOperation {
    var operationId: String? { "userIdentitySessionList" }

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
    var operationId: String? { "userIdentitySessionRemove" }
}
