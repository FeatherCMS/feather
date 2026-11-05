import BlogDomain
import FeatherDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebApplication
import WebDomain

//
//  Tag+Edit+UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Tag.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
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
                        slug: .set(metadataInput.slug),
                        publicationDate: input.metadataPublicationDate,
                        expirationDate: .init(
                            value: metadataInput.expirationDate,
                            shouldApply: metadataInput.expirationDate != nil
                        ),
                        status: .set(metadataInput.status),
                        title: .init(
                            value: metadataInput.title,
                            shouldApply: metadataInput.title != nil
                        ),
                        excerpt: .init(
                            value: metadataInput.excerpt,
                            shouldApply: metadataInput.excerpt != nil
                        ),
                        imageURL: .init(
                            value: metadataInput.imageURL,
                            shouldApply: metadataInput.imageURL != nil
                        ),
                        canonicalURL: .init(
                            value: metadataInput.canonicalURL,
                            shouldApply: metadataInput.canonicalURL != nil
                        ),
                        noIndex: .set(metadataInput.noIndex),
                        primaryKeyword: .init(
                            value: metadataInput.primaryKeyword,
                            shouldApply: true
                        ),
                        cssCodeInjection: .init(
                            value: metadataInput.cssCodeInjection,
                            shouldApply: metadataInput.cssCodeInjection != nil
                        ),
                        javascriptCodeInjection: .init(
                            value: metadataInput.javascriptCodeInjection,
                            shouldApply: metadataInput.javascriptCodeInjection
                                != nil
                        ),
                        structuredDataCodeInjection: .init(
                            value: metadataInput.structuredDataCodeInjection,
                            shouldApply: metadataInput
                                .structuredDataCodeInjection != nil
                        )
                    )
                }

                let savedModel = try await scope.tag.update(model)
                let savedMetadata = try await scope.metadata.update(metadata)
                return .init(
                    id: savedModel.id,
                    title: savedModel.title,
                    excerpt: savedModel.excerpt,
                    content: savedModel.content,
                    imageAssetId: savedModel.imageAssetId,
                    metadata: savedMetadata.asSnapshot,
                    createdAt: savedModel.createdAt,
                    updatedAt: savedModel.updatedAt
                )
            }
        }
    }
}
