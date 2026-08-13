import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminListContactSubmissionsPresenter: Sendable {
    func render(
        items: [AdminContactSubmissionDirectoryItem],
        search: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
