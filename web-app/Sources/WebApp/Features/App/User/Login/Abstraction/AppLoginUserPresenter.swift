import Foundation
import HTML
import Hummingbird

protocol AppLoginUserPresenter: Sendable {
    func renderPage(
        form: LoginForm.State,
        message: String?
    ) -> HTMLResponse

    func formState(
        email: String,
        password: String,
        isPersistent: Bool
    ) -> LoginForm.State
}
