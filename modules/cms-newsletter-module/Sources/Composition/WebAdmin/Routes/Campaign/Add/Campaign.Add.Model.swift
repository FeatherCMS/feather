import NewsletterApplication
import NewsletterModule

extension Campaign.Add {
    struct Model: Sendable {
        let key: String
        let name: String
        let fromEmail: String
        let error: String?
    }
}
