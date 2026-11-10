import FeatherModuleKit
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import HTML
import Hummingbird
import MediaWebAdmin
import NewsApplication
import NewsModule
import SGML
import WebBuilders
import WebComponents
import WebModule
import WebModuleWebAdmin

extension NewsModule.Article.List {
    struct Page: Component {
        let model: NewsModule.Article.List.Model
        let search: String
        let status: AdminMetadataStatus?
        let error: String?
        let permissions: AdminListActions
        let canAccess: Bool
        let routes: NewsModule.Article.Router.Routes
        let dateFormatter: AdminDateFormatter

        func html(
            context: inout BuilderContext
        ) -> some BasicTag {
            let path = routes.list.path
            return Section {
                context.build(
                    AdminBreadcrumb(links: routes.breadcrumb)
                )
                if canAccess {
                    context.build(
                        AdminPageHeader(
                            state: .primary(
                                title: "News articles",
                                description: "Manage news articles."
                            )
                        )
                    )
                    if let error {
                        P(error).class("admin-form__error")
                    }
                    context.build(
                        AdminList(
                            table: {
                                if model.items.isEmpty {
                                    context.build(
                                        AdminListEmptyState(
                                            message: search.isEmpty && status == nil
                                                ? "No news articles yet."
                                                : "No news articles match your filters.",
                                            icon: FeatherIcons.inbox()
                                        )
                                    )
                                }
                                else {
                                    if permissions.allows(
                                        Article.Permissions.update
                                    ) {
                                        for item in model.items {
                                            context.build(
                                                AdminStatusSelectFormDefinition(
                                                    id: statusFormID(item.id),
                                                    action: routes.statusPath(item.id),
                                                    returnTo: AdminLocation.url(
                                                        path: path,
                                                        page: model.page,
                                                        search: search,
                                                        queryItems: statusURLQueryItems
                                                    )
                                                )
                                            )
                                        }
                                    }
                                    context.build(
                                        AdminListShell(
                                            layout: .init(
                                                name: "news-articles",
                                                columns: [
                                                    .fixed(128), .fraction(2),
                                                    .fixed(140), .fixed(180),
                                                    .fixed(120), .actions,
                                                ]
                                            ),
                                            table: Table {
                                                Thead {
                                                    Tr {
                                                        Th("Image")
                                                        Th("Title")
                                                        Th("Status")
                                                        Th("Publication")
                                                        Th("Availability")
                                                        Th("Actions")
                                                    }
                                                }
                                                Tbody {
                                                    for item in model.items {
                                                        Tr {
                                                            Td {
                                                                context.build(
                                                                    AdminImageCell(
                                                                        imageURL: item.imageAsset.map(mediaAssetURL),
                                                                        alt: item.imageAsset?.altText ?? item.title,
                                                                        size: .cover
                                                                    )
                                                                )
                                                            }
                                                            .data("label", "Image")
                                                            Td {
                                                                Span {
                                                                    Span(item.title)
                                                                    context.build(
                                                                        AdminPreviewLink(
                                                                            href: previewPath(item.metadata.slug),
                                                                            label: "Preview \(item.title)"
                                                                        )
                                                                    )
                                                                }
                                                            }
                                                            .data("label", "Title")
                                                            .setAsRemoveConfirmationLabel()
                                                            Td {
                                                                if permissions.allows(Article.Permissions.update) {
                                                                    context.build(
                                                                        AdminStatusSelectField(
                                                                            formID: statusFormID(item.id),
                                                                            selectedStatus: item.metadata.normalizedStatus
                                                                        )
                                                                    )
                                                                }
                                                                else {
                                                                    context.build(statusChip(item.metadata.normalizedStatus))
                                                                }
                                                            }
                                                            .data("label", "Status")
                                                            Td(format(item.metadata.publicationDate))
                                                                .data("label", "Publication")
                                                            Td {
                                                                context.build(
                                                                    AdminChip(
                                                                        label: item.availability.label,
                                                                        color: item.availability.color
                                                                    )
                                                                )
                                                            }
                                                            .data("label", "Availability")
                                                            context.build(
                                                                AdminListRowActions(
                                                                    label:
                                                                        "Actions",
                                                                    actions: [
                                                                        .init(
                                                                            "View",
                                                                            href:
                                                                                routes
                                                                                .detailsPath(
                                                                                    item
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .primary
                                                                                ),
                                                                            permission:
                                                                                NewsModule
                                                                                .Article
                                                                                .Permissions
                                                                                .read
                                                                        ),
                                                                        .init(
                                                                            "Edit",
                                                                            href:
                                                                                routes
                                                                                .editPath(
                                                                                    item
                                                                                        .id
                                                                                ),
                                                                            style:
                                                                                .ghost(
                                                                                    .secondary
                                                                                ),
                                                                            permission:
                                                                                NewsModule
                                                                                .Article
                                                                                .Permissions
                                                                                .update
                                                                        ),
                                                                    ],
                                                                    permissions:
                                                                        permissions
                                                                )
                                                            )
                                                        }
                                                    }
                                                }
                                            }
                                            .class("cms-table", "action-table")
                                        )
                                    )
                                }
                            },
                            search: {
                                context.build(
                                    AdminListSearch(
                                        state: .init(
                                            action: path,
                                            placeholder:
                                                "Search news articles...",
                                            search: search
                                        ),
                                        additionalFields: { statusField() }
                                    )
                                )
                            },
                            toolbar: {
                                if permissions.allows(
                                    NewsModule.Article.Permissions.create
                                ) {
                                    context.build(
                                        AdminListToolbar {
                                            context.build(
                                                AdminButton(
                                                    "Add article",
                                                    href: routes.add.path
                                                )
                                            )
                                        }
                                    )
                                }
                            },
                            pagination: {
                                context.build(
                                    AdminListPagination(
                                        state: .init(
                                            path: path,
                                            pageState: .init(
                                                page: model.page,
                                                pageSize: model.pageSize,
                                                total: model.total
                                            ),
                                            search: search,
                                            queryItems: statusQueryItems
                                        )
                                    )
                                )
                            }
                        )
                    )
                }
                else {
                    context.build(
                        AdminStatusView(
                            state: .init(
                                title: "Forbidden",
                                message:
                                    "Your account cannot access news articles."
                            ),
                            icon: FeatherIcons.alertCircle()
                        )
                    )
                }
            }
            .class("cms-section")
        }

        private var statusQueryItems: [AdminListPagination.QueryItem] {
            status.map { [.init(name: "status", value: $0.rawValue)] } ?? []
        }

        private var statusURLQueryItems: [URLQueryItem] {
            status.map { [URLQueryItem(name: "status", value: $0.rawValue)] } ?? []
        }

        private func statusFormID(_ id: String) -> String {
            "news-article-status-\(id)"
        }

        private func statusChip(_ status: String) -> AdminChip {
            .init(
                label: status.capitalized,
                color: status == "published"
                    ? .green : (status == "archived" ? .red : .yellow)
            )
        }

        private func format(_ value: String) -> String {
            guard
                let timestamp = WebModule.Metadata.SchemaBuilder.parseTimestamp(
                    value,
                    dateFormatter: dateFormatter
                )
            else { return "-" }
            return dateFormatter.formatDateTime(unixTimestamp: timestamp)
        }

        private func mediaAssetURL(for asset: AdminMediaAsset) -> String {
            AdminMediaAsset.mediaURL(
                path: asset.coverURL ?? asset.previewURL ?? asset.url
            )
        }

        private func previewPath(_ slug: String) -> String {
            slug.hasPrefix("/") ? slug : "/\(slug)"
        }

        private func statusField() -> Select {
            Select {
                Option("All statuses")
                    .value("")
                    .if(status == nil) { $0.selected() }
                for option in AdminMetadataStatus.allCases {
                    Option(option.label)
                        .value(option.rawValue)
                        .if(status == option) { $0.selected() }
                }
            }
            .name("status")
            .ariaLabel("Filter by status")
            .onChange("this.form.requestSubmit()")
        }
    }
}
