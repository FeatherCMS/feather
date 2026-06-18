import CSS
import FeatherValidation
import HTML
import Hummingbird
import SGML
import WebStandards

import struct Foundation.CharacterSet

struct BlogAuthorTable: Component {

    struct State {
        let isAdded: Bool
        let isEdited: Bool
        let isRemoved: Bool
        let isPublished: Bool
        let isUnpublished: Bool
        let canAccess: Bool
        let canEdit: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let rules: [AdminListBlogAuthorItemModel]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func selectors() -> [any Selector] {
        Custom(".cms-table td.blog-author-list-profile-cell") {
            Width(48.px)
            Padding(0)
            VerticalAlign(.middle)
            LineHeight(0)
            TextAlign(.center)
        }
        Custom(
            ".cms-table td.blog-author-list-profile-cell .blog-author-list-profile-image"
        ) {
            Width(24.px)
            Height(24.px)
            Display(.block)
            ObjectFit(.cover)
            ObjectPosition(.position(50.percent, 50.percent))
            BorderRadius(50.percent)
            MaxWidth(.none)
            Margin(.auto)
            Border(1.px, .solid, .variable("cms-gray-3"))
        }
        Custom(
            ".cms-table td.blog-author-list-profile-cell .blog-author-list-profile-placeholder"
        ) {
            Width(24.px)
            Height(24.px)
            Display(.grid)
            UnsafeRawProperty(name: "place-items", value: "center")
            BorderRadius(50.percent)
            Border(1.px, .solid, .variable("cms-gray-3"))
            Background(color: .color(.variable("cms-gray-1")))
            Color(.variable("cms-light-font"))
            FontSize(0.58.rem)
            Margin(.auto)
        }
    }

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("Blog authors")
                statusFormDefinitions()

                if state.isAdded {
                    P("Blog author added successfully.")
                }
                if state.isEdited {
                    P("Blog author edited successfully.")
                }
                if state.isRemoved {
                    P("Blog author removed successfully.")
                }
                if state.isPublished {
                    P("Blog author published successfully.")
                }
                if state.isUnpublished {
                    P("Blog author unpublished successfully.")
                }
                if state.canAdd {
                    Div {
                        AdminNavigationButton(
                            "Add author",
                            href: "/admin/blog/authors/add/"
                        )
                    }
                    .class("button-row")
                    Br()
                    Br()
                }
                ListTableSearchForm(
                    state: .init(
                        action: "/admin/blog/authors/",
                        placeholder: "Quick search blog authors",
                        search: state.search
                    )
                )

                if state.rules.isEmpty {
                    let totalPages = max(
                        1,
                        (state.total + state.pageSize - 1) / state.pageSize
                    )
                    if state.total > 0 && state.page > totalPages {
                        P("Page \(state.page) does not exist.")
                        P {
                            Span("Go to ")
                            A("page 1").href("/admin/blog/authors/?page=1")
                            Span(" or ")
                            A("page \(totalPages)")
                                .href(
                                    "/admin/blog/authors/?page=\(totalPages)"
                                )
                            Span(".")
                        }
                    }
                    else {
                        P(
                            state.search.isEmpty
                                ? "No blog authors yet."
                                : "No blog authors match your search."
                        )
                    }
                }
                else {
                    let canRemove = state.permissions.contains(
                        "blog:authors:delete"
                    )
                    ListTableBulkRemoveForm(
                        state: .init(
                            action: "/admin/blog/authors/bulk-remove/",
                            page: state.page,
                            search: state.search,
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
                                        Th("Profile")
                                        Th("Name")
                                        Th("Status")
                                        Th("Publication")
                                        Th("Expiration")
                                        Th("Actions")
                                    }
                                }
                                Tbody {
                                    for rule in state.rules {
                                        Tr {
                                            if canRemove {
                                                ListTableRowSelectCheckbox(
                                                    state: .init(
                                                        id: rule.id
                                                    )
                                                )
                                            }
                                            Td {
                                                if let profileImage = rule
                                                    .profileImage
                                                {
                                                    Img(
                                                        src: previewLink(
                                                            for: profileImage
                                                                .storageKey
                                                        ),
                                                        alt: profileImage
                                                            .altText
                                                            ?? profileImage
                                                            .title ?? rule.name
                                                    )
                                                    .class(
                                                        "blog-author-list-profile-image"
                                                    )
                                                }
                                                else {
                                                    Span("No image")
                                                        .class(
                                                            "blog-author-list-profile-placeholder"
                                                        )
                                                }
                                            }
                                            .class(
                                                "blog-author-list-profile-cell"
                                            )
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Profile"
                                            )
                                            titleCell(for: rule)
                                            statusCell(for: rule)
                                            Td(
                                                format(
                                                    rule.metadata
                                                        .publicationDate
                                                )
                                            )
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Publication"
                                            )
                                            Td(
                                                format(
                                                    rule.metadata.expirationDate
                                                )
                                            )
                                            .setAttribute(
                                                name: "data-label",
                                                value: "Expiration"
                                            )
                                            actionsCell(for: rule)
                                        }
                                    }
                                }
                            }
                            .class("cms-table", "action-table")
                            .if(canRemove) { $0.class("bulk-select-table") }
                        )
                    )
                    ListTablePagination(
                        state: .init(
                            path: "/admin/blog/authors/",
                            page: state.page,
                            pageSize: state.pageSize,
                            total: state.total,
                            search: state.search
                        )
                    )
                }
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

    private func actionsCell(
        for item: AdminListBlogAuthorItemModel
    ) -> some BasicTag {
        Td {
            if state.permissions.contains(
                AdminBlog.Scope.authors.permission(for: .read)
            ) {
                A("Details")
                    .href("/admin/blog/authors/\(item.id)/")
                    .class("row-btn")
                Span(" ")
            }
            if state.permissions.contains(
                AdminBlog.Scope.authors.permission(for: .update)
            ) {
                A("Edit")
                    .href("/admin/blog/authors/\(item.id)/edit/")
                    .class("row-btn", "edit")
                Span(" ")
            }
            if state.permissions.contains(
                AdminBlog.Scope.authors.permission(for: .delete)
            ) {
                A("Remove")
                    .href("/admin/blog/authors/\(item.id)/remove/")
                    .class("row-btn", "delete")
            }
        }
        .setAttribute(name: "data-label", value: "Actions")
        .class("action-cell")
    }

    private func titleCell(
        for item: AdminListBlogAuthorItemModel
    ) -> some BasicTag {
        Td {
            Span {
                Span(item.name)
                if let previewPath = previewPath(for: item.metadata) {
                    A {
                        Icon(svg: FeatherIcons.externalLink())
                    }
                    .href(previewPath)
                    .setAttribute(name: "target", value: "_blank")
                    .setAttribute(
                        name: "aria-label",
                        value: "Preview \(item.name)"
                    )
                    .style(
                        "display:inline-flex;align-items:center;justify-content:center;width:0.95rem;height:0.95rem;flex:0 0 auto;"
                    )
                }
            }
            .style(
                "display:inline-flex;align-items:center;gap:0.35rem;vertical-align:middle;line-height:1.25;position:relative;top:1px;"
            )
        }
        .setAttribute(name: "data-label", value: "Name")
    }

    private func statusCell(
        for item: AdminListBlogAuthorItemModel
    ) -> some BasicTag {
        Td {
            if state.canEdit {
                AdminStatusSelectField(
                    formID: statusFormID(for: item.id),
                    selectedStatus: item.metadata.normalizedStatus
                )
            }
            else {
                Span(item.metadata.status.capitalized)
            }
        }
        .setAttribute(name: "data-label", value: "Status")
    }

    private func statusFormDefinitions() -> some FlowContent {
        Div {
            if state.canEdit {
                for item in state.rules {
                    AdminStatusSelectFormDefinition(
                        id: statusFormID(for: item.id),
                        action: "/admin/blog/authors/\(item.id)/status/",
                        returnTo: "/admin/blog/authors/"
                    )
                }
            }
        }
        .style("display:none;")
    }

    private func statusFormID(
        for id: String
    ) -> String {
        "blog-author-status-\(id)"
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

    private func previewPath(
        for metadata: AdminMetadataFormValue
    ) -> String? {
        let slug = metadata.normalizedSlug
        return slug.isEmpty ? nil : "/\(slug)/"
    }
}
