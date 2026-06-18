import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserAccountConfirmation: Component {

    struct State {
        let id: String
        let email: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove account",
                message:
                    "Are you sure you want to remove this account? This action cannot be undone.",
                details: [
                    .init(prefix: "Email: ", value: state.email)
                ],
                submitLabel: "Remove account",
                actionURL: "/admin/user/accounts/\(state.id)/remove/",
                cancelURL: "/admin/user/accounts/"
            )
        )
    }
}
