public import BlogModule
public import FeatherApplication
public import FeatherModuleKit
import WebModule

//
//  GetAuthorLink.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension AuthorLink.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<AuthorLink.Detail.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<AuthorLink.Detail.Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject,
            input: Input
        ) async throws -> AuthorLink.Detail.Output {
            let action = Action()

            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }

            return try await query.run { scope in
                let detail = try await scope.authorLink.find(id: input.id)
                guard detail.authorId == input.authorId else {
                    throw Error(message: "Menu item not found")
                }
                return detail
            }
        }
    }
}
