//
//  WebRoute+Resolve+UseCase.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
import Foundation

extension WebRoute.Resolve {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(
            query: any QueryExecutor<Scope>
        ) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let now = Date()
            let metadata = try await query.run { scope in
                try await scope.metadata.resolve(slug: input.slug)
            }
            guard let metadata, metadata.isDirectlyAccessible(at: now) else {
                throw Error(message: "Route not found")
            }
            return .init(
                referenceType: metadata.referenceType,
                referenceID: metadata.referenceID,
                slug: metadata.slug,
                template: metadata.template
            )
        }
    }
}
