import FeatherWebAdmin
import FeatherWebShared
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminAddContactFormEmailDefaultController:
    AdminAddContactFormEmailController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminAddContactFormEmailInteractor,
            any AdminAddContactFormEmailPresenter
        >

    func add(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        let formId = try context.requiredParameter("formKey")
        do {
            let form = try await interactor.get(id: formId)
            let fields = form.availableFields.filter {
                form.selectedFieldIDs.contains($0.id)
            }
            return try await presenter.renderPage(
                formId: formId,
                availableFields: fields,
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return try await presenter.renderPage(
                formId: formId,
                availableFields: [],
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

    func create(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let interactor = buildRuntime(request, context).interactor
        let formId = try context.requiredParameter("formKey")
        let input = try await request.decode(
            as: SubmissionMailFormInput.self,
            context: context
        )
        try await interactor.add(id: formId, email: input.mail)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminNotificationRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/emails/",
                    title: "Added",
                    message: "Contact form email added successfully."
                )
            ]
        )
    }
}
