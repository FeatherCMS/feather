import FeatherAdmin
import HTML
import Hummingbird
import OpenAPIRuntime

struct AdminRemoveWebPageDefaultController:
    AdminRemoveWebPageController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveWebPageInteractor,
            any AdminRemoveWebPagePresenter
        >

    func postRemoveWebPage(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let runtime = buildRuntime((request, context))
        let id = try context.requiredID()
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
        do {
            try await runtime.interactor.delete(id: id)
            return AdminNotificationFlash.redirect(
                to: "/admin/web/pages/",
                notification: .init(
                    title: "Removed",
                    message: "Web page removed successfully."
                )
            )
        }
        catch let error as OpenAPIRepositoryError {
            return try await runtime.presenter
                .renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
