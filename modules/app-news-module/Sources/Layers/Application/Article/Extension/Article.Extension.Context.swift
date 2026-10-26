public import FeatherModuleKit
public import NewsModule

extension Article.Extension {
    public struct Context: Sendable {
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
}
