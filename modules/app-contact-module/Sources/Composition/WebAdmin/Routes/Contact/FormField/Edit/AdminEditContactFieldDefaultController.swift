import ContactModule
import ContactModule
import FeatherWebShared
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminEditContactFieldDefaultController:
    AdminEditContactFieldController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminEditContactFieldInteractor,
            any AdminEditContactFieldPresenter
        >

    func edit(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> HTMLResponse
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        guard context.isCurrentUserAllowed(to: FormField.Permissions.update)
        else {
            return try await presenter.renderForbiddenPage()
        }
        let id = try context.requiredParameter("fieldId")
        do {
            return try await presenter.renderPage(
                field: try await interactor.get(id: id),
                error: nil,
                fieldErrors: [:],
                permissions: context.currentUserPermissions
            )
        }
        catch let error as AdminEditContactFieldError {
            return try await presenter.renderErrorPage(error: error)
        }
    }

    func update(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let __runtimeBuild2 = buildRuntime(request, context)
        let interactor = __runtimeBuild2.interactor
        let presenter = __runtimeBuild2.presenter
        guard context.isCurrentUserAllowed(to: FormField.Permissions.update)
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        let id = try context.requiredParameter("fieldId")
        let form = try await request.decode(
            as: ContactFieldFormInput.self,
            context: context
        )
        if let error = form.allowedValuesValidationError {
            return
                try await presenter.renderPage(
                    field: .init(
                        id: id,
                        key: form.key,
                        type: form.type,
                        label: form.label,
                        allowedValues: form.allowedValues,
                        isRequired: form.isRequiredValue,
                        position: form.position
                    ),
                    error: nil,
                    fieldErrors: ["allowedValues": error],
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        do {
            try await interactor.update(id: id, form: form)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: "/admin/contact/fields/",
                        title: "Updated",
                        message: "Contact field updated successfully."
                    )
                ]
            )
        }
        catch let error as AdminEditContactFieldError {
            return
                try await presenter.renderEditError(
                    field: .init(
                        id: id,
                        key: form.key,
                        type: form.type,
                        label: form.label,
                        allowedValues: form.allowedValues,
                        isRequired: form.isRequiredValue,
                        position: form.position
                    ),
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
