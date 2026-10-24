import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Hummingbird

extension Invitation.Resend.Controller {

    struct Default: Sendable {
        let routes: Invitation.Router.Routes
        let buildRepository:
            @Sendable (AuthenticatedRequestContext) ->
                any Invitation.Resend.Repository.Interface

        func postResend(
            request: Request,
            context: AuthenticatedRequestContext
        ) async throws -> Response {
            let repository = buildRepository(context)
            do {
                try await repository.resend(id: context.requiredID())
                return Response(
                    status: .seeOther,
                    headers: [
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.invitations.path + "/",
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
                        .location: AdminNotificationRedirect.location(
                            defaultPath: routes.invitations.path + "/",
                            title: error.errorTitle,
                            message: error.errorDescription,
                            type: "error"
                        )
                    ]
                )
            }
        }
    }
}
