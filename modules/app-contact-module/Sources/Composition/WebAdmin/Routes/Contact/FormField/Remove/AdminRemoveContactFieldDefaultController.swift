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

struct AdminRemoveContactFieldDefaultController:
    AdminRemoveContactFieldController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminRemoveContactFieldInteractor,
            any AdminRemoveContactFieldPresenter
        >


    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let __runtimeBuild1 = buildRuntime(request, context)
        let interactor = __runtimeBuild1.interactor
        let presenter = __runtimeBuild1.presenter
        guard context.isCurrentUserAllowed(to: FormField.Permissions.delete)
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
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


    func removeSelected(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        let __runtimeBuild2 = buildRuntime(request, context)
        let interactor = __runtimeBuild2.interactor
        let presenter = __runtimeBuild2.presenter
        guard context.isCurrentUserAllowed(to: FormField.Permissions.delete)
        else {
            return
                try await presenter
                .renderForbiddenPage()
                .response(from: request, context: context)
        }
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return Response(status: .badRequest)
        }
        try await interactor.remove(ids: payload.input.normalizedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/fields/",
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch,
                    title: "Removed",
                    message: "Contact fields removed successfully."
                )
            ]
        )
    }

}
