import FeatherAdmin
import HTML
import SGML
import WebComponents
import WebBuilders

struct AuthSessionRemoveConfirmation: Leaf {

    struct State {
        let model: AdminRemoveAuthSessionModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        return AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove session",
                message:
                    "Are you sure you want to remove this session? This action will sign the session out immediately.",
                details: [
                    .init(
                        prefix: "Identity: ",
                        value: state.model.identityEmail
                    ),
                    .init(prefix: "Session ID: ", value: state.model.sessionId),
                    .init(
                        prefix: "Persistent: ",
                        value: state.model.isPersistent ? "Yes" : "No"
                    ),
                    .init(
                        prefix: "Expires: ",
                        value: DateFormatting.formatUnixTimestamp(
                            state.model.expiresAt
                        )
                    ),
                ],
                submitLabel: "Remove session",
                actionURL:
                    "/admin/user/identities/\(state.model.identityId)/sessions/\(state.model.sessionId)/remove/",
                cancelURL: "/admin/user/identities/\(state.model.identityId)/"
            )
        ).html()
    }
}
