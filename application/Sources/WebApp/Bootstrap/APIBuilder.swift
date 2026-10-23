import AnalyticsWebAdmin
import BlogWebAdmin
import FeatherWebAdmin
import FeatherWebShared
import MediaWebAdmin
import NewsletterWebApp

struct APIBuilder: Sendable {
    let analyticsAdmin: AnalyticsAdminAPIBuilder
    let newsletterApp: NewsletterAppAPIBuilder

    init(environment: AppEnvironment) {
        self.analyticsAdmin = .init(apiBaseURL: environment.apiBaseURL)
        self.newsletterApp = .init(apiBaseURL: environment.apiBaseURL)
    }
}
