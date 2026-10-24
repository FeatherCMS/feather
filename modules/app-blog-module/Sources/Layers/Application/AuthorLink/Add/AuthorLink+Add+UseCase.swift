import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

//
//  AddAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension AuthorLink.Add {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<AuthorLink.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<AuthorLink.Add.Scope>
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
                try await scope.authorLink.insert(
                    AuthorLink.Model.create(
                        authorId: input.authorId,
                        label: input.label,
                        url: input.url,
                        priority: input.priority,
                        isBlank: input.isBlank,
                        permission: input.permission,
                        notes: input.notes
                    )
                )
            }
            return .init(
                id: model.id,
                authorId: model.authorId,
                label: model.label,
                url: model.url,
                priority: model.priority,
                isBlank: model.isBlank,
                permission: model.permission,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }
}
