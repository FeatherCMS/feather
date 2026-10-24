import NewsletterApplication
import NewsletterModule

extension Campaign.Edit {
    struct Form: Decodable {
        let key: String
        let name: String
        let fromEmail: String
    }
}
