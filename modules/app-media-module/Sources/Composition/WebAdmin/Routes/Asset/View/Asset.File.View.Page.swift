import FeatherModuleKit
import FeatherValidation
import FeatherWebAdmin
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaModule
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

extension Asset.File.View {
    struct Page: Component {
        let item: Components.Schemas.MediaAssetDetailSchema
        let variants: [Components.Schemas.MediaAssetVariantListItemSchema]
        let permissions: AdminListActions
        let routes: Asset.Router.Routes

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
                                "Review asset metadata and generated variants."
                        )
                    )
                )
                context.build(
                    AdminDetailField(
                        label: "URL",
                        value: item.url
                    )
                )
                context.build(
                    AdminDetailField(label: "Extension", value: item._extension)
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
                if let title = item.title {
                    context.build(
                        AdminDetailField(label: "Title", value: title)
                    )
                }
                if let altText = item.altText {
                    context.build(
                        AdminDetailField(label: "Alt text", value: altText)
                    )
                }
                context.build(
                    AdminButton(
                        "Open original",
                        href: previewLink(for: item.url),
                        style: .secondary
                    )
                )
                if variants.isEmpty {
                    P("No generated variants linked to this asset yet.")
                }
                else {
                    H2("Associated variants")
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
                                            Td(variant._extension)
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
                Div {
                    if permissions.allows(Asset.Permissions.update) {
                        context.build(
                            AdminButton(
                                "Edit",
                                href:
                                    routes.file.editPath(item.id)
                            )
                        )
                    }
                    if permissions.allows(Asset.Permissions.delete) {
                        context.build(
                            AdminButton(
                                "Remove",
                                href:
                                    routes.file.removePath(item.id),
                                style: .destructive
                            )
                        )
                    }
                }
                .class("button-row", "admin-detail-actions")
            }
            .class("cms-section")
        }
    }
}
