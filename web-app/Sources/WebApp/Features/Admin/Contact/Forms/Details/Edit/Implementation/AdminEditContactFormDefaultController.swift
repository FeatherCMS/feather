import Hummingbird

struct AdminEditContactFormDefaultController: AdminEditContactFormController {
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditContactFormInteractor,
            presenter: any AdminEditContactFormPresenter
        )

    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        do {
            return presenter.renderPage(
                item: try await interactor.get(id: formId),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderPage(
                item: .init(
                    id: formId,
                    name: "",
                    successMessage: "",
                    failureMessage: "",
                    redirectUrl: nil,
                    selectedFieldIDs: [],
                    availableFields: [],
                    mails: []
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, _) = buildRuntime(request, context)
        let formId = try context.requiredParameter("formId")
        let form = try await request.decode(
            as: ContactFormEditForm.self,
            context: context
        )
        let current = try await interactor.get(id: formId)
        _ = try await interactor.update(
            id: formId,
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
                .location: AdminToastRedirect.location(
                    defaultPath: "/admin/contact/forms/\(formId)/edit/",
                    title: "Saved",
                    message: "Contact form updated successfully."
                )
            ]
        )
    }
}
