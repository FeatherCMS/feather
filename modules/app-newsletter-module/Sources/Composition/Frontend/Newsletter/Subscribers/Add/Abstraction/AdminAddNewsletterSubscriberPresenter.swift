import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

protocol AdminAddNewsletterSubscriberPresenter: Sendable {
    func render(
        model: AdminAddNewsletterSubscriberModel,
        isAdded: Bool,
        permissions: Set<String>
    ) -> HTMLResponse
}
