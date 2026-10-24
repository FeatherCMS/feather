import Foundation
import NewsModule

extension Public.Article {
    public enum ReadingTime {
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
}
