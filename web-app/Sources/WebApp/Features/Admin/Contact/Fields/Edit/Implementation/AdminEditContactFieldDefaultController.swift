import Hummingbird

struct AdminEditContactFieldDefaultController:
    AdminEditContactFieldController
{
    let buildRuntime:
        @Sendable (Request, AppRequestContext) -> (
            interactor: any AdminEditContactFieldInteractor,
            presenter: any AdminEditContactFieldPresenter
        )

    func edit(request: Request, context: AppRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("fieldId")
        do {
            return presenter.renderPage(
                field: try await interactor.get(id: id),
                error: nil,
                permissions: context.currentUserPermissions
            )
        }
        catch {
            return presenter.renderPage(
                field: .init(
                    id: id,
                    key: "",
                    type: "text",
                    label: "",
                    allowedValues: "",
                    isRequired: false,
                    position: "0"
                ),
                error: error.displayMessage,
                permissions: context.currentUserPermissions
            )
        }
    }

    func update(request: Request, context: AppRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        let id = try context.requiredParameter("fieldId")
        let form = try await request.decode(
            as: ContactFieldFormInput.self,
            context: context
        )
        do {
            try await interactor.update(id: id, form: form)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/contact/fields/",
                        title: "Updated",
                        message: "Contact field updated successfully."
                    )
                ]
            )
        }
        catch {
            return
                try presenter.renderPage(
                    field: .init(
                        id: id,
                        key: form.key,
                        type: form.type,
                        label: form.label,
                        allowedValues: form.allowedValues,
                        isRequired: form.isRequiredValue,
                        position: form.position
                    ),
                    error: error.displayMessage,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
