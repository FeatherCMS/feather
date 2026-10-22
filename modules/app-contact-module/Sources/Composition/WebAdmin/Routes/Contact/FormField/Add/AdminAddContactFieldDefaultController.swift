import ContactContracts
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

struct AdminAddContactFieldDefaultController:
    AdminAddContactFieldController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminAddContactFieldInteractor,
            any AdminAddContactFieldPresenter
        >
    func getAddContactField(
        request: Request,
        context: AuthenticatedRequestContext
    )
        async throws -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: ContactModule.Permissions.Fields.create
            )
        else {
            return try await presenter.renderForbiddenPage()
        }
        let formKey = request.queryString("form")?.whitespaceTrimmed.emptyToNil
        guard
            formKey == nil
                || context.isCurrentUserAllowed(
                    to: ContactModule.Permissions.Forms.update
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
    )
        async throws -> Response
    {
        let (interactor, presenter) = buildRuntime((request, context))
        guard
            context.isCurrentUserAllowed(
                to: ContactModule.Permissions.Fields.create
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
                    to: ContactModule.Permissions.Forms.update
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
                let successPath =
                    formKey.map {
                        ContactAdminRoutes.formFields(RouterPath($0))
                            .description
                    } ?? "/admin/contact/fields/"
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
        catch let error as AdminAddContactFieldError {
            if case .createdButNotAssigned = error, let formKey {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath:
                                ContactAdminRoutes.formFields(
                                    RouterPath(formKey)
                                )
                                .description,
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
