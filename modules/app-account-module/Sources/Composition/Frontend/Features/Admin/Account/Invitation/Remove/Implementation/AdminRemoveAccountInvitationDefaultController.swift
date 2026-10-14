import FeatherAdmin
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
        else {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath:
                            AccountAdminRoutes.invitationRemove(RouterPath(id))
                            .description,
                        title: "Expired",
                        message:
                            "This form has expired. Please reload the page."
                    )
                ]
            )
        }
        do {
            try await interactor.execute(
                entity: .init(id: id)
            )
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminNotificationRedirect.location(
                        defaultPath: "/admin/account/invitations/",
                        title: "Removed",
                        message: "User invitation removed successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return
                try await presenter.renderErrorPage(
                    id: id,
                    info: error.errorTitle,
                    message: error.errorDescription
                )
                .response(from: request, context: context)
        }
    }
}
