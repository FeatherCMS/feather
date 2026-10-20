import BlogAdminAPI
import BlogAppAPI
import FeatherWebAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaFrontend
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct AdminRemoveBlogAuthorLinkDefaultController:
    AdminRemoveBlogAuthorLinkController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveBlogAuthorLinkInteractor,
            any AdminRemoveBlogAuthorLinkPresenter
        >

    func postRemoveBlogAuthorLink(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        let menuId = try context.requiredID()
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
        let ids = nonceRequest.input.normalizedSelectedIds
        let location = AdminLocation.url(
            path: BlogAdminRoutes.author(RouterPath(menuId)).description,
            page: nonceRequest.input.normalizedPage,
            search: nonceRequest.input.normalizedSearch
        )
        guard !ids.isEmpty else {
            return Response(status: .seeOther, headers: [.location: location])
        }
        do {
            try await runtime.interactor.delete(menuId: menuId, ids: ids)
            return AdminNotificationFlash.redirect(
                to: location,
                notification: .init(
                    title: "Removed",
                    message: ids.count == 1
                        ? "Link removed successfully."
                        : "Links removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    menuId: menuId,
                    id: ids[0],
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
