import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import SGML
import WebBuilders
import WebComponents
import WebModule

extension Page.Search.Table {
    struct Row: Component {
        let page: Page.Search.Item
        let permissions: AdminListActions
        let canEdit: Bool
        let returnTo: String
        let routes: Page.Router.Routes

        func html(context: inout BuilderContext) -> Tr {
            Tr {
                if permissions.allows(Page.Permissions.delete) {
                    context.build(AdminListRowCheckbox(id: page.id))
                }
                titleCell(context: &context)
                statusCell(context: &context)
                Td(
                    page.metadata.publicationDate.map {
                        DateFormatting.formatUnixTimestamp($0)
                    } ?? "-"
                )
                .data("label", "Publication")
                Td {
                    context.build(
                        AdminChip(
                            label: page.availability.label,
                            color: page.availability.color
                        )
                    )
                }
                .data("label", "Availability")
                context.build(
                    AdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "View",
                                href: routes.detailsPath(page.id),
                                style: .ghost(.primary),
                                permission: Page.Permissions.read
                            ),
                            .init(
                                "Edit",
                                href: routes.editPath(page.id),
                                style: .ghost(.secondary),
                                permission: Page.Permissions.update
                            ),
                        ],
                        permissions: permissions
                    )
                )
            }
        }

        private func titleCell(context: inout BuilderContext) -> Td {
            Td {
                Span {
                    Span(page.title)
                    if let previewPath = previewPath {
                        context.build(
                            AdminPreviewLink(
                                href: previewPath,
                                label: "Preview \(page.title)"
                            )
                        )
                    }
                }
            }
            .data("label", "Title")
            .setAsRemoveConfirmationLabel()
        }

        private func statusCell(context: inout BuilderContext) -> Td {
            Td {
                if canEdit {
                    context.build(
                        AdminStatusSelectField(
                            formID: "web-page-status-\(page.id)",
                            selectedStatus: page.metadata.normalizedStatus
                        )
                    )
                }
                else {
                    Span(page.metadata.status.capitalized)
                }
            }
            .data("label", "Status")
        }

        private var previewPath: String? {
            let slug = page.metadata.normalizedSlug
            return slug.isEmpty ? nil : "/\(slug)/"
        }

    }
}
