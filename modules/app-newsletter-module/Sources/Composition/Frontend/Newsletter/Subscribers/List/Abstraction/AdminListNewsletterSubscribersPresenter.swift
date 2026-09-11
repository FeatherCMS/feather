import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminListNewsletterSubscribersPresenter: Sendable {
    func render(
        model: AdminNewsletterSubscribersListModel,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse
}
