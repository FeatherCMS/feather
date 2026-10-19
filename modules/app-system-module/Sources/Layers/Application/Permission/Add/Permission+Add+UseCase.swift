public import SystemModule
public import FeatherApplication
public import FeatherModuleKit
import SystemDomain

//
//  Permission.Add.UseCase.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Permission.Add {

    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Permission.Add.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Permission.Add.Scope>,
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> Output {
            let action = Action()

            guard
                try await authorizer.can(
                    subject: subject,
                    perform: action
                )
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let model = try await transaction.run { scope in
                try await scope.permission.insert(
                    SystemModule.Permission.Model.create(
                        key: input.key,
                        name: input.name,
                        notes: input.notes
                    )
                )
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
