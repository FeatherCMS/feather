public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

//
//  Metadata+Add+UseCase.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Metadata.Add {
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

            let reference: Metadata.Model.Reference = .identified(
                .init(type: input.referenceType, id: input.referenceID)
            )

            let model = try await transaction.run { scope in
                try await scope.metadata.insert(
                    Metadata.Model.create(
                        reference: reference,
                        template: input.template,
                        slug: input.slug,
                        publicationDate: input.publicationDate,
                        expirationDate: input.expirationDate,
                        status: input.status,
                        title: input.title,
                        excerpt: input.excerpt,
                        imageURL: input.imageURL,
                        canonicalURL: input.canonicalURL,
                        noIndex: input.noIndex,
                        primaryKeyword: input.primaryKeyword,
                        cssCodeInjection: input.cssCodeInjection,
                        javascriptCodeInjection: input.javascriptCodeInjection,
                        structuredDataCodeInjection: input
                            .structuredDataCodeInjection,
                        templateData: input.templateData
                    )
                )
            }
            return .init(
                id: model.id,
                referenceType: model.reference.type,
                referenceID: model.reference.id ?? "[!!!INVALID!!!]",
                template: model.template,
                slug: model.slug,
                publicationDate: model.publicationDate,
                expirationDate: model.expirationDate,
                status: model.status,
                title: model.title,
                excerpt: model.excerpt,
                imageURL: model.imageURL,
                canonicalURL: model.canonicalURL,
                noIndex: model.noIndex,
                primaryKeyword: model.primaryKeyword,
                cssCodeInjection: model.cssCodeInjection,
                javascriptCodeInjection: model.javascriptCodeInjection,
                structuredDataCodeInjection: model.structuredDataCodeInjection,
                templateData: model.templateData,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
