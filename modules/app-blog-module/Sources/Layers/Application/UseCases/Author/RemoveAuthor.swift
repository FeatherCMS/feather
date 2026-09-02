import BlogContracts
import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebDomain

//
//  RemoveAuthor.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemoveAuthor: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.Authors.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuthorPostsMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuthorPostsMetadata>
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
            var deletedIds: [String] = []
            for id in input.ids {
                try await scope.post.removeAuthor(id: id)
                _ = try await scope.metadata.delete(
                    reference: .existing(.init(type: "blog.author", id: id))
                )
            }
            deletedIds = try await scope.author.delete(ids: input.ids)
            return deletedIds
        }
    }
}
