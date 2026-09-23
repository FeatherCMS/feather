import AccountFrontend
import AnalyticsFrontend
import AuthFrontend
import BlogFrontend
import ContactFrontend
import FeatherAdmin
import Foundation
import MediaFrontend
import NewsletterFrontend
import RedirectFrontend
import SystemFrontend
import UserFrontend
import WebFrontend

struct APIBuilder: Sendable {
    let account: AccountAPIBuilder
    let analytics: AnalyticsAPIBuilder
    let auth: AuthAPIBuilder
    let blog: BlogAPIBuilder
    let contact: ContactAPIBuilder
    let media: MediaAPIBuilder
    let newsletter: NewsletterAPIBuilder
    let redirect: RedirectAPIBuilder
    let system: SystemAPIBuilder
    let user: UserAPIBuilder
    let web: WebAPIBuilder

    init(apiBaseURL: URL) {
        self.account = .init(apiBaseURL: apiBaseURL)
        self.analytics = .init(apiBaseURL: apiBaseURL)
        self.auth = .init(apiBaseURL: apiBaseURL)
        self.blog = .init(apiBaseURL: apiBaseURL)
        self.contact = .init(apiBaseURL: apiBaseURL)
        self.media = .init(apiBaseURL: apiBaseURL)
        self.newsletter = .init(apiBaseURL: apiBaseURL)
        self.redirect = .init(apiBaseURL: apiBaseURL)
        self.system = .init(apiBaseURL: apiBaseURL)
        self.user = .init(apiBaseURL: apiBaseURL)
        self.web = .init(apiBaseURL: apiBaseURL)
    }
}
