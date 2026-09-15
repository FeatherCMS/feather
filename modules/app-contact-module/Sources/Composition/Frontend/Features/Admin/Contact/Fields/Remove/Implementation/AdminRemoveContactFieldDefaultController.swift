import ContactContracts
import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AdminRemoveContactFieldDefaultController:
    AdminRemoveContactFieldController
{
    let buildRuntime:
        @Sendable (Request, DefaultRequestContext) -> (
            interactor: any AdminRemoveContactFieldInteractor,
            presenter: any AdminRemoveContactFieldPresenter
        )

    func confirm(request: Request, context: DefaultRequestContext) async throws
        -> HTMLResponse
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return try await presenter.renderForbiddenPage()
        }
        let id = try context.requiredParameter("fieldId")
        let field = try? await interactor.get(id: id)
        return try await presenter.renderConfirmation(
            fieldId: id,
            label: field?.label ?? id,
            permissions: context.currentUserPermissions
        )
    }

    func remove(request: Request, context: DefaultRequestContext) async throws
        -> Response
    {
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        try await interactor.remove(
            id: try context.requiredParameter("fieldId")
        )
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminNotificationRedirect.location(
                    defaultPath: "/admin/contact/fields/",
                    title: "Removed",
                    message: "Contact field removed successfully."
                )
            ]
        )
    }

    func confirmSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> HTMLResponse
    {
        let (_, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return try await presenter.renderForbiddenPage()
        }
        return try await presenter.renderConfirmation(
            selectedIds: request.queryStrings("selectedIds"),
            permissions: context.currentUserPermissions
        )
    }

    func removeSelected(request: Request, context: DefaultRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NewAdminListRemoveFormInput.self,
            context: context
        )
        let (interactor, presenter) = buildRuntime(request, context)
        guard context.isCurrentUserAllowed(to: ContactPermissions.Fields.delete)
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        try await interactor.remove(ids: payload.normalizedSelectedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/fields/",
                    page: payload.normalizedPage,
                    search: payload.normalizedSearch,
                    title: "Removed",
                    message: "Contact fields removed successfully."
                )
            ]
        )
    }

}
