public import FeatherApplication
public import FeatherModuleKit
import SystemModule
import WebDomain
public import WebModule

//
//  EditMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Metadata.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Metadata.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Metadata.Edit.Scope>
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
                guard var model = try await scope.metadata.find(id: input.id)
                else {
                    throw Error(message: "Metadata not found")
                }

                try model.update(
                    template: input.template,
                    slug: input.slug,
                    publicationDate: input.publicationDate.flatMap { $0 },
                    expirationDate: input.expirationDate.flatMap { $0 },
                    status: input.status,
                    title: input.title.flatMap { $0 },
                    excerpt: input.excerpt.flatMap { $0 },
                    imageURL: input.imageURL.flatMap { $0 },
                    canonicalURL: input.canonicalURL,
                    noIndex: input.noIndex,
                    primaryKeyword: input.primaryKeyword,
                    cssCodeInjection: input.cssCodeInjection,
                    javascriptCodeInjection: input.javascriptCodeInjection,
                    structuredDataCodeInjection: input
                        .structuredDataCodeInjection
                )

                return try await scope.metadata.update(model)
            }
            return model.asEditOutput
        }
    }
}
