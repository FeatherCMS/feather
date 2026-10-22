public import FeatherApplication
public import FeatherModuleKit
import SystemModule
import WebDomain
public import WebModule

//
//  AddMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Metadata.Add {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Metadata.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Metadata.Add.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Metadata.Detail.Output {
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
                            .structuredDataCodeInjection
                    )
                )
            }
            return model.asDetail
        }
    }
}
