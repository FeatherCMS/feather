import HTML
import SGML
import WebStandards

struct UserAccountSessionConfirmation: Component {

    struct State {
        let model: AdminRemoveUserAccountSessionModel
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove session",
                message:
                    "Are you sure you want to remove this session? This action will sign the session out immediately.",
                details: [
                    .init(prefix: "Account: ", value: state.model.accountEmail),
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
                    "/admin/user/accounts/\(state.model.accountId)/sessions/\(state.model.sessionId)/remove/",
                cancelURL: "/admin/user/accounts/\(state.model.accountId)/"
            )
        )
    }
}
