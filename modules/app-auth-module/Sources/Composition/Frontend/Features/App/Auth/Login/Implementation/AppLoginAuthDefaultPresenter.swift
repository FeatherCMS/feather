import AuthAdminAPI
import AuthAppAPI
import CSS
import FeatherAdmin
import FeatherValidation
import FeatherValidationFoundation
import Foundation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import SystemAdminAPI
import SystemFrontend
import UserAdminAPI
import UserAppAPI
import UserFrontend
import WebBuilders
import WebComponents

struct AppLoginAuthDefaultPresenter: AppLoginAuthPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: LoginForm.State,
        message: String?
    ) -> HTMLResponse {
        var buildContext = BuilderContext()
        return renderEngine.renderPublicPage(
            request: request,
            title: "Login",
            description: "This is the login page for the Feather CMS app",
            imagePath: "images/logos/logo.png",
            content: buildContext.build(
                LoginPage(
                    state: .init(
                        form: form,
                        message: message
                    )
                )
            )
        )
    }

    func formState(
        email: String = "mail.tib@gmail.com",
        password: String = "root",
        isPersistent: Bool = true,
        redirectPath: String = "/"
    ) -> LoginForm.State {
        .init(
            email: .init(
                name: "email",
                label: "Email address",
                value: email,
                error: nil,
                type: .email
            ),
            password: .init(
                name: "password",
                label: "Password",
                value: password,
                error: nil,
                type: .password
            ),
            isPersistent: .init(
                name: "is_persistent",
                label: "Session",
                checkboxLabel: "Keep me signed in",
                isChecked: isPersistent
            ),
            redirectPath: redirectPath
        )
    }
}
