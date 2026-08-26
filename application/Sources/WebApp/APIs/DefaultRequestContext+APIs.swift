import BlogFrontend
import MediaFrontend
import ContactFrontend
import NewsletterFrontend
import WebFrontend
import AnalyticsFrontend
import RedirectFrontend
import UserFrontend
import SystemFrontend
import FeatherAdmin

extension DefaultRequestContext {

    func appAPI() -> AppAPI {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }

    func adminAPI() -> AdminAPI {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
