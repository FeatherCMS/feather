import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

struct AdminRemoveAccountInvitationDefaultController:
    AdminRemoveAccountInvitationController
{
    let buildRuntime:
        AuthenticatedRuntimeBuilder<
            any AdminRemoveAccountInvitationInteractor,
            any AdminRemoveAccountInvitationPresenter
        >


    func postRemoveAccountInvitation(
        request: Request,
        context: AuthenticatedRequestContext
    ) async throws -> Response {
        let (interactor, presenter) = buildRuntime((request, context))
        let nonceRequest = try await request.decode(
            as: NonceRequest<AdminListRemoveFormInput>.self,
            context: context
        )
        guard
            await AdminNonceStore.shared.consume(
                nonceRequest.nonce,
                sessionToken: context.sessionToken
            )
        else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: AccountAdminRoutes.invitations.description,
                        title: "Expired",
                        message:
                            "This form has expired. Please reload the page."
                    )
                ]
            )
        }
        let ids = nonceRequest.input.normalizedIds
        guard !ids.isEmpty else {
            return Response(
                status: .seeOther,
                headers: [.location: AccountAdminRoutes.invitations.description]
            )
        }
        do {
            try await interactor.execute(ids: ids)
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: "/admin/account/invitations/",
                        title: "Removed",
                        message: ids.count == 1
                            ? "User invitation removed successfully."
                            : "User invitations removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try await presenter.renderErrorPage(
                    id: ids[0],
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
