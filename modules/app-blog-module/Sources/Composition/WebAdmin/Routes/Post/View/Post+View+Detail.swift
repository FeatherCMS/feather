import BlogAdminAPI
import BlogAppAPI
import BlogModule
import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebModuleWebAdmin

extension Post.View.Detail {
    struct Component: WebComponents.Component {
        struct State {
            let rule: Model
            let breadcrumb: [AdminBreadcrumb.Link]
            let permissions: Set<String>
            let routes: Post.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminDetailView(
                        breadcrumb: state.breadcrumb,
                        pageHeader: .primary(
                            title: "Blog post details",
                            description: "Review the blog post configuration."
                        ),
                        fields: [
                            .init(label: "Title", value: state.rule.title),
                            .init(
                                label: "Status",
                                value: state.rule.metadata.status.capitalized
                            ),
                            .init(
                                label: "Published date",
                                value: format(
                                    state.rule.metadata.publicationDate
                                )
                            ),
                            .init(
                                label: "Expiration date",
                                value: format(
                                    state.rule.metadata.expirationDate
                                )
                            ),
                            .init(
                                label: "Authors",
                                value: state.rule.authorIds.isEmpty
                                    ? "None"
                                    : state.rule.authorIds.joined(
                                        separator: ", "
                                    )
                            ),
                            .init(
                                label: "Tags",
                                value: state.rule.tagIds.isEmpty
                                    ? "None"
                                    : state.rule.tagIds.joined(separator: ", ")
                            ),
                            .init(label: "Content", value: state.rule.content),
                        ],
                        actions: actions
                    )
                )
                if state.permissions.contains(
                    Post.Permissions.update.rawValue
                ) {
                    let formID = "blog-post-status-\(state.rule.id)"
                    Div {
                        context.build(
                            AdminStatusSelectFormDefinition(
                                id: formID,
                                action:
                                    state.routes
                                    .postStatus(
                                        RouterPath(state.rule.id)
                                    )
                                    .description,
                                returnTo:
                                    state.routes
                                    .post(RouterPath(state.rule.id))
                                    .description
                            )
                        )
                        context.build(
                            AdminStatusSelectField(
                                formID: formID,
                                selectedStatus: state.rule.metadata
                                    .normalizedStatus
                            )
                        )
                    }
                    .class("admin-detail-actions")
                }
            }
            .class("cms-section")
        }

        private var actions: [AdminDetailView.Action] {
            var result: [AdminDetailView.Action] = []
            if state.permissions.contains(
                Post.Permissions.update.rawValue
            ) {
                result.append(
                    .init(
                        label: "Edit post",
                        href: state.routes
                            .postEdit(RouterPath(state.rule.id))
                            .description,
                        style: .primary
                    )
                )
            }
            if state.permissions.contains(
                Post.Permissions.delete.rawValue
            ) {
                result.append(
                    .init(
                        label: "Remove post",
                        href: state.routes
                            .postRemove(RouterPath(state.rule.id))
                            .description,
                        style: .destructive
                    )
                )
            }
            return result
        }

        private func format(_ value: String) -> String {
            guard
                let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
            else { return "-" }
            return DateFormatting.formatUnixTimestamp(timestamp)
        }
    }
}
