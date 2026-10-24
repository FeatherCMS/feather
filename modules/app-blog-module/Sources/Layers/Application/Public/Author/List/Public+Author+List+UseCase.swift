//
//  ListPublicAuthors.swift
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
                let authors = try await scope.authorList.list(
                    query: .init(
                        page: .init(size: 10_000, number: 1),
                        sort: [.init(field: .createdAt, direction: .desc)]
                    )
                )
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
                    let author = try await scope.authorList.findAuthor(
                        id: item.id
                    )
                    result.append(
                        .init(
                            id: author.id,
                            name: author.name,
                            excerpt: author.excerpt,
                            content: author.content,
                            imageAssetId: author.profileImageAssetId,
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
