public import FeatherApplication
public import FeatherModuleKit
public import SystemModule

//
//  Permission.List.UseCase.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Permission.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Permission.List.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Permission.List.Scope>
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

            let inputQuery = input.query

            return try await query.run { scope in
                try await scope.permission.list(
                    query: inputQuery
                )
            }
        }

        public func count(
            subject: Subject,
            input: Input
        ) async throws -> Int {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            let inputQuery = input.query

            return try await query.run { scope in
                try await scope.permission.count(
                    query: inputQuery
                )
            }
        }
    }
}
