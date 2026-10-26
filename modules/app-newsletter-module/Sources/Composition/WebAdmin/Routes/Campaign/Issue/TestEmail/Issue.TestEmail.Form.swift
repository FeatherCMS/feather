import NewsletterApplication
import NewsletterModule

extension Issue.TestEmail {
    struct Form: Decodable {
        let email: String
        let subject: String
        let content: String
    }
}
