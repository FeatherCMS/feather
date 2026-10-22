import AnalyticsFrontend
import BlogWebAdmin
import ContactFrontend
import FeatherWebAdmin
import FeatherWebShared
import MediaWebAdmin
import NewsletterFrontend
import WebModuleWebAdmin

struct APIBuilder: Sendable {
    let analytics: AnalyticsAPIBuilder
    let contact: ContactAPIBuilder
    let newsletter: NewsletterAPIBuilder
    let web: WebModuleWebAdmin.API.Builder

    init(environment: AppEnvironment) {
        self.analytics = .init(apiBaseURL: environment.apiBaseURL)
        self.contact = .init(apiBaseURL: environment.apiBaseURL)
        self.newsletter = .init(apiBaseURL: environment.apiBaseURL)
        self.web = .init(environment: environment)
    }
}
