import BlogAdminAPI
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

extension Author.View {
    struct Component: WebComponents.Component {
        struct State {
            let author: Model
            let breadcrumb: [AdminBreadcrumb.Link]
            let permissions: Set<String>
            let routes: Author.Router.Routes
            let authorLinkRoutes: AuthorLink.Router.Routes
        }
        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminDetailView(
                        breadcrumb: state.breadcrumb,
                        pageHeader: .primary(
                            title: "Blog author details",
                            description:
                                "Review the author profile and publishing settings."
                        ),
                        fields: [
                            .init(label: "Name", value: state.author.name),
                            .init(
                                label: "Status",
                                value: state.author.metadata.status.capitalized
                            ),
                            .init(
                                label: "Published date",
                                value: format(
                                    state.author.metadata.publicationDate
                                )
                            ),
                            .init(
                                label: "Expiration date",
                                value: format(
                                    state.author.metadata.expirationDate
                                )
                            ),
                            .init(
                                label: "Content",
                                value: state.author.content
                            ),
                        ],
                        actions: actions
                    )
                )
                if state.permissions.contains(
                    Author.Permissions.update.rawValue
                ) {
                    let formID = "blog-author-status-\(state.author.id)"
                    Div {
                        context.build(
                            AdminStatusSelectFormDefinition(
                                id: formID,
                                action: state.routes.authorStatusPath(
                                    state.author.id
                                ),
                                returnTo: state.routes.authorPath(state.author.id)
                            )
                        )
                        context.build(
                            AdminStatusSelectField(
                                formID: formID,
                                selectedStatus: state.author.metadata
                                    .normalizedStatus
                            )
                        )
                    }
                    .class("admin-detail-actions")
                }
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Author links",
                            description: "Manage links shown for this author."
                        )
                    )
                )
                if state.permissions.contains(
                    AuthorLink.Permissions.create.rawValue
                ) {
                    context.build(
                        AdminButton(
                            "Add link",
                            href:
                                state.authorLinkRoutes
                                .authorLinkAddPath(state.author.id)
                        )
                    )
                }
                context.build(
                    AuthorLink.List.TableContent(
                        state: .init(
                            authorID: state.author.id,
                            canAdd: state.permissions.contains(
                                AuthorLink.Permissions.create
                                    .rawValue
                            ),
                            items: state.author.items,
                            pageState: .init(
                                page: 1,
                                pageSize: max(1, state.author.items.count),
                                total: state.author.items.count
                            ),
                            search: "",
                            permissions: AdminListActions(
                                Set(state.permissions.map(PermissionKey.init))
                            ),
                            routes: state.authorLinkRoutes
                        )
                    )
                )
            }
            .class("cms-section")
        }

        private var actions: [AdminDetailView.Action] {
            var result: [AdminDetailView.Action] = []
            if state.permissions.contains(
                Author.Permissions.update.rawValue
            ) {
                result.append(
                    .init(
                        label: "Edit author",
                        href: state.routes.authorEditPath(state.author.id),
                        style: .primary
                    )
                )
            }
            if state.permissions.contains(
                Author.Permissions.delete.rawValue
            ) {
                result.append(
                    .init(
                        label: "Remove author",
                        href: state.routes.authorRemovePath(state.author.id),
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
