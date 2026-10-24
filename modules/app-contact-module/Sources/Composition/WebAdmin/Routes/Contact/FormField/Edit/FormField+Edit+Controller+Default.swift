import ContactApplication
import ContactModule
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Edit.Controller {
    struct Default: Interface {
        let routes: Contact.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any FormField.Edit.Interactor.Interface,
                any FormField.Edit.Presenter.Interface
            >

        func edit(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> HTMLResponse
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
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
            catch let error as FormField.Edit.Error {
                return try await presenter.renderErrorPage(error: error)
            }
        }

        func update(request: Request, context: AuthenticatedRequestContext)
            async throws
            -> Response
        {
            let runtime = buildRuntime(request, context)
            let interactor = runtime.interactor
            let presenter = runtime.presenter
            guard context.isCurrentUserAllowed(to: FormField.Permissions.update)
            else {
                return
                    try await presenter
                    .renderForbiddenPage()
                    .response(from: request, context: context)
            }
            let id = try context.requiredParameter("fieldId")
            let form = try await request.decode(
                as: FormField.Add.Form.Input.self,
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
                            defaultPath: routes.fields.path,
                            title: "Updated",
                            message: "Contact field updated successfully."
                        )
                    ]
                )
            }
            catch let error as FormField.Edit.Error {
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
}
