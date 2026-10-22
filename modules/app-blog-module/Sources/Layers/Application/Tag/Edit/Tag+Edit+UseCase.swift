import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebApplication
import WebDomain

//
//  EditTag.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Tag.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        struct Error: UseCaseError {
            let message: String
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Tag.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Tag.Edit.Scope>
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

            let (model, metadata) = try await transaction.run { scope in
                guard var model = try await scope.tag.find(id: input.id) else {
                    throw Error(message: "Tag not found")
                }
                guard
                    var metadata = try await scope.metadata.find(
                        referenceType: "blog.tag",
                        referenceId: input.id
                    )
                else {
                    throw Error(message: "Tag metadata not found")
                }

                try model.update(
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId
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

                let savedModel = try await scope.tag.update(model)
                let savedMetadata = try await scope.metadata.update(metadata)
                return (savedModel, savedMetadata)
            }
            return .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                metadata: metadata.asDetail,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
