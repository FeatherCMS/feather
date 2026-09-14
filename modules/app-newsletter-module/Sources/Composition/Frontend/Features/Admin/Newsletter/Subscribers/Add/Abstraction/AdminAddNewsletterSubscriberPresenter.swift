import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

protocol AdminAddNewsletterSubscriberPresenter: Sendable {
    func render(
        model: AdminAddNewsletterSubscriberModel,
        isAdded: Bool,
        permissions: Set<String>
    ) -> HTMLResponse
}
