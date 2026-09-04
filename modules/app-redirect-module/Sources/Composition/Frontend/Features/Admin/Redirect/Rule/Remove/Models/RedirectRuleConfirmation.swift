import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import RedirectAdminAPI
import SGML
import WebComponents
import WebBuilders

struct RedirectRuleConfirmation: Leaf {

    struct State {
        let id: String
        let source: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        return AdminConfirmationDialog(
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
        ).html()
    }
}
