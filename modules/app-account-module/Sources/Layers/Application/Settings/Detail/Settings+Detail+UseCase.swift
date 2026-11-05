import AccountDomain
public import AccountModule
public import FeatherApplication
public import FeatherModuleKit

//
//  Settings+Detail+UseCase.swift
//  app-account-module
//
//  Created by Binary Birds on 2026. 07. 16.

extension Settings.Detail {
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
            let userId = input.userId ?? subject.id
            let action = Action(userID: userId)
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.query.find(userId: userId)
            }
        }
    }
}
