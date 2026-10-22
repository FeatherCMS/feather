import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebApplication
import WebDomain

//
//  EditPost.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Post.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Post.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Post.Edit.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
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
                return .init(
                    id: savedModel.id,
                    title: savedModel.title,
                    excerpt: savedModel.excerpt,
                    content: savedModel.content,
                    imageAssetId: savedModel.imageAssetId,
                    authorIds: savedModel.authorIds,
                    tagIds: savedModel.tagIds,
                    metadata: savedMetadata.asSnapshot,
                    createdAt: savedModel.createdAt,
                    updatedAt: savedModel.updatedAt
                )
            }
        }
    }
}
