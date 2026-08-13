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

extension AppRequestContext {

    func applicationAPI() -> ApplicationAPI {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }

    func managementAPI() -> AdminAPI {
        .init(
            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
            sessionToken: sessionToken
        )
    }
}
