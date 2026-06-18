import AdminOpenAPI
import CSS
import HTML
import SGML
import WebStandards

import class Foundation.ByteCountFormatter
import struct Foundation.CharacterSet

struct AssetListView: Component {
    struct State {
        let folders: [Components.Schemas.MediaFolderListItemSchema]
        let items: [AdminListMediaAssetModel.AssetItem]
        let page: Int
        let pageSize: Int
        let total: Int
        let search: String
        let parentId: String?
        let currentFolder: Components.Schemas.MediaFolderDetailSchema?
        let ancestors: [Components.Schemas.MediaFolderDetailSchema]
        let view: AdminListMediaAssetModel.ViewMode
        let picker: AdminListMediaAssetModel.PickerState
        let isAdded: Bool
        let isRemoved: Bool
        let canAccess: Bool
        let permissions: Set<String>
        let canAdd: Bool
        let deniedInfo: String
        let deniedMessage: String
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func selectors() -> [any Selector] {
        Class("media-assets-toolbar") {
            MarginBottom(0)
        }
        Class("media-assets-toolbar-group") {
            Display(.flex)
            FlexWrap(.wrap)
            AlignItems(.center)
            Gap(10.px)
            MarginBottom(24.px)
        }
        Class("media-assets-search-row") {
            Display(.flex)
            FlexWrap(.wrap)
            AlignItems(.center)
            Gap(4.px)
            MarginBottom(12.px)
        }
        Custom(
            ".media-assets-search-row .table-search-form input[type='search']"
        ) {
            MinWidth(18.rem)
        }
        Custom(".media-assets-search-row .media-assets-toggle") {
            MarginLeft(.auto)
            AlignSelf(.center)
            UnsafeRawProperty(name: "align-items", value: "center")
        }
        Class("media-assets-folder-form") {
            Display(.flex)
            FlexWrap(.wrap)
            Gap(10.px)
            AlignItems(.center)
        }
        Custom(".media-assets-folder-form input[type='search']") {
            MaxWidth(16.rem)
            Width(16.rem)
        }
        Class("media-assets-toggle") {
            Display(.inlineFlex)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(999.px)
            Padding(4.px)
            Gap(4.px)
        }
        Custom(".media-assets-toggle a") {
            BorderRadius(999.px)
            Padding(vertical: 8.px, horizontal: 12.px)
            TextDecoration(.none)
            Color(.variable("cms-light-font"))
            UnsafeRawProperty(name: "cursor", value: "pointer")
        }
        Custom(".media-assets-toggle a:hover:not(.is-current)") {
            Color(.variable("cms-link-hover"))
            TextDecoration(.underline)
        }
        Custom(".media-assets-toggle a.is-current") {
            UnsafeRawProperty(name: "background", value: "var(--cms-gray-4)")
            Color(.variable("cms-strong-font"))
        }
        Class("media-assets-grid") {
            RowGap(20.px)
            ColumnGap(20.px)
        }
        Class("media-assets-card") {
            Display(.flex)
            FlexDirection(.column)
            Gap(12.px)
            Height(100.percent)
            Padding(14.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(18.px)
            Background(color: .color(.variable("cms-bg")))
        }
        Class("media-assets-card-preview") {
            UnsafeRawProperty(name: "aspect-ratio", value: "4 / 3")
            Display(.grid)
            UnsafeRawProperty(name: "place-items", value: "center")
            Position(.relative)
            Overflow(.hidden)
            BorderRadius(14.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            Background(color: .color(.variable("cms-gray-2")))
        }
        Class("media-assets-card-preview-button") {
            Border(0)
            Padding(0)
            Background(color: .transparent)
            Width(100.percent)
            UnsafeRawProperty(name: "cursor", value: "pointer")
        }
        Custom(".media-assets-card-preview img") {
            Position(.absolute)
            UnsafeRawProperty(name: "inset", value: "0")
            Width(100.percent)
            Height(100.percent)
            ObjectFit(.cover)
            UnsafeRawProperty(name: "object-position", value: "center center")
            Display(.block)
            Margin(0)
        }
        Class("media-assets-card-body") {
            Display(.grid)
            Gap(8.px)
            Flex(1)
        }
        Custom(".media-assets-card-body h3") {
            Margin(0)
            FontSize(1.rem)
            LineHeight(1.3)
        }
        Custom(".media-assets-card-body h3 a") {
            Color(.inherit)
            TextDecoration(.none)
        }
        Custom(".media-assets-card-body p") {
            Margin(0)
            Color(.variable("cms-light-font"))
            FontSize(0.86.rem)
            WordBreak(.breakWord)
        }
        Class("media-assets-card-actions") {
            Display(.flex)
            FlexWrap(.wrap)
            Gap(8.px)
            MarginTop(4.px)
            AlignItems(.center)
        }
        Class("media-assets-table-preview") {
            Width(72.px)
        }
        Custom(
            ".media-assets-table-preview > div, .media-assets-table-preview a > div"
        ) {
            Display(.grid)
            UnsafeRawProperty(name: "place-items", value: "center")
            Width(56.px)
            Height(56.px)
            BorderRadius(10.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            Background(color: .color(.variable("cms-gray-2")))
        }
        Custom(".media-assets-table-preview a") {
            Display(.inlineBlock)
            Color(.inherit)
            TextDecoration(.none)
        }
        Custom(".media-assets-table-preview img") {
            Width(56.px)
            Height(56.px)
            ObjectFit(.cover)
            BorderRadius(10.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            Display(.block)
            Margin(0)
        }
        Custom(".media-assets-table-preview .media-assets-folder-icon svg") {
            Width(28.px)
            Height(28.px)
        }
        Class("media-assets-folder-icon") {
            Color(.variable("cms-primary-bg"))
        }
        Custom(".media-assets-folder-icon svg") {
            Width(2.5.rem)
            Height(2.5.rem)
        }
        Custom(".media-assets-card-preview.media-assets-folder-icon svg") {
            Width(5.rem)
            Height(5.rem)
        }
        Class("media-assets-inline-form") {
            Display(.inline)
        }
    }

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1(state.deniedInfo)
                P(state.deniedMessage)
            }
            else {
                if !state.picker.isEnabled {
                    AdminBreadcrumb(state: state.breadcrumb)
                    H1("Media assets")

                    if state.isAdded { P("Item added successfully.") }
                    if state.isRemoved { P("Item removed successfully.") }
                }

                toolbar()

                if hasAnyResults {
                    switch state.view {
                    case .grid:
                        gridContent()
                    case .list:
                        listContent()
                    }
                }
                else {
                    emptyState()
                }

                ListTablePagination(
                    state: .init(
                        path: "/admin/media/assets/",
                        page: state.page,
                        pageSize: state.pageSize,
                        total: state.total,
                        search: state.search,
                        queryItems: queryItems()
                    )
                )
                if state.picker.isEnabled {
                    Script(pickerScript())
                }
            }
        }
        .class("cms-section")
        .if(state.picker.isEnabled) {
            $0.setAttribute(
                name: "data-admin-media-picker-section",
                value: "gallery"
            )
        }
    }
}

extension AssetListView {
    fileprivate var hasAnyResults: Bool {
        !state.folders.isEmpty || !state.items.isEmpty
            || state.currentFolder != nil
    }

    fileprivate func queryItems() -> [(String, String)] {
        queryItems(
            parentId: state.parentId,
            view: state.view,
            search: nil,
            page: nil
        )
    }

    fileprivate func queryItems(
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode,
        search: String?,
        page: Int?
    ) -> [(String, String)] {
        var items: [(String, String)] = []
        if let parentId {
            items.append(("parent_id", parentId))
        }
        if view != .grid {
            items.append(("view", view.rawValue))
        }
        if state.picker.isEnabled {
            items.append(("picker", "1"))
        }
        if let field = state.picker.field {
            items.append(("field", field))
        }
        if !state.picker.allowedExtensions.isEmpty {
            items.append(
                (
                    "extensions",
                    state.picker.allowedExtensions.joined(separator: ",")
                )
            )
        }
        if let defaultFolderPath = state.picker.defaultFolderPath {
            items.append(("default_folder_path", defaultFolderPath))
        }
        if let search, !search.isEmpty {
            items.append(("search", search))
        }
        if let page {
            items.append(("page", "\(page)"))
        }
        return items
    }

    fileprivate func addAssetPath() -> String {
        var suffix: [String] = []
        if let parentId = state.parentId {
            suffix.append("parent_id=\(parentId.queryEncoded())")
        }
        if state.view != .grid {
            suffix.append("view=\(state.view.rawValue)")
        }
        if state.picker.isEnabled {
            suffix.append("picker=1")
        }
        if let field = state.picker.field {
            suffix.append("field=\(field.queryEncoded())")
        }
        if !state.picker.allowedExtensions.isEmpty {
            suffix.append(
                "extensions=\(state.picker.allowedExtensions.joined(separator: ",").queryEncoded())"
            )
        }
        if let defaultFolderPath = state.picker.defaultFolderPath {
            suffix.append(
                "default_folder_path=\(defaultFolderPath.queryEncoded())"
            )
        }
        return suffix.isEmpty
            ? "/admin/media/assets/add/"
            : "/admin/media/assets/add/?\(suffix.joined(separator: "&"))"
    }

    fileprivate func assetActionSuffix() -> String {
        var suffix: [String] = []
        if let parentId = state.parentId {
            suffix.append("parent_id=\(parentId.queryEncoded())")
        }
        if state.view != .grid {
            suffix.append("view=\(state.view.rawValue)")
        }
        if state.picker.isEnabled {
            suffix.append("picker=1")
        }
        if let field = state.picker.field {
            suffix.append("field=\(field.queryEncoded())")
        }
        if !state.picker.allowedExtensions.isEmpty {
            suffix.append(
                "extensions=\(state.picker.allowedExtensions.joined(separator: ",").queryEncoded())"
            )
        }
        if let defaultFolderPath = state.picker.defaultFolderPath {
            suffix.append(
                "default_folder_path=\(defaultFolderPath.queryEncoded())"
            )
        }
        return suffix.isEmpty ? "" : "?\(suffix.joined(separator: "&"))"
    }

    fileprivate func addFolderPath() -> String {
        var suffix: [String] = []
        if let parentId = state.parentId {
            suffix.append("parent_id=\(parentId.queryEncoded())")
        }
        if state.view != .grid {
            suffix.append("view=\(state.view.rawValue)")
        }
        if state.picker.isEnabled {
            suffix.append("picker=1")
        }
        if let field = state.picker.field {
            suffix.append("field=\(field.queryEncoded())")
        }
        if !state.picker.allowedExtensions.isEmpty {
            suffix.append(
                "extensions=\(state.picker.allowedExtensions.joined(separator: ",").queryEncoded())"
            )
        }
        if let defaultFolderPath = state.picker.defaultFolderPath {
            suffix.append(
                "default_folder_path=\(defaultFolderPath.queryEncoded())"
            )
        }
        return suffix.isEmpty
            ? "/admin/media/folders/add/"
            : "/admin/media/folders/add/?\(suffix.joined(separator: "&"))"
    }

    fileprivate func browsePath(
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode? = nil,
        search: String? = nil,
        page: Int? = nil
    ) -> String {
        let view = view ?? state.view
        let query = queryItems(
            parentId: parentId,
            view: view,
            search: search,
            page: page
        )
        let encoded = query.map { "\($0.0)=\($0.1.queryEncoded())" }
        return encoded.isEmpty
            ? "/admin/media/assets/"
            : "/admin/media/assets/?\(encoded.joined(separator: "&"))"
    }

    fileprivate func encodedStorageKey(
        _ key: String
    ) -> String {
        let prefix = "media/assets/"
        let raw =
            key.hasPrefix(prefix) ? String(key.dropFirst(prefix.count)) : key
        let allowed = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/"
        )
        return raw.addingPercentEncoding(withAllowedCharacters: allowed) ?? raw
    }

    fileprivate func previewLink(
        for storageKey: String,
        isVariant: Bool
    ) -> String {
        let prefix = isVariant ? "/media/variants/" : "/media/assets/"
        return
            "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)\(prefix)\(encodedStorageKey(storageKey))"
    }

    fileprivate func assetOriginalLink(
        for item: Components.Schemas.MediaAssetListItemSchema
    ) -> String {
        previewLink(for: item.storageKey, isVariant: false)
    }

    fileprivate func displayTitle(
        for item: Components.Schemas.MediaAssetListItemSchema
    ) -> String {
        fileName(for: item)
    }

    fileprivate func fileName(
        for item: Components.Schemas.MediaAssetListItemSchema
    ) -> String {
        item._type.isEmpty ? item.baseName : "\(item.baseName).\(item._type)"
    }

    fileprivate func folderEditPath(
        _ folder: Components.Schemas.MediaFolderListItemSchema
    ) -> String {
        "/admin/media/folders/\(folder.id)/edit/"
    }

    fileprivate func toolbar() -> some FlowContent {
        Div {
            Div {
                if state.canAdd && !state.picker.isEnabled {
                    AdminNavigationButton("Add asset", href: addAssetPath())
                }
                if state.canAdd && !state.picker.isEnabled {
                    A("Add folder")
                        .href(addFolderPath())
                        .class("secondary")
                }
            }
            .class("button-row", "media-assets-toolbar-group")

            Div {
                if state.picker.isEnabled {
                    pickerSearchControls()
                }
                else {
                    ListTableSearchForm(
                        state: .init(
                            action: "/admin/media/assets/",
                            placeholder: "Quick search assets",
                            search: state.search,
                            resetPath: browsePath(parentId: state.parentId),
                            queryItems: queryItems()
                        )
                    )
                }
                Div {
                    A("Grid")
                        .href(
                            browsePath(
                                parentId: state.parentId,
                                view: .grid,
                                search: state.search.isEmpty
                                    ? nil : state.search,
                                page: state.page
                            )
                        )
                        .if(state.view == .grid) { $0.class("is-current") }
                    A("List")
                        .href(
                            browsePath(
                                parentId: state.parentId,
                                view: .list,
                                search: state.search.isEmpty
                                    ? nil : state.search,
                                page: state.page
                            )
                        )
                        .if(state.view == .list) { $0.class("is-current") }
                }
                .class("media-assets-toggle")
            }
            .class("media-assets-search-row")
        }
        .class("media-assets-toolbar")
    }

    fileprivate func pickerSearchControls() -> some FlowContent {
        Div {
            Input()
                .type(.search)
                .value(state.search)
                .placeholder("Quick search assets")
                .setAttribute(
                    name: "data-admin-media-picker-search-input",
                    value: "1"
                )
            Button("Search")
                .type(.button)
                .setAttribute(
                    name: "data-admin-media-picker-search-submit",
                    value: "1"
                )
            A("Reset")
                .href(browsePath(parentId: state.parentId))
                .class("table-search-reset")
        }
        .class("table-search-form")
        .setAttribute(
            name: "data-admin-media-picker-search-path",
            value: browsePath(parentId: state.parentId)
        )
    }

    fileprivate func emptyState() -> some FlowContent {
        let totalPages = max(
            1,
            (state.total + state.pageSize - 1) / state.pageSize
        )
        return Div {
            if state.total > 0 && state.page > totalPages {
                P("Page \(state.page) does not exist.")
                P {
                    Span("Go to ")
                    A("page 1")
                        .href(
                            browsePath(
                                parentId: state.parentId,
                                search: state.search.isEmpty
                                    ? nil : state.search,
                                page: 1
                            )
                        )
                    Span(" or ")
                    A("page \(totalPages)")
                        .href(
                            browsePath(
                                parentId: state.parentId,
                                search: state.search.isEmpty
                                    ? nil : state.search,
                                page: totalPages
                            )
                        )
                    Span(".")
                }
            }
            else {
                P(
                    state.search.isEmpty
                        ? "No media assets or folders yet."
                        : "No media assets or folders match your search."
                )
            }
        }
    }

    fileprivate func gridContent() -> some FlowContent {
        Div {
            if let currentFolder = state.currentFolder {
                upCard(parentId: currentFolder.parentId)
            }
            for folder in state.folders {
                folderCard(folder)
            }
            for item in state.items {
                assetCard(item)
            }
        }
        .class("grid", "grid-421", "media-assets-grid")
    }

    fileprivate func listContent() -> some FlowContent {
        let canRemove =
            state.permissions.contains(
                AdminMedia.Scope.assets.permission(for: .delete)
            )
            && !state.picker.isEnabled
        return ListTableBulkRemoveForm(
            state: .init(
                action: "/admin/media/assets/bulk-remove/",
                page: state.page,
                search: state.search,
                canRemove: canRemove,
                buttonTitle: "Remove selected",
                queryItems: queryItems()
            ),
            table: ListTableShell(
                table: Table {
                    Thead {
                        Tr {
                            if canRemove {
                                ListTableSelectAllCheckbox()
                            }
                            Th("Preview").columnWidth(percent: 10)
                            Th("File name")
                            Th("Type").columnWidth(percent: 12)
                            Th("Size").columnWidth(percent: 12)
                            Th("Actions").columnWidth(percent: 20)
                        }
                    }
                    Tbody {
                        if let currentFolder = state.currentFolder {
                            upRow(
                                parentId: currentFolder.parentId,
                                canRemove: canRemove
                            )
                        }
                        for folder in state.folders {
                            folderRow(folder, canRemove: canRemove)
                        }
                        for item in state.items {
                            assetRow(item, canRemove: canRemove)
                        }
                    }
                }
                .class("cms-table", "action-table")
                .if(canRemove) { $0.class("bulk-select-table") }
            )
        )
    }

    fileprivate func upCard(
        parentId: String?
    ) -> some FlowContent {
        Div {
            A {
                Div {
                    Icon(svg: FeatherIcons.cornerUpLeft())
                }
                .class("media-assets-card-preview", "media-assets-folder-icon")
            }
            .href(browsePath(parentId: parentId))

            Div {
                H3("Up to parent")
                P("Parent folder")
            }
            .class("media-assets-card-body")

            Div {
                A("Open").href(browsePath(parentId: parentId)).class("row-btn")
            }
            .class("media-assets-card-actions")
        }
        .class("media-assets-card")
    }

    fileprivate func folderCard(
        _ folder: Components.Schemas.MediaFolderListItemSchema
    ) -> some FlowContent {
        Div {
            A {
                Div {
                    Icon(svg: FeatherIcons.folder())
                }
                .class("media-assets-card-preview", "media-assets-folder-icon")
            }
            .href(browsePath(parentId: folder.id))

            Div {
                H3 {
                    A(folder.name).href(browsePath(parentId: folder.id))
                }
                P(folderItemCountLabel(for: folder))
            }
            .class("media-assets-card-body")

            Div {
                A("Open").href(browsePath(parentId: folder.id)).class("row-btn")
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .update)
                ) && !state.picker.isEnabled {
                    A("Edit")
                        .href(folderEditPath(folder))
                        .class("row-btn", "edit")
                }
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .delete)
                ) && !state.picker.isEnabled {
                    folderDeleteForm(folder)
                }
            }
            .class("media-assets-card-actions")
        }
        .class("media-assets-card")
    }

    fileprivate func assetCard(
        _ item: AdminListMediaAssetModel.AssetItem
    ) -> some FlowContent {
        let actionSuffix = assetActionSuffix()
        let detailsURL = "/admin/media/assets/\(item.asset.id)/\(actionSuffix)"
        let previewURL = previewLink(
            for: item.preview?.storageKey ?? item.asset.storageKey,
            isVariant: item.preview != nil
        )
        let originalURL = assetOriginalLink(for: item.asset)
        return Div {
            if state.picker.isEnabled, let field = state.picker.field {
                Button {
                    Div {
                        if item.preview != nil {
                            Img(
                                src: previewURL,
                                alt: displayTitle(for: item.asset)
                            )
                        }
                        else {
                            Div {
                                Icon(svg: FeatherIcons.file())
                            }
                            .class("media-assets-folder-icon")
                        }
                    }
                    .class("media-assets-card-preview")
                }
                .type(.button)
                .class("media-assets-card-preview-button")
                .setAttribute(name: "data-picker-select", value: item.asset.id)
                .setAttribute(name: "data-picker-field", value: field)
                .setAttribute(
                    name: "data-picker-storage-key",
                    value: item.asset.storageKey
                )
                .setAttribute(
                    name: "data-picker-base-name",
                    value: item.asset.baseName
                )
                .setAttribute(name: "data-picker-type", value: item.asset._type)
                .setAttribute(
                    name: "data-picker-title",
                    value: item.asset.title ?? ""
                )
                .setAttribute(
                    name: "data-picker-alt-text",
                    value: item.asset.altText ?? ""
                )
                .setAttribute(
                    name: "data-picker-status",
                    value: item.asset.status
                )
            }
            else {
                A {
                    Div {
                        if item.preview != nil {
                            Img(
                                src: previewURL,
                                alt: displayTitle(for: item.asset)
                            )
                        }
                        else {
                            Div {
                                Icon(svg: FeatherIcons.file())
                            }
                            .class("media-assets-folder-icon")
                        }
                    }
                    .class("media-assets-card-preview")
                }
                .href(originalURL)
                .setAttribute(name: "target", value: "_blank")
            }

            Div {
                H3(displayTitle(for: item.asset))
                P(fileSizeLabel(bytes: item.asset.sizeBytes))
            }
            .class("media-assets-card-body")

            Div {
                if state.picker.isEnabled, let field = state.picker.field {
                    Button("Select")
                        .type(.button)
                        .class("row-btn")
                        .setAttribute(
                            name: "data-picker-select",
                            value: item.asset.id
                        )
                        .setAttribute(name: "data-picker-field", value: field)
                        .setAttribute(
                            name: "data-picker-storage-key",
                            value: item.asset.storageKey
                        )
                        .setAttribute(
                            name: "data-picker-base-name",
                            value: item.asset.baseName
                        )
                        .setAttribute(
                            name: "data-picker-type",
                            value: item.asset._type
                        )
                        .setAttribute(
                            name: "data-picker-title",
                            value: item.asset.title ?? ""
                        )
                        .setAttribute(
                            name: "data-picker-alt-text",
                            value: item.asset.altText ?? ""
                        )
                        .setAttribute(
                            name: "data-picker-status",
                            value: item.asset.status
                        )
                }
                else if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .read)
                ) {
                    A("Details").href(detailsURL).class("row-btn")
                }
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .update)
                ) && !state.picker.isEnabled {
                    A("Edit")
                        .href(
                            "/admin/media/assets/\(item.asset.id)/edit/\(actionSuffix)"
                        )
                        .class("row-btn", "edit")
                }
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .delete)
                ) && !state.picker.isEnabled {
                    A("Remove")
                        .href(
                            "/admin/media/assets/\(item.asset.id)/remove/\(actionSuffix)"
                        )
                        .class("row-btn", "delete")
                }
            }
            .class("media-assets-card-actions")
        }
        .class("media-assets-card")
    }

    fileprivate func upRow(
        parentId: String?,
        canRemove: Bool
    ) -> some BasicTag {
        Tr {
            if canRemove {
                Td("")
            }
            parentPreviewCell(href: browsePath(parentId: parentId))
            Td {
                A("Up to parent").href(browsePath(parentId: parentId))
            }
            .setAttribute(name: "data-label", value: "File name")
            Td("")
                .setAttribute(name: "data-label", value: "Type")
            Td("-")
                .setAttribute(name: "data-label", value: "Size")
            Td {
                A("Open").href(browsePath(parentId: parentId)).class("row-btn")
            }
            .setAttribute(name: "data-label", value: "Actions")
            .class("action-cell")
        }
    }

    fileprivate func folderRow(
        _ folder: Components.Schemas.MediaFolderListItemSchema,
        canRemove: Bool
    ) -> some BasicTag {
        Tr {
            if canRemove {
                Td("")
            }
            folderPreviewCell(
                label: folder.name,
                href: browsePath(parentId: folder.id)
            )
            folderTitleCell(for: folder)
            Td("Folder")
                .setAttribute(name: "data-label", value: "Type")
            Td(folderItemCountLabel(for: folder))
                .setAttribute(name: "data-label", value: "Size")
            Td {
                A("Open").href(browsePath(parentId: folder.id)).class("row-btn")
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .update)
                ) && !state.picker.isEnabled {
                    Span(" ")
                    A("Edit")
                        .href(folderEditPath(folder))
                        .class("row-btn", "edit")
                }
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .delete)
                ) && !state.picker.isEnabled {
                    Span(" ")
                    folderDeleteForm(folder)
                }
            }
            .setAttribute(name: "data-label", value: "Actions")
            .class("action-cell")
        }
    }

    fileprivate func assetRow(
        _ item: AdminListMediaAssetModel.AssetItem,
        canRemove: Bool
    ) -> some BasicTag {
        let actionSuffix = assetActionSuffix()
        let previewURL = previewLink(
            for: item.preview?.storageKey ?? item.asset.storageKey,
            isVariant: item.preview != nil
        )
        let originalURL = assetOriginalLink(for: item.asset)
        return Tr {
            if canRemove {
                ListTableRowSelectCheckbox(state: .init(id: item.asset.id))
            }
            assetPreviewCell(
                for: item,
                previewURL: previewURL,
                originalURL: originalURL
            )
            assetTitleCell(for: item, originalURL: originalURL)
            Td(item.asset._type)
                .setAttribute(name: "data-label", value: "Type")
            Td(fileSizeLabel(bytes: item.asset.sizeBytes))
                .setAttribute(name: "data-label", value: "Size")
            Td {
                if state.picker.isEnabled, let field = state.picker.field {
                    Button("Select")
                        .type(.button)
                        .class("row-btn")
                        .setAttribute(
                            name: "data-picker-select",
                            value: item.asset.id
                        )
                        .setAttribute(name: "data-picker-field", value: field)
                        .setAttribute(
                            name: "data-picker-storage-key",
                            value: item.asset.storageKey
                        )
                        .setAttribute(
                            name: "data-picker-base-name",
                            value: item.asset.baseName
                        )
                        .setAttribute(
                            name: "data-picker-type",
                            value: item.asset._type
                        )
                        .setAttribute(
                            name: "data-picker-title",
                            value: item.asset.title ?? ""
                        )
                        .setAttribute(
                            name: "data-picker-alt-text",
                            value: item.asset.altText ?? ""
                        )
                        .setAttribute(
                            name: "data-picker-status",
                            value: item.asset.status
                        )
                }
                else {
                    A("Details")
                        .href(
                            "/admin/media/assets/\(item.asset.id)/\(actionSuffix)"
                        )
                        .class("row-btn")
                }
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .update)
                ) && !state.picker.isEnabled {
                    Span(" ")
                    A("Edit")
                        .href(
                            "/admin/media/assets/\(item.asset.id)/edit/\(actionSuffix)"
                        )
                        .class("row-btn", "edit")
                }
                if state.permissions.contains(
                    AdminMedia.Scope.assets.permission(for: .delete)
                ) && !state.picker.isEnabled {
                    Span(" ")
                    A("Remove")
                        .href(
                            "/admin/media/assets/\(item.asset.id)/remove/\(actionSuffix)"
                        )
                        .class("row-btn", "delete")
                }
            }
            .setAttribute(name: "data-label", value: "Actions")
            .class("action-cell")
        }
    }

    fileprivate func folderDeleteForm(
        _ folder: Components.Schemas.MediaFolderListItemSchema
    ) -> some FlowContent {
        Form {
            Input().type(.hidden).name("parentId").value(state.parentId ?? "")
            Input().type(.hidden).name("search").value(state.search)
            Input().type(.hidden).name("view").value(state.view.rawValue)
            Input().type(.hidden).name("page").value("\(state.page)")
            Button("Remove").type(.submit).class("row-btn", "delete")
        }
        .method(.post)
        .action("/admin/media/assets/folders/\(folder.id)/remove/")
        .class("media-assets-inline-form")
    }

    fileprivate func folderItemCountLabel(
        for folder: Components.Schemas.MediaFolderListItemSchema
    ) -> String {
        folder.assetCount == 1 ? "1 item" : "\(folder.assetCount) items"
    }

    fileprivate func fileSizeLabel(
        bytes: Int64
    ) -> String {
        ByteCountFormatter.string(fromByteCount: bytes, countStyle: .file)
    }

    fileprivate func pickerScript() -> String {
        """
        (function() {
          if (window.__adminMediaAssetListPickerInit) { return; }
          window.__adminMediaAssetListPickerInit = true;
          document.addEventListener("click", function(event) {
            var trigger = event.target.closest("[data-picker-select]");
            if (!trigger) { return; }
            event.preventDefault();
            window.parent.postMessage({
              type: "admin-media-picker-select",
              field: trigger.getAttribute("data-picker-field"),
              asset: {
                id: trigger.getAttribute("data-picker-select"),
                storageKey: trigger.getAttribute("data-picker-storage-key"),
                baseName: trigger.getAttribute("data-picker-base-name"),
                type: trigger.getAttribute("data-picker-type"),
                title: trigger.getAttribute("data-picker-title"),
                altText: trigger.getAttribute("data-picker-alt-text"),
                status: trigger.getAttribute("data-picker-status")
              }
            }, "*");
          });
        })();
        """
    }

    fileprivate func parentPreviewCell(
        href: String
    ) -> some BasicTag {
        Td {
            A {
                Div {
                    Icon(svg: FeatherIcons.cornerUpLeft())
                }
                .class("media-assets-folder-icon")
            }
            .href(href)
            .setAttribute(name: "aria-label", value: "Open parent folder")
        }
        .class("media-assets-table-preview")
        .setAttribute(name: "data-label", value: "Preview")
        .setAttribute(name: "aria-label", value: "Parent folder")
    }

    fileprivate func folderPreviewCell(
        label: String,
        href: String
    ) -> some BasicTag {
        Td {
            A {
                Div {
                    Icon(svg: FeatherIcons.folder())
                }
                .class("media-assets-folder-icon")
            }
            .href(href)
            .setAttribute(name: "aria-label", value: "Open \(label)")
        }
        .class("media-assets-table-preview")
        .setAttribute(name: "data-label", value: "Preview")
        .setAttribute(name: "aria-label", value: label)
    }

    fileprivate func assetPreviewCell(
        for item: AdminListMediaAssetModel.AssetItem,
        previewURL: String,
        originalURL: String
    ) -> some BasicTag {
        Td {
            A {
                if item.preview != nil {
                    Img(src: previewURL, alt: displayTitle(for: item.asset))
                }
                else {
                    Div {
                        Icon(svg: FeatherIcons.file())
                    }
                    .class("media-assets-folder-icon")
                }
            }
            .href(originalURL)
            .setAttribute(name: "target", value: "_blank")
            .setAttribute(
                name: "aria-label",
                value: "Open \(displayTitle(for: item.asset))"
            )
        }
        .class("media-assets-table-preview")
        .setAttribute(name: "data-label", value: "Preview")
    }

    fileprivate func folderTitleCell(
        for folder: Components.Schemas.MediaFolderListItemSchema
    ) -> some BasicTag {
        Td {
            A(folder.name)
                .href(browsePath(parentId: folder.id))
        }
        .setAttribute(name: "data-label", value: "File name")
    }

    fileprivate func assetTitleCell(
        for item: AdminListMediaAssetModel.AssetItem,
        originalURL: String
    ) -> some BasicTag {
        Td {
            Span {
                A(fileName(for: item.asset))
                    .href(originalURL)
                    .setAttribute(name: "target", value: "_blank")
                    .setAttribute(
                        name: "aria-label",
                        value: "Open \(displayTitle(for: item.asset))"
                    )
                A {
                    Icon(svg: FeatherIcons.externalLink())
                }
                .href(originalURL)
                .setAttribute(name: "target", value: "_blank")
                .setAttribute(
                    name: "aria-label",
                    value: "Open \(displayTitle(for: item.asset))"
                )
                .style(
                    "display:inline-flex;align-items:center;justify-content:center;width:0.95rem;height:0.95rem;flex:0 0 auto;"
                )
            }
            .style(
                "display:inline-flex;align-items:center;gap:0.35rem;vertical-align:middle;line-height:1.25;"
            )
        }
        .setAttribute(name: "data-label", value: "File name")
    }
}
