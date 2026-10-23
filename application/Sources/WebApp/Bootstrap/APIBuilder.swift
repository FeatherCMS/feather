import FeatherWebShared
import NewsletterWebApp

struct APIBuilder: Sendable {
    let newsletterApp: NewsletterAppAPIBuilder

    init(environment: AppEnvironment) {
        self.newsletterApp = .init(apiBaseURL: environment.apiBaseURL)
    }
}
