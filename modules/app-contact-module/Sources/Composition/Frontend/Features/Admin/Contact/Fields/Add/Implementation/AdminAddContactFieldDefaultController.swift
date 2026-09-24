import ContactContracts
import FeatherAdmin
import FeatherValidation
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
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.create)
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
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.create)
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
                payload: payload
            )
            if model.fieldErrors.isEmpty {
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: "/admin/contact/fields/",
                            title: "Added",
                            message: "Form field added successfully."
                        )
                    ]
                )
            }
            return try await presenter.renderPage(
                model: model,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
        }
        catch let error as AdminAddContactFieldError {
            return try await presenter.renderAddError(
                input: payload,
                error: error,
                permissions: context.currentUserPermissions
            )
            .response(from: request, context: context)
        }
    }
}
