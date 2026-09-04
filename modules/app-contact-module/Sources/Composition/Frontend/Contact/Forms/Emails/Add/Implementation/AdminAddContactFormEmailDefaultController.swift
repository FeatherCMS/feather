import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AdminAddContactFormEmailDefaultController:
    AdminAddContactFormEmailController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddContactFormEmailInteractor,
            presenter: any AdminAddContactFormEmailPresenter
        )

    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        do {
            let form = try await interactor.get(id: formId)
            let fields = form.availableFields.filter {
                form.selectedFieldIDs.contains($0.id)
            }
            return presenter.renderPage(
                formId: formId,
                availableFields: fields,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderPage(
                formId: formId,
                availableFields: [],
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let input = try await request.decode(
            as: SubmissionMailFormInput.self,
            context: context
        )
        try await interactor.add(id: formId, email: input.mail)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/emails/",
                    title: "Added",
                    message: "Contact form email added successfully."
                )
            ]
        )
    }
}
