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
            return try await query.run { scope in
                guard
                    let metadata = try await scope.metadata.resolve(
                        slug: input.slug
                    ),
                    metadata.isDirectlyAccessible(at: now)
                else {
                    throw WebRoute.Resolve.Error(message: "Route not found")
                }
                let referenceType = metadata.referenceType
                let referenceID = metadata.referenceID

                return .init(
                    referenceType: referenceType,
                    referenceID: referenceID,
                    slug: metadata.slug,
                    template: metadata.template
                )
            }
        }
    }
}
