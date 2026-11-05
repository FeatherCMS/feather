public import FeatherApplication
public import FeatherModuleKit
import SystemDomain
public import SystemModule

//
//  Permission+Remove+UseCase.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Permission.Remove {
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

            try await transaction.run { scope in
                try await scope.permission.delete(ids: input.ids)
            }
            return .init()
        }
    }
}
