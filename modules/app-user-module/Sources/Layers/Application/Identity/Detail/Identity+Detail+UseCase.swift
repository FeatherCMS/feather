public import FeatherApplication
public import FeatherModuleKit
public import UserModule

//
//  Identity.Detail.UseCase.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Identity.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Identity.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Identity.Detail.Scope>
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

            return try await query.run { scope in
                try await scope.identity.find(id: input.id)
            }
        }
    }

}
