public import FeatherApplication
public import FeatherModuleKit
import UserDomain
public import UserModule

//
//  Role+Edit+UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Role.Edit {
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
                guard var model = try await scope.role.findBy(id: input.id)
                else {
                    throw Role.Edit.Error.notFound
                }

                try model.update(
                    name: input.name,
                    notes: input.notes
                )

                return try await scope.role.update(model)
            }

            return .init(
                id: model.id,
                key: model.key,
                name: model.name,
                notes: model.notes,
                createdAt: model.createdAt,
                updatedAt: model.updatedAt
            )
        }
    }

}
