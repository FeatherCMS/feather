import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents

extension AuthorLink.View {
    struct Component: WebComponents.Component {
        struct State {
            let model: AuthorLink.Detail.Model
            let breadcrumb: [AdminBreadcrumb.Link]
            let permissions: Set<String>
            let routes: AuthorLink.Router.Routes
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
                            .init(label: "Label", value: state.model.label),
                            .init(label: "URL", value: state.model.url),
                            .init(
                                label: "Priority",
                                value: "\(state.model.priority)"
                            ),
                            .init(
                                label: "Blank target",
                                value: state.model.isBlank ? "Yes" : "No"
                            ),
                            .init(
                                label: "Permission",
                                value: state.model.permission
                            ),
                            .init(label: "Notes", value: state.model.notes),
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
                AuthorLink.Permissions.update.rawValue
            ) {
                result.append(
                    .init(
                        label: "Edit link",
                        href: state.routes
                            .authorLinkEdit(
                                RouterPath(state.model.authorID),
                                RouterPath(state.model.id)
                            )
                            .description,
                        style: .primary
                    )
                )
            }
            if state.permissions.contains(
                AuthorLink.Permissions.delete.rawValue
            ) {
                result.append(
                    .init(
                        label: "Remove link",
                        href: AdminLocation.remove(
                            path: state.routes
                                .authorLinkRemove(
                                    RouterPath(state.model.authorID)
                                )
                                .description,
                            ids: [state.model.id],
                            returnTo: state.routes
                                .authorLinks(
                                    RouterPath(state.model.authorID)
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
}
