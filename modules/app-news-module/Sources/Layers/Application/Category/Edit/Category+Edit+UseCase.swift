public import FeatherApplication
import FeatherDomain
public import FeatherModuleKit
import NewsDomain
public import NewsModule
import WebApplication
import WebDomain
import WebModule

//
//  Category+Edit+UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Category.Edit {
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

            let model = try await transaction.run { scope in
                guard var model = try await scope.category.find(id: input.id)
                else {
                    throw Error(message: "Category not found")
                }
                try model.update(
                    title: input.title,
                    excerpt: input.excerpt,
                    content: input.content,
                    imageAssetId: input.imageAssetId
                )
                switch input.metadata {
                case .unchanged:
                    break
                case .set(let metadata):
                    try model.metadata.update(
                        template: .set(metadata.template),
                        slug: .set(metadata.slug),
                        publicationDate: input.metadataPublicationDate,
                        expirationDate: .init(
                            value: metadata.expirationDate,
                            shouldApply: metadata.expirationDate != nil
                        ),
                        status: .set(metadata.status),
                        title: .init(
                            value: metadata.title,
                            shouldApply: metadata.title != nil
                        ),
                        excerpt: .init(
                            value: metadata.excerpt,
                            shouldApply: metadata.excerpt != nil
                        ),
                        imageURL: .init(
                            value: metadata.imageURL,
                            shouldApply: metadata.imageURL != nil
                        ),
                        canonicalURL: .init(
                            value: metadata.canonicalURL,
                            shouldApply: metadata.canonicalURL != nil
                        ),
                        noIndex: .set(metadata.noIndex),
                        primaryKeyword: .init(
                            value: metadata.primaryKeyword,
                            shouldApply: true
                        ),
                        cssCodeInjection: .init(
                            value: metadata.cssCodeInjection,
                            shouldApply: metadata.cssCodeInjection != nil
                        ),
                        javascriptCodeInjection: .init(
                            value: metadata.javascriptCodeInjection,
                            shouldApply: metadata.javascriptCodeInjection != nil
                        ),
                        structuredDataCodeInjection: .init(
                            value: metadata.structuredDataCodeInjection,
                            shouldApply: metadata.structuredDataCodeInjection
                                != nil
                        )
                    )
                }

                return try await scope.category.update(model)
            }
            return .init(
                id: model.id,
                title: model.title,
                excerpt: model.excerpt,
                content: model.content,
                imageAssetId: model.imageAssetId,
                metadata: model.metadata.asSnapshot,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
