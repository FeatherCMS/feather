import NewsletterApplication
import NewsletterModule

extension Campaign.Add {
    enum WebError: Error, Sendable {
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
