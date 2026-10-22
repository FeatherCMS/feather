import AnalyticsWebAdmin
import BlogWebAdmin
import ContactWebShared
import FeatherWebAdmin
import FeatherWebShared
import MediaWebAdmin
import NewsletterWebAdmin
import NewsletterWebApp

struct APIBuilder: Sendable {
    let analyticsAdmin: AnalyticsAdminAPIBuilder
    let contact: ContactAPIBuilder
    let newsletterAdmin: NewsletterAdminAPIBuilder
    let newsletterApp: NewsletterAppAPIBuilder

    init(environment: AppEnvironment) {
        self.analyticsAdmin = .init(apiBaseURL: environment.apiBaseURL)
        self.contact = .init(apiBaseURL: environment.apiBaseURL)
        self.newsletterAdmin = .init(apiBaseURL: environment.apiBaseURL)
        self.newsletterApp = .init(apiBaseURL: environment.apiBaseURL)
    }
}
