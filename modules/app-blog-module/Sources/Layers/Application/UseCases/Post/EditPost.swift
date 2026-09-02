import BlogContracts
import BlogDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebApplication
import WebDomain

//
//  EditPost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public struct EditPost: UseCase {

    struct Action: PermissionAction {
        let key = BlogPermissions.Posts.update
    }

    struct Error: UseCaseError {
        let message: String
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
        public let title: String?
        public let excerpt: String?
        public let content: String?
        public let imageAssetId: String??
        public let authorIds: [String]?
        public let tagIds: [String]?
        public let metadata: PageMetadataInput?

        public init(
            id: String,
            title: String?,
            excerpt: String?,
            content: String?,
            imageAssetId: String??,
            authorIds: [String]?,
            tagIds: [String]?,
            metadata: PageMetadataInput?
        ) {
            self.id = id
            self.title = title
            self.excerpt = excerpt
            self.content = content
            self.imageAssetId = imageAssetId
            self.authorIds = authorIds
            self.tagIds = tagIds
            self.metadata = metadata
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> PostDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let (model, metadata) = try await transaction.run { scope in
            guard var model = try await scope.post.find(id: input.id) else {
                throw Error(message: "Post not found")
            }
            guard
                var metadata = try await scope.metadata.find(
                    referenceType: "blog.post",
                    referenceId: input.id
                )
            else {
                throw Error(message: "Post metadata not found")
            }

            try model.update(
                title: input.title,
                excerpt: input.excerpt,
                content: input.content,
                imageAssetId: input.imageAssetId,
                authorIds: input.authorIds,
                tagIds: input.tagIds
            )
            if let metadataInput = input.metadata {
                try metadata.update(
                    slug: metadataInput.slug,
                    publicationDate: metadataInput.publicationDate,
                    expirationDate: metadataInput.expirationDate,
                    status: metadataInput.status,
                    title: metadataInput.title,
                    excerpt: metadataInput.excerpt,
                    imageURL: metadataInput.imageURL,
                    canonicalURL: metadataInput.canonicalURL,
                    noIndex: metadataInput.noIndex,
                    primaryKeyword: metadataInput.primaryKeyword,
                    cssCodeInjection: metadataInput.cssCodeInjection,
                    javascriptCodeInjection: metadataInput
                        .javascriptCodeInjection,
                    structuredDataCodeInjection: metadataInput
                        .structuredDataCodeInjection
                )
            }

            let savedModel = try await scope.post.update(model)
            let savedMetadata = try await scope.metadata.update(metadata)
            return (savedModel, savedMetadata)
        }
        return .init(
            id: model.id,
            title: model.title,
            excerpt: model.excerpt,
            content: model.content,
            imageAssetId: model.imageAssetId,
            authorIds: model.authorIds,
            tagIds: model.tagIds,
            metadata: metadata.asDetail,
            createdAt: model.createdAt,
            updatedAt: model.updatedAt
        )
    }
}
