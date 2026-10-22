import AnalyticsFrontend
import BlogWebAdmin
import ContactWebShared
import FeatherWebAdmin
import FeatherWebShared
import MediaWebAdmin
import NewsletterFrontend

struct APIBuilder: Sendable {
    let analytics: AnalyticsAPIBuilder
    let contact: ContactAPIBuilder
    let newsletter: NewsletterAPIBuilder

    init(environment: AppEnvironment) {
        self.analytics = .init(apiBaseURL: environment.apiBaseURL)
        self.contact = .init(apiBaseURL: environment.apiBaseURL)
        self.newsletter = .init(apiBaseURL: environment.apiBaseURL)
    }
}
