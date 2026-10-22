public import AnalyticsModule
import AnalyticsDomain
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
        let query: any QueryExecutor<ReadLog>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<ReadLog>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Log.List.Input
        ) async throws -> Log.List.Output {
            let action = Log.List.Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let objectQuery = input.query
            return try await query.run { scope in
                try await scope.log.list(query: objectQuery)
            }
        }

        public func count(
            subject: Subject,
            input: Log.List.Input
        ) async throws -> Int {
            let action = Log.List.Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let objectQuery = input.query
            return try await query.run { scope in
                try await scope.log.count(query: objectQuery)
            }
        }
    }
}
