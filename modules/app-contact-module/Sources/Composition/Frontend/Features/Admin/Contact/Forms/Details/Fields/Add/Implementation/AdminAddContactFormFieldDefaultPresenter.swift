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
    ) -> HTMLResponse {
        return renderingEngine.renderNewAdminPage(
            request: request,
            title: "Add contact form field",
            permissions: permissions,
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
