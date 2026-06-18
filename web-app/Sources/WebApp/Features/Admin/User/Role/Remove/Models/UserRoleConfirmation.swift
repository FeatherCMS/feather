import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct UserRoleConfirmation: Component {

    struct State {
        let id: String
        let name: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove user role",
                message:
                    "Are you sure you want to remove this user role? This action cannot be undone.",
                details: [
                    .init(prefix: "Name: ", value: state.name)
                ],
                submitLabel: "Remove role",
                actionURL: "/admin/user/roles/\(state.id)/remove/",
                cancelURL: "/admin/user/roles/"
            )
        )
    }
}
