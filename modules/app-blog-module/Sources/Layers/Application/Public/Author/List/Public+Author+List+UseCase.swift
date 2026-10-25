//
//  Public+Author+List+UseCase.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebApplication

extension Public.Author.List {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(
            query: any QueryExecutor<Scope>
        ) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let now = Date()
            let items = try await query.run { scope in
                let authors = try await scope.authorList.list()
                var result: [Public.Author.Summary.Item] = []
                for item in authors.items {
                    guard
                        let metadata = try await scope.metadata.find(
                            referenceType: "blog.author",
                            referenceID: item.id
                        ),
                        metadata.isPublic(at: now)
                    else {
                        continue
                    }
                    result.append(
                        .init(
                            id: item.id,
                            name: item.name,
                            excerpt: item.excerpt,
                            content: item.content,
                            imageAssetId: item.profileImageAssetId,
                            imageURL: "",
                            media: nil,
                            metadata: metadata
                        )
                    )
                }
                return result
            }
            return .init(items: items)
        }
    }
}
