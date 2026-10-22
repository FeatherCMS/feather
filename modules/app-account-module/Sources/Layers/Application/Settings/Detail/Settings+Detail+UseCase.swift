import AccountDomain
public import AccountModule
public import FeatherApplication
public import FeatherModuleKit

//
//  GetSettings.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

extension Settings.Detail {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let query: any QueryExecutor<Settings.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Settings.Detail.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Settings.Detail.Input
        ) async throws -> Settings.Detail.Output {
            let userId = input.userId ?? subject.id
            let action = Action(userID: userId)
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                let settings = try await scope.query.get(userId: userId)
                return .init(
                    userId: settings.userId,
                    language: settings.language,
                    timezone: settings.timezone,
                    pageSize: settings.pageSize,
                    createdAt: settings.createdAt,
                    updatedAt: settings.updatedAt
                )
            }
        }
    }
}
