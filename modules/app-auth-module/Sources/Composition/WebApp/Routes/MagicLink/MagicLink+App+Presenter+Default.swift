import AuthModule
import FeatherWebApp

extension MagicLink.App.Presenter {
    struct Default: Interface {
        let templateRenderer: any TemplateRenderer

        func render(
            email: String,
            isPersistent: Bool,
            error: String?,
            message: String?,
            turnstileSiteKey: String?,
            routes: MagicLink.App.Router.Routes
        ) throws -> WebAppHTMLResponse {
            WebAppHTMLResponse(
                content: try templateRenderer.render(
                    template: "pages/magic-link",
                    context: [
                        "email": email,
                        "error": error ?? "",
                        "hasError": error?.isEmpty == false,
                        "hasMessage": message?.isEmpty == false,
                        "hasTurnstile": turnstileSiteKey?.isEmpty == false,
                        "homePath": routes.home.path,
                        "isPersistent": isPersistent,
                        "loginPath": routes.login.path,
                        "message": message ?? "",
                        "requestPath": routes.request.path,
                        "turnstileSiteKey": turnstileSiteKey ?? "",
                    ]
                )
            )
        }
    }
}
