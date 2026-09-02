import BlogContracts
import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain

//
//  RemoveAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct RemoveAuthorLink: UseCase {
    struct Action: PermissionAction {
        let key = BlogPermissions.AuthorLinks.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuthorLink>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuthorLink>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let ids: [String]
        public let authorId: String

        public init(
            ids: [String],
            authorId: String
        ) {
            self.ids = ids
            self.authorId = authorId
        }
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
            var ids = [String]()
            for id in input.ids {
                guard let model = try await scope.authorLink.find(id: id),
                    model.authorId == input.authorId
                else { continue }
                ids.append(model.id)
            }
            guard !ids.isEmpty else { return [] }
            return try await scope.authorLink.delete(ids: ids)
        }
    }
}
