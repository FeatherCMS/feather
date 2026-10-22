//
//  PublicNewsArticleSummary.swift
//  app-news-module
//
//  Created by Binary Birds on 2026. 06. 18.

public import FeatherApplication
import Foundation
public import WebApplication

public enum NewsReadingTime {
    public static func minutes(for content: String) -> Int {
        let plainText = content.replacingOccurrences(
            of: "<[^>]+>",
            with: " ",
            options: .regularExpression
        )
        let wordCount = plainText.split { $0.isWhitespace }.count
        return max(1, (wordCount + 199) / 200)
    }
}

public struct PublicNewsArticleSummary: DTO {
    public let id: String
    public let title: String
    public let excerpt: String
    public let imageAssetId: String?
    public let imageURL: String
    public let media: PublicContentMedia?
    public let metadata: MetadataDetail
    public let readingTime: Int
    public let categoryIDs: [String]

    public init(
        id: String,
        title: String,
        excerpt: String,
        imageAssetId: String?,
        imageURL: String,
        media: PublicContentMedia?,
        metadata: MetadataDetail,
        readingTime: Int,
        categoryIDs: [String]
    ) {
        self.id = id
        self.title = title
        self.excerpt = excerpt
        self.imageAssetId = imageAssetId
        self.imageURL = imageURL
        self.media = media
        self.metadata = metadata
        self.readingTime = readingTime
        self.categoryIDs = categoryIDs
    }
}
