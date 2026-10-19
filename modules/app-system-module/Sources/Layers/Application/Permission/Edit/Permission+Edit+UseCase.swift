public import SystemModule
public import FeatherApplication
public import FeatherModuleKit
import SystemDomain

//
//  Permission.Edit.UseCase.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Permission.Edit {
    public struct UseCase: FeatherApplication.UseCase {
        public enum Error: UseCaseError {
            case notFound
        }

        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Permission.Edit.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Permission.Edit.Scope>
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
                guard
                    var model = try await scope.permission.find(id: input.id)
                else {
                    throw Error.notFound
                }

                try model.update(
                    key: input.key,
                    name: input.name,
                    notes: input.notes
                )

                return try await scope.permission.update(model)
            }

            return .init(
                id: model.id,
                key: model.key,
                name: model.name,
                notes: model.notes
            )
        }
    }
}
