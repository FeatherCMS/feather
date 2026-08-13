//
//  GetPublicPageByID.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import FeatherDomain
import Foundation
import WebDomain

public struct GetPublicPageByID {
    public struct Error: UseCaseError {
        public let message: String

        public init(message: String) {
            self.message = message
        }
    }

    let query: any QueryExecutor<ReadPageMetadata>

    public init(
        query: any QueryExecutor<ReadPageMetadata>
    ) {
        self.query = query
    }

    public func execute(
        id: String
    ) async throws -> PublicPageDetail {
        let now = Date()
        return try await query.run { scope in
            let page = try await scope.page.find(id: id)
            guard page.metadata.isDirectlyAccessible(at: now) else {
                throw Error(message: "Page not found")
            }
            return .init(
                id: page.id,
                title: page.title,
                excerpt: page.excerpt,
                content: page.content,
                imageAssetId: page.imageAssetId,
                imageURL: "",
                media: nil,
                metadata: page.metadata
            )
        }
    }
}
