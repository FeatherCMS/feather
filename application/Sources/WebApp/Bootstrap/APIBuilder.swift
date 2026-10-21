import AccountFrontend
import AnalyticsFrontend
import BlogFrontend
import ContactFrontend
import FeatherWebAdmin
import Foundation
import MediaFrontend
import NewsletterFrontend
import WebFrontend

struct APIBuilder: Sendable {
    let account: AccountAPIBuilder
    let analytics: AnalyticsAPIBuilder
    let blog: BlogAPIBuilder
    let contact: ContactAPIBuilder
    let media: MediaAPIBuilder
    let newsletter: NewsletterAPIBuilder
    let web: WebAPIBuilder

    init(apiBaseURL: URL) {
        self.account = .init(apiBaseURL: apiBaseURL)
        self.analytics = .init(apiBaseURL: apiBaseURL)
        self.blog = .init(apiBaseURL: apiBaseURL)
        self.contact = .init(apiBaseURL: apiBaseURL)
        self.media = .init(apiBaseURL: apiBaseURL)
        self.newsletter = .init(apiBaseURL: apiBaseURL)
        self.web = .init(apiBaseURL: apiBaseURL)
    }
}
