public import FeatherApplication
public import NewsletterModule

extension Issue.TestEmail {
    public struct Input: DTO {
        public let newsletterKey: String
        public let email: String
        public let subject: String
        public let content: String

        public init(
            newsletterKey: String,
            email: String,
            subject: String,
            content: String
        ) {
            self.newsletterKey = newsletterKey
            self.email = email
            self.subject = subject
            self.content = content
        }
    }
}
