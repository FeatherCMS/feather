import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormFieldDefaultPresenter:
    AdminAddContactFormFieldPresenter
{
    let request: Request
    let context: DefaultRequestContext
    let renderingEngine: any RenderingEngine
    func renderPage(
        model: AdminAddContactFormFieldModel,
        permissions: Set<String>
    ) async throws -> HTMLResponse {
        try await renderingEngine.renderNewAdminPage(
            request: request,
            context: context,
            title: "Add contact form field",
            content: ContactFormFieldAddPage(
                state: .init(
                    formId: model.formId,
                    key: model.key,
                    type: model.type,
                    label: model.label,
                    allowedValues: model.allowedValues,
                    isRequired: model.isRequired,
                    position: model.position,
                    error: model.error,
                    breadcrumb: ContactAdminRoutes.formFieldsBreadcrumb(
                        RouterPath(model.formId)
                    )
                )
            )
        )
    }
}
