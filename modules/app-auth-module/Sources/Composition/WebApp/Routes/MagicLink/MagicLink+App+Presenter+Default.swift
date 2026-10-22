import AuthModule
import FeatherWebAdmin
import FeatherWebApp
import WebBuilders
import WebComponents

extension MagicLink.App.Presenter {
    struct Default: Interface {
        func render(
            email: String,
            isPersistent: Bool,
            error: String?,
            message: String?,
            turnstileSiteKey: String?,
            routes: MagicLink.App.Router.Routes
        ) -> HTMLResponse {
            var context = BuilderContext()
            let component = AdminHTML(
                title: "Magic link",
                body: .init(
                    content: MagicLink.App.Page(
                        email: email,
                        isPersistent: isPersistent,
                        error: error,
                        message: message,
                        turnstileSiteKey: turnstileSiteKey,
                        routes: routes
                    ),
                    showsFooter: false,
                    allowsPasswordManagerAutofill: true
                ),
                stylesheetPath: nil
            )
            return .init(context.build(component))
        }
    }
}
