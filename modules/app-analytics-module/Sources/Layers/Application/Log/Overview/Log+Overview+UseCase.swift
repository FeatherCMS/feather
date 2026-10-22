import AnalyticsContracts
public import AnalyticsDomain
public import FeatherApplication
public import FeatherModuleKit

//
//  Log+Overview+UseCase.swift
//  app-analytics-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Log.Overview {
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
            input: Log.Overview.Input
        ) async throws -> Log.Overview.Output {
            let action = Log.Overview.Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            return try await query.run { scope in
                try await scope.log.overview(query: input.query)
            }
        }
    }
}
