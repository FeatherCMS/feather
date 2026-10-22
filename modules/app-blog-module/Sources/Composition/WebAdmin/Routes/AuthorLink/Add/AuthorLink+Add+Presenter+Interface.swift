import BlogModule
import FeatherValidation
import FeatherWebAdmin
import HTML
import Hummingbird
import MediaWebAdmin
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension AuthorLink.Add.Presenter {
    protocol Interface: Sendable {
        func render(
            authorID: String,
            state: AuthorLink.Form.State,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
