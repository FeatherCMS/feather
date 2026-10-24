import AnalyticsDomain
public import AnalyticsModule
public import FeatherApplication
public import FeatherModuleKit

//
//  Log+List+UseCase.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Log.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Scope>
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
            let objectQuery = input.query
            return try await query.run { scope in
                try await scope.query.list(query: objectQuery)
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
            let objectQuery = input.query
            return try await query.run { scope in
                try await scope.query.count(query: objectQuery)
            }
        }
    }
}
