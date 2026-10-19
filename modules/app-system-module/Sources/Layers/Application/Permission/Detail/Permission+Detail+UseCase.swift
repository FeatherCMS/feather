public import SystemModule
public import FeatherApplication
public import FeatherModuleKit

//
//  Permission.Detail.UseCase.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Permission.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Permission.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Permission.Detail.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
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

            let id = input.id

            return try await query.run { scope in
                try await scope.permission.find(id: id)
            }
        }
    }
}
