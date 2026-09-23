public import FeatherApplication
public import FeatherContracts
import SystemContracts

//
//  GetMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct GetMetadata: UseCase {
    struct Action: PermissionAction {
        let key = SystemPermissions.Admin.access
    }

    let authorizer: any Authorizer
    let query: any QueryExecutor<ReadMetadata>

    public init(
        authorizer: any Authorizer,
        query: any QueryExecutor<ReadMetadata>
    ) {
        self.authorizer = authorizer
        self.query = query
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> MetadataDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await query.run { scope in
            try await scope.metadata.find(id: id)
        }
    }
}
