import AdminOpenAPI
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

struct RedirectRuleConfirmation: Component {

    struct State {
        let id: String
        let source: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        AdminConfirmationDialog(
            state: .init(
                breadcrumb: state.breadcrumb,
                title: "Remove redirect rule",
                message:
                    "Are you sure you want to remove this redirect rule? This action cannot be undone.",
                details: [
                    .init(prefix: "Source: ", value: state.source)
                ],
                submitLabel: "Remove rule",
                actionURL: "/admin/redirect/rules/\(state.id)/remove/",
                cancelURL: "/admin/redirect/rules/"
            )
        )
    }
}
