public import BlogModule
public import FeatherApplication
public import FeatherModuleKit

//
//  ListAuthorLinks.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension AuthorLink.List {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<AuthorLink.List.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<AuthorLink.List.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> AuthorLink.List.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                try await scope.authorLink.list(
                    authorId: input.authorId
                )
            }
        }
    }
}
