import BlogDomain
public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

//
//  EditAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension AuthorLink.Edit {
    public struct UseCase: FeatherApplication.UseCase {

        struct Error: UseCaseError {
            let message: String
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<AuthorLink.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<AuthorLink.Edit.Scope>
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
                guard var model = try await scope.authorLink.find(id: input.id)
                else {
                    throw Error(message: "Menu item not found")
                }
                guard model.authorId == input.authorId else {
                    throw Error(message: "Menu item not found")
                }

                try model.update(
                    label: input.label,
                    url: input.url,
                    priority: input.priority,
                    isBlank: input.isBlank,
                    permission: input.permission,
                    notes: input.notes
                )

                return try await scope.authorLink.update(model)
            }
            let detail = model.asDetail
            return .init(
                id: detail.id,
                authorId: detail.authorId,
                label: detail.label,
                url: detail.url,
                priority: detail.priority,
                isBlank: detail.isBlank,
                permission: detail.permission,
                notes: detail.notes,
                createdAt: detail.createdAt,
                updatedAt: detail.updatedAt
            )
        }
    }
}
