import BlogContracts
//
//  AddAuthor.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import SystemApplication
import WebApplication
import WebDomain

public struct AddAuthor: UseCase {

    struct Action: PermissionAction {
        let key = BlogPermissions.Authors.create
    }

    struct Error: UseCaseError {
        let message: String
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteAuthorMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteAuthorMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let name: String
        public let excerpt: String
        public let content: String
        public let profileImageAssetId: String?
        public let metadata: PageMetadataInput

        public init(
            name: String,
            excerpt: String,
            content: String,
            profileImageAssetId: String?,
            metadata: PageMetadataInput
        ) {
            self.name = name
            self.excerpt = excerpt
            self.content = content
            self.profileImageAssetId = profileImageAssetId
            self.metadata = metadata
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> AuthorDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { scope in
            let prefix =
                try await scope.variable.get(
                    "blog.author.path_prefix"
                ) ?? "authors"
            return try await scope.author.insert(
                Author.create(
                    name: input.name,
                    excerpt: input.excerpt,
                    content: input.content,
                    profileImageAssetId: input.profileImageAssetId,
                    metadata: input.metadata.asMetadataBase(
                        template: "blog.author",
                        slug: input.metadata.slug.prefixedSlug(with: prefix)
                    )
                )
            )
        }
        return .init(
            id: model.id,
            name: model.name,
            excerpt: model.excerpt,
            content: model.content,
            profileImageAssetId: model.profileImageAssetId,
            metadata: model.metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
