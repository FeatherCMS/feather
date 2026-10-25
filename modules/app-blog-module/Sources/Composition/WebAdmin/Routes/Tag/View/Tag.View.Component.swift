import BlogModule
import FeatherModuleKit
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

import protocol SGML.BasicTag

extension Tag.View {
    struct Component: WebComponents.Component {
        struct State {
            let model: Model
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
                            .init(label: "Title", value: state.model.title)
                                .setAsRemoveConfirmationLabel(),
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
                                action: state.routes.tagStatusPath(
                                    state.model.id
                                ),
                                returnTo: state.routes.tagPath(state.model.id)
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
                        href: state.routes.tagEditPath(state.model.id),
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
                        href: state.routes.tagRemovePath(state.model.id),
                        style: .destructive,
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
