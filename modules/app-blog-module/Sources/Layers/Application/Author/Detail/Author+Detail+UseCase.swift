public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebApplication

//
//  Author+Detail+UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Author.Detail {
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

            return try await query.run { scope in
                try await scope.author.find(id: input.id)
            }
        }
    }
}
