import FeatherApplication
import FeatherContracts

public struct NewsArticleExtensionContext: Sendable {
    public let articleID: String
    public let subject: Subject

    public init(
        articleID: String,
        subject: Subject
    ) {
        self.articleID = articleID
        self.subject = subject
    }
}
