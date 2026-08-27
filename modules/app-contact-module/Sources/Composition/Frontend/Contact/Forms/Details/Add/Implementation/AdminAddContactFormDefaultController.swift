import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebStandards

struct AdminAddContactFormDefaultController: AdminAddContactFormController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminAddContactFormInteractor,
            presenter: any AdminAddContactFormPresenter
        )

    func add(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let availableFields = (try? await interactor.availableFields()) ?? []
        return presenter.renderPage(
            item: .init(
                id: "",
                name: "",
                successMessage: "",
                failureMessage: "",
                redirectUrl: nil,
                selectedFieldIDs: [],
                availableFields: availableFields,
                mails: []
            ),
            error: nil,
            permissions: context.currentUserPermissions
        )
    }

    func create(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let form = try await request.decode(
            as: ContactFormEditForm.self,
            context: context
        )
        _ = try await interactor.create(
            name: form.name,
            successMessage: form.successMessage ?? "",
            failureMessage: form.failureMessage ?? "",
            redirectUrl: form.redirectUrl,
            fieldIDs: form.fieldIds ?? [],
            mails: form.mails
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/contact/forms/",
                    title: "Added",
                    message: "Contact form added successfully."
                )
            ]
        )
    }
}
