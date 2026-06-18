import Foundation
import HTML
import SGML
import WebStandards

struct BlogAuthorDetails: Component {
    struct State {
        let author: BlogAuthorDetailsModel
        let breadcrumb: AdminBreadcrumb.State
        let permissions: Set<String>
        let isPublished: Bool
        let isUnpublished: Bool
        let isAdded: Bool
        let isRemoved: Bool
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            AdminDetailFieldStyleAnchor()
            AdminBreadcrumb(state: state.breadcrumb)
            H1("Blog author details")
            if state.isPublished {
                P("Blog author published successfully.")
            }
            if state.isUnpublished {
                P("Blog author unpublished successfully.")
            }
            if let profileImage = state.author.profileImage {
                Div {
                    P("Profile picture")
                        .class("admin-details-field__label")
                    P {
                        A(
                            profileImage.title ?? profileImage.altText
                                ?? profileImage.id
                        )
                        .href(previewLink(for: profileImage.storageKey))
                        .setAttribute(name: "target", value: "_blank")
                    }
                    .class("admin-details-field__value")
                }
                .class("admin-details-field")
                Img(
                    src: previewLink(for: profileImage.storageKey),
                    alt: profileImage.altText ?? profileImage.title
                        ?? state.author.name
                )
                .style(
                    "display:block;width:120px;height:120px;object-fit:cover;border-radius:18px;border:1px solid var(--cms-gray-3);"
                )
            }
            else if let profileImageAssetId = state.author.profileImageAssetId {
                AdminDetailsField(
                    label: "Profile picture asset ID",
                    value: profileImageAssetId
                )
            }
            AdminDetailsField(label: "ID", value: state.author.id)
            AdminDetailsField(label: "Name", value: state.author.name)
            AdminDetailsField(
                label: "Status",
                value: state.author.metadata.status.capitalized
            )
            AdminDetailsField(
                label: "Published date",
                value: format(state.author.metadata.publicationDate)
            )
            AdminDetailsField(
                label: "Expiration date",
                value: format(state.author.metadata.expirationDate)
            )
            AdminDetailsField(label: "Content", value: state.author.content)

            Div {
                if let previewPath = previewPath {
                    A("Preview")
                        .href(previewPath)
                        .setAttribute(name: "target", value: "_blank")
                        .class("secondary")
                }
                if state.permissions.contains(
                    AdminBlog.Scope.authors.permission(for: .update)
                ) {
                    AdminStatusActionForm(
                        action:
                            "/admin/blog/authors/\(state.author.id)/status/",
                        returnTo: "/admin/blog/authors/\(state.author.id)/",
                        status: state.author.metadata.normalizedStatus
                            == "published"
                            ? "draft"
                            : "published",
                        label: state.author.metadata.normalizedStatus
                            == "published"
                            ? "Unpublish"
                            : "Publish",
                        classes: ["secondary"]
                    )
                    AdminNavigationButton(
                        "Edit author",
                        href: "/admin/blog/authors/\(state.author.id)/edit/"
                    )
                }
                if state.permissions.contains(
                    AdminBlog.Scope.authors.permission(for: .delete)
                ) {
                    AdminNavigationButton(
                        "Remove author",
                        href: "/admin/blog/authors/\(state.author.id)/remove/",
                        classes: ["danger"]
                    )
                }
            }
            .class(
                "button-row",
                "blog-author-details-actions",
                "admin-detail-actions"
            )

            H2("Link")
            if state.isAdded {
                P("Link added successfully.")
            }
            if state.isRemoved {
                P("Link removed successfully.")
            }
            if state.permissions.contains(
                AdminBlog.Scope.authorLinks.permission(for: .create)
            ) {
                Div {
                    AdminNavigationButton(
                        "Add link",
                        href:
                            "/admin/blog/authors/\(state.author.id)/links/add/"
                    )
                }
                .class("button-row", "blog-author-details-link-add")
            }
            if state.author.items.isEmpty {
                P("No author links found for this author.")
            }
            else {
                let canRemove = state.permissions.contains(
                    "blog:author-links:delete"
                )
                ListTableBulkRemoveForm(
                    state: .init(
                        action:
                            "/admin/blog/authors/\(state.author.id)/links/bulk-remove/",
                        page: 1,
                        search: "",
                        canRemove: canRemove,
                        buttonTitle: "Remove selected"
                    ),
                    table: ListTableShell(
                        table: Table {
                            Thead {
                                Tr {
                                    if canRemove {
                                        ListTableSelectAllCheckbox()
                                    }
                                    Th("Label")
                                    Th("URL")
                                    Th("Priority")
                                    Th("Blank")
                                    Th("Permission")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                for item in state.author.items {
                                    Tr {
                                        if canRemove {
                                            ListTableRowSelectCheckbox(
                                                state: .init(id: item.id)
                                            )
                                        }
                                        Td(item.label)
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Label"
                                            )
                                        Td(item.url)
                                            .setAttribute(
                                                name: "data-label",
                                                value: "URL"
                                            )
                                        Td("\(item.priority)")
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Priority"
                                            )
                                        Td(item.isBlank ? "Yes" : "No")
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Blank"
                                            )
                                        Td(item.permission)
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Permission"
                                            )
                                        ListTableRowActions(
                                            state: .init(
                                                label: "Actions",
                                                actions: [
                                                    .init(
                                                        title: "Details",
                                                        href:
                                                            "/admin/blog/authors/\(state.author.id)/links/\(item.id)/",
                                                        className: nil,
                                                        permission:
                                                            "blog:author-links:read"
                                                    ),
                                                    .init(
                                                        title: "Edit",
                                                        href:
                                                            "/admin/blog/authors/\(state.author.id)/links/\(item.id)/edit/",
                                                        className: "edit",
                                                        permission:
                                                            "blog:author-links:update"
                                                    ),
                                                    .init(
                                                        title: "Remove",
                                                        href:
                                                            "/admin/blog/authors/\(state.author.id)/links/\(item.id)/remove/",
                                                        className: "delete",
                                                        permission:
                                                            "blog:author-links:delete"
                                                    ),
                                                ],
                                                permissions: state.permissions
                                            )
                                        )
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(canRemove) { $0.class("bulk-select-table") }
                    )
                )
            }
        }
        .class("cms-section")
    }

    private func previewLink(
        for storageKey: String
    ) -> String {
        let prefix = "media/assets/"
        let normalizedKey =
            storageKey.hasPrefix(prefix)
            ? String(storageKey.dropFirst(prefix.count))
            : storageKey
        let allowed = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~"
        )
        let encoded =
            normalizedKey.addingPercentEncoding(withAllowedCharacters: allowed)
            ?? normalizedKey
        return
            "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)/media/assets/\(encoded)"
    }

    private var previewPath: String? {
        let slug = state.author.metadata.normalizedSlug
        return slug.isEmpty ? nil : "/\(slug)/"
    }

    private func format(
        _ value: String
    ) -> String {
        guard let timestamp = AdminMetadataSchemaBuilder.parseTimestamp(value)
        else {
            return "-"
        }
        return DateFormatting.formatUnixTimestamp(timestamp)
    }
}
