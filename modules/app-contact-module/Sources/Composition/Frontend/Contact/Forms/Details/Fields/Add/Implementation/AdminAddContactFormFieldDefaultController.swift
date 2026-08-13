import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddContactFormFieldDefaultController:
    AdminAddContactFormFieldController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminAddContactFormFieldInteractor,
            presenter: any AdminAddContactFormFieldPresenter
        )
    func getAddContactFormField(request: Request, context: AppRequestContext)
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        return presenter.renderPage(
            model: try await interactor.getAddContactFormField(formId: formId),
            permissions: context.currentUserPermissions
        )
    }
    func postAddContactFormField(request: Request, context: AppRequestContext)
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = context.parameters.get("formId", as: String.self) ?? ""
        let payload = try await request.decode(
            as: ContactFormFieldAddForm.self,
            context: context
        )
        let model = try await interactor.postAddContactFormField(
            formId: formId,
            payload: payload
        )
        if model.error == nil {
            let basePath = "/admin/contact/forms/\(formId)/fields/"
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: basePath,
                        title: "Added",
                        message: "Form field added successfully."
                    )
                ]
            )
        }
        return
            try presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
    }
}
