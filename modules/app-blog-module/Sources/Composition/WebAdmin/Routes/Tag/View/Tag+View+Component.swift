import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModuleWebAdmin

import protocol SGML.BasicTag

extension Tag.View {
    struct Component: WebComponents.Component {
        struct State {
            let model: Tag.View.Model
            let breadcrumb: [AdminBreadcrumb.Link]
            let permissions: Set<String>
            let routes: Tag.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminDetailView(
                        breadcrumb: state.breadcrumb,
                        pageHeader: .primary(
                            title: "Blog tag details",
                            description: "Review the blog tag configuration."
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
                            .init(label: "Content", value: state.model.content),
                        ],
                        actions: actions
                    )
                )
                if state.permissions.contains(
                    Tag.Permissions.update.rawValue
                ) {
                    let formID = "blog-tag-status-\(state.model.id)"
                    Div {
                        context.build(
                            AdminStatusSelectFormDefinition(
                                id: formID,
                                action: state.routes.tagStatus(state.model.id),
                                returnTo: state.routes.tag(state.model.id)
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
                Tag.Permissions.update.rawValue
            ) {
                result.append(
                    .init(
                        label: "Edit tag",
                        href: state.routes.tagEdit(state.model.id),
                        style: .primary
                    )
                )
            }
            if state.permissions.contains(
                Tag.Permissions.delete.rawValue
            ) {
                result.append(
                    .init(
                        label: "Remove tag",
                        href: state.routes.tagRemove(state.model.id),
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
