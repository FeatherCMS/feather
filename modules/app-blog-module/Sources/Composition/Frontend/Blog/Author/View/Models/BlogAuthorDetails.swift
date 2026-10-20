import BlogAdminAPI
import BlogContracts
import FeatherWebAdmin
import FeatherModuleKit
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebFrontend

struct BlogAuthorDetails: Component {
    struct State {
        let author: BlogAuthorDetailsModel
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
                            value: format(state.author.metadata.publicationDate)
                        ),
                        .init(
                            label: "Expiration date",
                            value: format(state.author.metadata.expirationDate)
                        ),
                        .init(label: "Content", value: state.author.content),
                    ],
                    actions: actions
                )
            )
            if state.permissions.contains(
                BlogPermissions.Authors.update.rawValue
            ) {
                let formID = "blog-author-status-\(state.author.id)"
                Div {
                    context.build(
                        AdminStatusSelectFormDefinition(
                            id: formID,
                            action:
                                BlogAdminRoutes.authorStatus(
                                    RouterPath(state.author.id)
                                )
                                .description,
                            returnTo:
                                BlogAdminRoutes.author(
                                    RouterPath(state.author.id)
                                )
                                .description
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
                BlogPermissions.AuthorLinks.create.rawValue
            ) {
                context.build(
                    AdminButton(
                        "Add link",
                        href:
                            BlogAdminRoutes.authorLinkAdd(
                                RouterPath(state.author.id)
                            )
                            .description
                    )
                )
            }
            context.build(
                BlogAuthorLinkTableContent(
                    state: .init(
                        authorId: state.author.id,
                        canAccess: true,
                        canAdd: state.permissions.contains(
                            BlogPermissions.AuthorLinks.create.rawValue
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
                        breadcrumb: BlogAdminRoutes.authorLinksBreadcrumb(
                            RouterPath(state.author.id)
                        ),
                        error: nil
                    )
                )
            )
        }
        .class("cms-section")
    }

    private var actions: [AdminDetailView.Action] {
        var result: [AdminDetailView.Action] = []
        if state.permissions.contains(BlogPermissions.Authors.update.rawValue) {
            result.append(
                .init(
                    label: "Edit author",
                    href:
                        BlogAdminRoutes.authorEdit(RouterPath(state.author.id))
                        .description,
                    style: .primary
                )
            )
        }
        if state.permissions.contains(BlogPermissions.Authors.delete.rawValue) {
            result.append(
                .init(
                    label: "Remove author",
                    href:
                        BlogAdminRoutes.authorRemove(
                            RouterPath(state.author.id)
                        )
                        .description,
                    style: .destructive
                )
            )
        }
        return result
    }

    private func format(_ value: String) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
        else { return "-" }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
