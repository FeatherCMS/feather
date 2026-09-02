import BlogContracts
import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

//
//  RemovePost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let ids: [String]

        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            _ = try await scope.metadata.delete(
                referenceType: "blog.post",
                referenceIds: input.ids
            )
            return try await scope.post.delete(ids: input.ids)
        }
    }
}
