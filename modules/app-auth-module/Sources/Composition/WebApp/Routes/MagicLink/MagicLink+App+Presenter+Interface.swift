import AuthModule
import FeatherWebApp
import FeatherWebShared

extension MagicLink.App.Presenter {
    protocol Interface: Sendable {
        func render(
            email: String,
            isPersistent: Bool,
            error: String?,
            message: String?,
            turnstileSiteKey: String?,
            routes: MagicLink.App.Router.Routes
        ) throws -> WebAppHTMLResponse
    }
}
