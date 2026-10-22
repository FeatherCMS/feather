import AccountModule
import FeatherWebAdmin

extension Invitation.Detail.Presenter {

    protocol Interface: Sendable {

        func renderDetailsPage(
            invitation: AccountInvitationDetailsModel,
            permissions: Set<String>
        ) async throws -> HTMLResponse

        func renderErrorPage(
            info: String,
            message: String,
            permissions: Set<String>
        ) async throws -> HTMLResponse

    }
}
