import FeatherAdmin
import Hummingbird

struct AdminResendAccountInvitationDefaultController: Sendable {
    let buildRepository:
        @Sendable (DefaultRequestContext) ->
            any AdminResendAccountInvitationRepository

    func resend(
        request: Request,
        context: DefaultRequestContext
    ) async throws -> Response {
        let repository = buildRepository(context)
        do {
            try await repository.resend(id: context.requiredID())
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/account/invitations/",
                        title: "Sent",
                        message: "Invitation email resent successfully."
                    )
                ]
            )
        }
        catch let error as OpenAPIRepositoryError {
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/account/invitations/",
                        title: error.errorTitle,
                        message: error.errorDescription,
                        type: "error"
                    )
                ]
            )
        }
    }
}
