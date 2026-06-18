import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct SystemPermissionConfirmation: Component {

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
                title: "Remove system permission",
                message:
                    "Are you sure you want to remove this system permission? This action cannot be undone.",
                details: [
                    .init(prefix: "Name: ", value: state.name)
                ],
                submitLabel: "Remove permission",
                actionURL: "/admin/system/permissions/\(state.id)/remove/",
                cancelURL: "/admin/system/permissions/"
            )
        )
    }
}
