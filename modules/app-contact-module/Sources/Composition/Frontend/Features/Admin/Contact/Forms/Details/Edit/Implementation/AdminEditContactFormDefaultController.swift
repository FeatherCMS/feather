import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFormDefaultController: AdminEditContactFormController {
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminEditContactFormInteractor,
            presenter: any AdminEditContactFormPresenter
        )

    func edit(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formKey = try context.requiredParameter("formKey")
        do {
            return try await presenter.renderPage(
                item: try await interactor.get(key: formKey),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch let error as AdminEditContactFormError {
            return try await presenter.renderErrorPage(error: error)
        }
    }

    func update(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formKey = try context.requiredParameter("formKey")
        let form = try await request.decode(
            as: ContactFormEditForm.self,
            context: context
        )
        let current: AdminContactFormDetailsItem
        do {
            current = try await interactor.get(key: formKey)
        }
        catch let error as AdminEditContactFormError {
            return try await presenter
                .renderErrorPage(error: error)
                .response(from: request, context: context)
        }
        do {
            _ = try await interactor.update(
                key: formKey,
                newKey: form.key,
                name: form.name,
                successMessage: form.successMessage ?? "",
                failureMessage: form.failureMessage ?? "",
                redirectUrl: form.redirectUrl,
                fieldIDs: form.fieldIds ?? [],
                mails: form.mails.isEmpty ? current.mails : form.mails
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: "/admin/contact/forms/\(form.key)/edit/",
                        title: "Saved",
                        message: "Contact form updated successfully."
                    )
                ]
            )
        }
        catch let error as AdminEditContactFormError {
            return try await presenter.renderEditError(
                key: formKey,
                item: .init(
                    key: form.key,
                    name: form.name,
                    successMessage: form.successMessage ?? "",
                    failureMessage: form.failureMessage ?? "",
                    redirectUrl: form.redirectUrl,
                    selectedFieldIDs: form.fieldIds ?? [],
                    availableFields: current.availableFields,
                    mails: form.mails.isEmpty ? current.mails : form.mails
                ),
                error: error,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
        }
    }
}
