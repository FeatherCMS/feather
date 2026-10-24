public import FeatherApplication
public import FeatherModuleKit
public import MediaModule

//
//  Asset.File.Search.UseCase.swift
//  app-media-module
//
//  Created by Binary Birds on 2026. 06. 18.

extension Asset.File.Search {
    public struct UseCase: FeatherApplication.UseCase {

        let authorizer: any Authorizer
        let query: any QueryExecutor<Asset.File.Search.Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Asset.File.Search.Scope>
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
                try await scope.query.search(query: input.query)
            }
        }
    }
}
