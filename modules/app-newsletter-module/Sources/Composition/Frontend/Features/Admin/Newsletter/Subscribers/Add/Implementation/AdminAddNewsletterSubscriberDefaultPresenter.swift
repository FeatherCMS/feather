import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddNewsletterSubscriberDefaultPresenter:
    AdminAddNewsletterSubscriberPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine

    func render(
        model: AdminAddNewsletterSubscriberModel,
        isAdded: Bool,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add subscriber",
            content: AdminAddNewsletterSubscriberView(
                model: model,
                isAdded: isAdded,
                breadcrumb: .init(links: [
                    .init(label: "Admin", link: "/admin/"),
                    .init(label: "Newsletter", link: "/admin/newsletter/"),
                    .init(
                        label: "Subscribers",
                        link: "/admin/newsletter/subscribers/"
                    ),
                ])
            )
        )
    }
}
