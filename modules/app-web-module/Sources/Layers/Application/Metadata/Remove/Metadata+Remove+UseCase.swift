public import FeatherApplication
public import FeatherModuleKit
import SystemModule
import WebDomain
public import WebModule

//
//  RemoveMetadata.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Metadata.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Metadata.Remove.Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Metadata.Remove.Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> [String] {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await transaction.run { scope in
                try await scope.metadata.delete(ids: input.ids)
            }
        }
    }
}
