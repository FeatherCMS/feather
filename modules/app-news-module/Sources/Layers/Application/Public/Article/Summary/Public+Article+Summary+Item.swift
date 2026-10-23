import Foundation
public import WebApplication
public import WebModule

extension Public.Article.Summary {
    public struct Item: Sendable {
        public let id: String
        public let title: String
        public let excerpt: String
        public let imageAssetId: String?
        public let imageURL: String
        public let media: WebApplication.Public.Media?
        public let metadata: WebModule.Metadata.Snapshot
        public let readingTime: Int
        public let categoryIDs: [String]

        public init(
            id: String,
            title: String,
            excerpt: String,
            imageAssetId: String?,
            imageURL: String,
            media: WebApplication.Public.Media?,
            metadata: WebModule.Metadata.Snapshot,
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
}

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
