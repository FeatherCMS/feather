import NewsApplication
import FeatherWebAdmin
import Hummingbird
import NewsModule

extension Category.Add {
    enum Presenter {}
}

extension Category.Add.Presenter {
    protocol Interface: Sendable {
        func renderForm(
            input: Category.Form.Input,
            error: String?,
            title: String,
            action: String,
            submitLabel: String
        ) async throws -> HTMLResponse

        func renderCreated() -> Response
    }
}
