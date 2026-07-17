//
//  RemovePost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import Application
import BlogDomain
import Domain
import WebDomain

public struct RemovePost: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Posts.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePostMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePostMetadata>
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

        return try await transaction.run { context in
            let removedPost = try await context.post.delete(id: id)
            _ = try await context.metadata.delete(
                reference: .init(type: "blog.post", id: id)
            )
            return removedPost
        }
    }
}
