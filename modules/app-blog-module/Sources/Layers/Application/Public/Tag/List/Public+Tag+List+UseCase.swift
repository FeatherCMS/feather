//
//  ListPublicTags.swift
//  app-blog-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import BlogModule
import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebApplication

extension Public.Tag.List {
    public struct UseCase {
        let query: any QueryExecutor<Public.Query.Scope>

        public init(
            query: any QueryExecutor<Public.Query.Scope>
        ) {
            self.query = query
        }

        public func execute(input: Input) async throws -> Output {
            let now = Date()
            let items = try await query.run { scope in
                let tags = try await scope.tag.list(
                    query: .init(
                        page: .init(size: 10_000, number: 1),
                        sort: [.init(field: .createdAt, direction: .desc)]
                    )
                )
                var result: [Public.Tag.Summary.Output] = []
                for item in tags.items {
                    guard
                        let metadata = try await scope.metadata.find(
                            referenceType: "blog.tag",
                            referenceID: item.id
                        ),
                        metadata.isPublic(at: now)
                    else {
                        continue
                    }
                    result.append(
                        .init(
                            id: item.id,
                            title: item.title,
                            excerpt: item.excerpt,
                            imageAssetId: item.imageAssetId,
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
