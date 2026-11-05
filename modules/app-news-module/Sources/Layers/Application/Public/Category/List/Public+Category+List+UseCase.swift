//
//  Public+Category+List+UseCase.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
public import FeatherModuleKit
import Foundation
import WebApplication
import WebModule

extension Public.Category.List {
    public struct UseCase: FeatherApplication.UseCase {
        let query: any QueryExecutor<Scope>

        public init(query: any QueryExecutor<Scope>) {
            self.query = query
        }

        public func execute() async throws -> Output {
            let now = Date()
            return try await query.run { scope in
                let categories = try await scope.category.list()
                let metadata = try await scope.metadataDetails.resolveDetails(
                    referenceType: "news.category",
                    referenceIDs: Array(Set(categories.map(\.id)))
                )
                var metadataByID: [String: WebModule.Metadata.Snapshot] = [:]
                for item in metadata where item.isPublic(at: now) {
                    precondition(
                        metadataByID.updateValue(
                            item,
                            forKey: item.referenceID
                        ) == nil
                    )
                }
                let items: [Public.Category.Summary.Item] =
                    categories
                    .compactMap { item -> Public.Category.Summary.Item? in
                        guard let metadata = metadataByID[item.id] else {
                            return nil
                        }
                        return .init(
                            id: item.id,
                            title: item.title,
                            excerpt: item.excerpt,
                            imageAssetId: item.imageAssetId,
                            imageURL: "",
                            media: nil,
                            metadata: metadata
                        )
                    }
                return .init(items: items)
            }
        }
    }
}
