import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Remove {
    enum Presenter {}
}

extension FormField.Remove.Presenter {
    protocol Interface: Sendable {
        func renderRemovePage(items: [AdminRemoveItemContext])
            async throws -> HTMLResponse

        func renderForbiddenPage() async throws -> HTMLResponse
    }
}
