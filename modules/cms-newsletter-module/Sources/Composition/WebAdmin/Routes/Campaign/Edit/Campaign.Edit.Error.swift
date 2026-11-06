import NewsletterApplication
import NewsletterModule

extension Campaign.Edit {
    enum WebError: Swift.Error, Sendable {
        case notFound
        case unauthorized
        case forbidden
        case conflict
        case unavailable
    }
}
