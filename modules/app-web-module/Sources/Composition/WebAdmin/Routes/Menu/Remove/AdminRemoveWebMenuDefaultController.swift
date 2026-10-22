import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebMenuDefaultController:
    AdminRemoveWebMenuController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveWebMenuInteractor,
            any AdminRemoveWebMenuPresenter
        >

    func postRemoveWebMenu(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
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
        let ids = nonceRequest.input.normalizedIds
        let location = AdminLocation.url(
            path: WebMenuRoutes.list.description,
            page: nonceRequest.input.normalizedPage,
            search: nonceRequest.input.normalizedSearch
        )
        guard !ids.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        do {
            try await runtime.interactor.delete(ids: ids)
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: ids.count == 1
                        ? "Menu removed successfully."
                        : "Menus removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    id: ids[0],
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
