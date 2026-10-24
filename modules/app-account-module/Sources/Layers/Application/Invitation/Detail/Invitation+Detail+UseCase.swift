public import AccountModule
public import FeatherApplication
public import FeatherModuleKit

//
//  Invitation+Detail+UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Invitation.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Invitation.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Invitation.Detail.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Invitation.Detail.Input
        ) async throws -> Invitation.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.query.getBy(id: input.id)
            }
        }
    }
}
