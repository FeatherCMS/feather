import ContactApplication
import ContactModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension FormField.Add.Controller {
    struct Default: Interface {
        let routes: Contact.Router.Routes
        let buildRuntime:
            @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
                any FormField.Add.Interactor.Interface,
                any FormField.Add.Presenter.Interface
            >

        func getAddContactField(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> HTMLResponse {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
        guard
            context.isCurrentUserAllowed(
                to: FormField.Permissions.create
            )
        else {
            return try await presenter.renderForbiddenPage()
        }
        let formKey = request.queryString("form")?.whitespaceTrimmed.emptyToNil
        guard
            formKey == nil
                || context.isCurrentUserAllowed(
                    to: Form.Permissions.update
                )
        else {
            return try await presenter.renderForbiddenPage()
        }
        return try await presenter.renderPage(
            model: try await interactor.getAddContactField(),
            permissions: context.currentUserPermissions
        )
    }
        func postAddContactField(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
        let runtime = buildRuntime(request, context)
        let interactor = runtime.interactor
        let presenter = runtime.presenter
        guard
            context.isCurrentUserAllowed(
                to: FormField.Permissions.create
            )
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        let formKey = request.queryString("form")?.whitespaceTrimmed.emptyToNil
        guard
            formKey == nil
                || context.isCurrentUserAllowed(
                    to: Form.Permissions.update
                )
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        let payload = try await request.decode(
            as: ContactFieldFormInput.self,
            context: context
        )
        do {
            let model = try await interactor.postAddContactField(
                payload: payload,
                formKey: formKey
            )
            if model.fieldErrors.isEmpty {
                let successPath = formKey.map(routes.formFieldsPath)
                    ?? routes.fields.path
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: successPath,
                            title: "Added",
                            message: formKey == nil
                                ? "Form field added successfully."
                                : "Form field added and assigned to this form."
                        )
                    ]
                )
            }
            return
                try await presenter.renderPage(
                    model: model,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
        catch let error as FormField.Add.Error {
            if case .createdButNotAssigned = error, let formKey {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.formFieldsPath(formKey),
                            title: "Field created, not assigned",
                            message:
                                "The field was created, but could not be assigned. Add it from this form's Fields tab."
                        )
                    ]
                )
            }
            return
                try await presenter.renderAddError(
                    input: payload,
                    error: error,
                    permissions: context.currentUserPermissions
                )
                .response(from: request, context: context)
        }
    }
}
