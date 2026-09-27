import CSS
import FeatherAdmin
import FeatherValidation
import HTML
import SGML
import WebBuilders
import WebComponents

struct MediaAssetPickerDialogNavigation: Sendable {
    let field: String?
    let galleryPath: String
    let uploadPath: String

    init(
        parentId: String?,
        view: String,
        field: String?,
        allowedExtensions: [String],
        defaultFolderPath: String?
    ) {
        self.field = field
        let query = Self.query(
            parentId: parentId,
            view: view,
            field: field,
            allowedExtensions: allowedExtensions,
            defaultFolderPath: defaultFolderPath
        )
        galleryPath = "/admin/media/assets/?\(query)"
        uploadPath = "/admin/media/assets/add/?\(query)"
    }

    private static func query(
        parentId: String?,
        view: String,
        field: String?,
        allowedExtensions: [String],
        defaultFolderPath: String?
    ) -> String {
        var items = ["picker=1"]
        if let parentId, !parentId.isEmpty {
            items.append("parent_id=\(parentId.queryEncoded())")
        }
        if view != "grid" {
            items.append("view=\(view.queryEncoded())")
        }
        if let field, !field.isEmpty {
            items.append("field=\(field.queryEncoded())")
        }
        if !allowedExtensions.isEmpty {
            items.append(
                "extensions=\(allowedExtensions.joined(separator: ",").queryEncoded())"
            )
        }
        if let defaultFolderPath, !defaultFolderPath.isEmpty {
            items.append(
                "default_folder_path=\(defaultFolderPath.queryEncoded())"
            )
        }
        items.append("presentation=dialog")
        return items.joined(separator: "&")
    }
}

struct MediaAssetPickerDialogView<Content: Component>: Component {
    enum Tab {
        case gallery
        case upload
    }

    let navigation: MediaAssetPickerDialogNavigation
    let activeTab: Tab
    let content: Content

    func rules() -> [any CSS.Rule] {
        content.rules() + [
            Media {
                Class("media-asset-picker-dialog") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(16.px)
                }
                Custom(".media-asset-picker-dialog > .pill-tabs") {
                    AlignSelf(.flexStart)
                    MarginBottom(0.px)
                }
            }
        ]
    }

    func html(context: inout BuilderContext) -> Div {
        Div {
            context.build(
                NewAdminTabBar(
                    links: [
                        .init(
                            label: "Gallery",
                            href: navigation.galleryPath,
                            isCurrent: activeTab == .gallery
                        ),
                        .init(
                            label: "Upload",
                            href: navigation.uploadPath,
                            isCurrent: activeTab == .upload
                        ),
                    ]
                )
            )
            context.build(content)
        }
        .class("media-asset-picker-dialog")
        .data("media-picker-field", navigation.field ?? "")
    }
}
