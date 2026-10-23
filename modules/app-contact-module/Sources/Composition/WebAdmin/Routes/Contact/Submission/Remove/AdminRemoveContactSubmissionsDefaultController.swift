import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminRemoveContactSubmissionsDefaultController:
    AdminRemoveContactSubmissionsController
{
    let buildRuntime:
        @Sendable (Request, AuthenticatedRequestContext) -> WebAdminRuntime<
            any AdminRemoveContactSubmissionsInteractor,
            any AdminRemoveContactSubmissionsPresenter
        >
    func remove(request: Request, context: AuthenticatedRequestContext)
        async throws
        -> Response
    {
        let payload = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                payload.nonce,
                sessionToken: context.sessionToken
            )
        else { return Response(status: .badRequest) }
        let interactor = buildRuntime(request, context).interactor
        try await interactor.remove(ids: payload.input.normalizedIds)
        return Response(
            status: .seeOther,
            headers: [
                .location: AdminListRemoveRedirect.location(
                    path: "/admin/contact/submissions/",
                    page: payload.input.normalizedPage,
                    search: payload.input.normalizedSearch,
                    title: "Removed",
                    message: "Contact submissions removed successfully."
                )
            ]
        )
    }
}
