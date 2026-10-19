import BlogAdminAPI
import BlogContracts
import FeatherAdmin
import FeatherModuleKit
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

struct BlogAuthorLinkDetails: Component {
    struct State {
        let rule: BlogAuthorLinkDetailsModel
        let breadcrumb: [AdminBreadcrumb.Link]
        let permissions: Set<String>
    }
    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            context.build(
                AdminDetailView(
                    breadcrumb: state.breadcrumb,
                    pageHeader: .primary(
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

    private var actions: [AdminDetailView.Action] {
        var result: [AdminDetailView.Action] = []
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
                    href: AdminLocation.remove(
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
