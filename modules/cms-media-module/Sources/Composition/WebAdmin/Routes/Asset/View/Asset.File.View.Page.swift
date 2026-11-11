import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import MediaModule
import SGML
import WebBuilders
import WebComponents

extension Asset.File.View {
    struct Page: Component {
        let item: AdminMediaAsset
        let variants: [Variant]
        let permissions: AdminListActions
        let routes: Asset.Router.Routes
        let activeTab: TabBar.Tab
        let detailsPath: String
        let variantsPath: String

        private func previewLink(
            for url: String
        ) -> String {
            AdminMediaAsset.mediaURL(path: url)
        }

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(links: routes.file.breadcrumb)
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Media asset details",
                            description:
                                "Review asset metadata and generated variants.",
                            moreActions: permissions.allows(
                                Asset.Permissions.delete
                            )
                                ? [
                                    .init(
                                        label: "Remove",
                                        href: routes.file.removePath(item.id),
                                        style: .destructive
                                    )
                                ]
                                : []
                        )
                    )
                )
                context.build(
                    TabBar(
                        active: activeTab,
                        detailsPath: detailsPath,
                        variantsPath: variantsPath
                    )
                )

                if activeTab == .details {
                    let title = item.title?.whitespaceTrimmed ?? ""
                    let altText = item.altText?.whitespaceTrimmed ?? ""
                    context.build(
                        AdminDetailField(label: "File name", value: item.name)
                            .setAsRemoveConfirmationLabel(title.isEmpty)
                    )
                    context.build(
                        AdminDetailField(
                            label: "Title",
                            value: title.isEmpty ? "-" : title
                        )
                        .setAsRemoveConfirmationLabel(!title.isEmpty)
                    )
                    context.build(
                        AdminDetailField(
                            label: "Alt text",
                            value: altText.isEmpty ? "-" : altText
                        )
                    )
                    Div {
                        P("URL").class("admin-detail-field__label")
                        P {
                            Span(item.url)
                            context.build(
                                AdminPreviewLink(
                                    href: previewLink(for: item.url),
                                    label: "Preview \(item.name)"
                                )
                            )
                        }
                        .class("admin-detail-field__value")
                    }
                    .class("admin-detail-field")
                    context.build(
                        AdminDetailField(
                            label: "Extension",
                            value: item.`extension`
                        )
                    )
                    context.build(
                        AdminDetailField(label: "Status", value: item.status)
                    )
                    context.build(
                        AdminDetailField(
                            label: "Size bytes",
                            value: "\(item.sizeBytes)"
                        )
                    )
                    Div {
                        if permissions.allows(Asset.Permissions.update) {
                            context.build(
                                AdminButton(
                                    "Edit",
                                    href: routes.file.editPath(item.id)
                                )
                            )
                        }
                    }
                    .class("button-row", "admin-detail-actions")
                }
                else if variants.isEmpty {
                    P("No generated variants linked to this asset yet.")
                }
                else {
                    context.build(
                        AdminListShell(
                            layout: .init(
                                name: "media-asset-variants",
                                columns: [
                                    .fraction(1),
                                    .fixed(100),
                                    .fraction(2),
                                    .fixed(120),
                                ]
                            ),
                            hasSelection: false,
                            table: Table {
                                Thead {
                                    Tr {
                                        Th("Name")
                                        Th("Extension")
                                        Th("URL")
                                        Th("Preview")
                                    }
                                }
                                Tbody {
                                    for variant in variants {
                                        Tr {
                                            Td(variant.name)
                                            Td(variant.fileExtension)
                                            Td(variant.url)
                                            Td {
                                                context.build(
                                                    AdminRowButton(
                                                        "Preview",
                                                        href: previewLink(
                                                            for: variant.url
                                                        ),
                                                        style: .ghost(.primary)
                                                    )
                                                )
                                            }
                                            .data("label", "Preview")
                                        }
                                    }
                                }
                            }
                            .class("cms-table")
                        )
                    )
                }
            }
            .class("cms-section")
        }
    }
}
