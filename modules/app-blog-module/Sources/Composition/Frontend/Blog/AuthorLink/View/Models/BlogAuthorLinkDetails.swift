import BlogAdminAPI
import BlogContracts
import FeatherAdmin
import FeatherContracts
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct BlogAuthorLinkDetails: Component {
    struct State {
        let rule: BlogAuthorLinkDetailsModel
        let breadcrumb: [NewAdminBreadcrumb.Link]
        let permissions: Set<String>
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                NewAdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .init(
                        title: "Blog author link details",
                        description: "Review this author link."
                    ),
                    fields: [
                        .init(label: "Label", value: state.rule.label),
                        .init(label: "URL", value: state.rule.url),
                        .init(
                            label: "Priority",
                            value: "\(state.rule.priority)"
                        ),
                        .init(
                            label: "Blank target",
                            value: state.rule.isBlank ? "Yes" : "No"
                        ),
                        .init(
                            label: "Permission",
                            value: state.rule.permission
                        ),
                        .init(label: "Notes", value: state.rule.notes),
                    ],
                    actions: actions
                )
            )
        }
        .class("cms-section")
    }

    private var actions: [NewAdminDetailView.Action] {
        var result: [NewAdminDetailView.Action] = []
        if state.permissions.contains(
            BlogPermissions.AuthorLinks.update.rawValue
        ) {
            result.append(
                .init(
                    label: "Edit link",
                    href:
                        BlogAdminRoutes.authorLinkEdit(
                            RouterPath(state.rule.menuId),
                            RouterPath(state.rule.id)
                        )
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.contains(
            BlogPermissions.AuthorLinks.delete.rawValue
        ) {
            result.append(
                .init(
                    label: "Remove link",
                    href: NewAdminLocation.remove(
                        path:
                            BlogAdminRoutes.authorLinkRemove(
                                RouterPath(state.rule.menuId)
                            )
                            .description,
                        ids: [state.rule.id],
                        returnTo:
                            BlogAdminRoutes.authorLinks(
                                RouterPath(state.rule.menuId)
                            )
                            .description
                    ),
                    style: .destructive
                )
            )
        }
        return result
    }
}
