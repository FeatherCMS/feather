import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebApplication
import WebDomain

//
//  Author.Edit.UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Author.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Author.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Author.Edit.Scope>
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
                guard var model = try await scope.author.find(id: input.id)
                else {
                    throw Error(message: "Author not found")
                }
                guard
                    var metadata = try await scope.metadata.find(
                        referenceType: "blog.author",
                        referenceId: input.id
                    )
                else {
                    throw Error(message: "Author metadata not found")
                }

                try model.update(
                    name: input.name,
                    excerpt: input.excerpt,
                    content: input.content,
                    profileImageAssetId: input.profileImageAssetId
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

                let savedModel = try await scope.author.update(model)
                let savedMetadata = try await scope.metadata.update(metadata)
                return .init(
                    id: savedModel.id,
                    name: savedModel.name,
                    excerpt: savedModel.excerpt,
                    content: savedModel.content,
                    profileImageAssetId: savedModel.profileImageAssetId,
                    metadata: savedMetadata.asSnapshot,
                    createdAt: savedModel.createdAt,
                    updatedAt: savedModel.updatedAt
                )
            }
        }
    }
}
