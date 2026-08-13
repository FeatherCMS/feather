//
//  RemoveTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

public struct RemoveTag: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Tags.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteTagPostsMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteTagPostsMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
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
    ) async throws -> Bool {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await transaction.run { scope in
            try await scope.post.removeTag(id: id)
            let removedTag = try await scope.tag.delete(id: id)
            _ = try await scope.metadata.delete(
                reference: .existing(.init(type: "blog.tag", id: id))
            )
            return removedTag
        }
    }
}
