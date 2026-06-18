import Foundation
import HTML
import Hummingbird

struct AppLoginUserDefaultPresenter: AppLoginUserPresenter {
    let request: Request
    let renderEngine: any RenderingEngine

    func renderPage(
        form: LoginForm.State,
        message: String?
    ) -> HTMLResponse {
        renderEngine.renderPage(
            request: request,
            title: "Login - Feather CMS",
            description: "This is the login page for the Feather CMS app",
            imagePath: "images/puppy.png",
            content: LoginPage(
                state: .init(
                    form: form,
                    message: message
                )
            )
        )
    }

    func formState(
        email: String = "mail.tib@gmail.com",
        password: String = "root",
        isPersistent: Bool = true
    ) -> LoginForm.State {
        .init(
            email: .init(
                key: "email",
                label: adminFieldLabelText("Email address", required: true),
                value: email,
                error: nil
            ),
            password: .init(
                key: "password",
                label: adminFieldLabelText("Password", required: true),
                value: password,
                error: nil
            ),
            isPersistent: .init(
                key: "is_persistent",
                label: "Keep me signed in",
                value: isPersistent,
                error: nil
            )
        )
    }
}
