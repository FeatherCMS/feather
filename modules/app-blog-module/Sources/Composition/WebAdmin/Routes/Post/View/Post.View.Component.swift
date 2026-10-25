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
import WebModule
import WebModuleWebAdmin

extension Post.View {
    struct Component: WebComponents.Component {
        struct State {
            let model: Model
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
                            .init(label: "Title", value: state.model.title),
                            .init(
                                label: "Status",
                                value: state.model.metadata.status.capitalized
                            ),
                            .init(
                                label: "Published date",
                                value: format(
                                    state.model.metadata.publicationDate
                                )
                            ),
                            .init(
                                label: "Expiration date",
                                value: format(
                                    state.model.metadata.expirationDate
                                )
                            ),
                            .init(
                                label: "Authors",
                                value: state.model.authorIds.isEmpty
                                    ? "None"
                                    : state.model.authorIds.joined(
                                        separator: ", "
                                    )
                            ),
                            .init(
                                label: "Tags",
                                value: state.model.tagIds.isEmpty
                                    ? "None"
                                    : state.model.tagIds.joined(separator: ", ")
                            ),
                            .init(label: "Content", value: state.model.content),
                        ],
                        actions: actions
                    )
                )
                if state.permissions.contains(
                    Post.Permissions.update.rawValue
                ) {
                    let formID = "blog-post-status-\(state.model.id)"
                    Div {
                        context.build(
                            AdminStatusSelectFormDefinition(
                                id: formID,
                                action: state.routes.postStatusPath(state.model.id),
                                returnTo: state.routes.postPath(state.model.id)
                            )
                        )
                        context.build(
                            AdminStatusSelectField(
                                formID: formID,
                                selectedStatus: state.model.metadata
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
                        href: state.routes.postEditPath(state.model.id),
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
                        href: state.routes.postRemovePath(state.model.id),
                        style: .destructive
                    )
                )
            }
            return result
        }

        private func format(_ value: String) -> String {
            guard
                let timestamp = WebModule.Metadata.SchemaBuilder.parseTimestamp(
                    value
                )
            else { return "-" }
            return DateFormatting.formatUnixTimestamp(timestamp)
        }
    }
}
