import CSS
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import MediaContracts
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

import class Foundation.ByteCountFormatter
import struct Foundation.CharacterSet

struct AssetListView: Component {
    struct State {
        let entries: [AdminListMediaAssetModel.EntryItem]
        let pageState: NewAdminListPageState
        let search: String
        let parentId: String?
        let currentFolder: Components.Schemas.MediaFolderDetailSchema?
        let ancestors: [Components.Schemas.MediaFolderDetailSchema]
        let view: AdminListMediaAssetModel.ViewMode
        let picker: AdminListMediaAssetModel.PickerState
        let permissions: NewAdminListActions
    }

    let state: State

    func selectors() -> [any CSS.Selector] {
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
        Class("media-assets-grid") {
            Display(.grid)
            Gap(24.px)
            UnsafeRawProperty(name: "align-items", value: "start")
            UnsafeRawProperty(
                name: "grid-template-columns",
                value: "repeat(auto-fill, minmax(220px, 1fr))"
            )
        }
        Custom(".media-assets-grid > *") {
            Overflow(.hidden)
        }
        Class("media-assets-card") {
            Display(.flex)
            FlexDirection(.column)
            Gap(8.px)
            Padding(12.px)
            Border(
                1.px,
                .solid,
                .variable(TokenKey.Colors.Materials.Primary.border)
            )
            BorderRadius(18.px)
            Background(.variable(TokenKey.Colors.Materials.Primary.tint))
        }
        Class("media-assets-card-preview") {
            UnsafeRawProperty(name: "aspect-ratio", value: "4 / 3")
            Display(.grid)
            UnsafeRawProperty(name: "place-items", value: "center")
            Position(.relative)
            Overflow(.hidden)
            BorderRadius(14.px)
            Border(
                1.px,
                .solid,
                .variable(TokenKey.Colors.Materials.Secondary.border)
            )
            Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
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
            Gap(4.px)
        }
        Custom(".media-assets-card-body h3") {
            Margin(0)
            FontSize(1.rem)
            LineHeight(1.3)
        }
        Custom(".media-assets-card-body p") {
            Margin(0)
            Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
            FontSize(0.86.rem)
            WordBreak(.breakWord)
        }
        Class("media-assets-card-actions") {
            Display(.flex)
            FlexWrap(.wrap)
            Gap(6.px)
            MarginTop(0.px)
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
            Border(
                1.px,
                .solid,
                .variable(TokenKey.Colors.Materials.Secondary.border)
            )
            Background(.variable(TokenKey.Colors.Materials.Secondary.tint))
        }
        Custom(".media-assets-table-preview a") {
            Display(.inlineBlock)
            TextDecoration(.none)
        }
        Custom(".media-assets-table-preview img") {
            Width(56.px)
            Height(56.px)
            ObjectFit(.cover)
            BorderRadius(10.px)
            Display(.block)
            Margin(0)
        }
        Custom(".media-assets-table-preview .media-assets-folder-icon svg") {
            Width(28.px)
            Height(28.px)
        }
        Class("media-assets-folder-icon") {
            Color(.variable(TokenKey.Colors.Link.default))
        }
        Custom(".admin-list > .table-pagination") {
            MarginTop(8.px)
            Gap(20.px)
            Padding(vertical: 20.px, horizontal: 14.px)
        }
        Custom(".media-assets-folder-icon svg") {
            Width(2.5.rem)
            Height(2.5.rem)
        }
        Custom(
            ".media-assets-card-preview.media-assets-folder-icon svg, .media-assets-card-preview .media-assets-folder-icon svg"
        ) {
            Width(5.rem)
            Height(5.rem)
        }
    }

    func rules() -> [any CSS.Rule] {
        NewAdminListSearch(
            state: .init(
                action: "",
                placeholder: "",
                search: ""
            )
        )
        .rules() + [Media(selectors: selectors())]
    }

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            if !state.permissions.allows(MediaPermissions.Assets.list) {
                context.build(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message: "Your account cannot access media assets."
                        ),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                if !state.picker.isEnabled {
                    context.build(
                        NewAdminBreadcrumb(
                            links: MediaAssetRoutes.listBreadcrumb
                        )
                    )
                    context.build(
                        NewAdminPageHeader(
                            state: .init(
                                title: "Media assets",
                                description:
                                    "Browse, organize, and manage media assets."
                            )
                        )
                    )
                }

                context.build(
                    NewAdminList(
                        table: {
                            if state.pageState.isPageOutOfRange {
                                context.build(
                                    NewAdminListInvalidPageState(
                                        pageState: state.pageState,
                                        path: MediaAssetRoutes.list.description
                                    )
                                )
                            }
                            else if hasAnyResults {
                                switch state.view {
                                case .grid:
                                    gridContent(context: &context)
                                case .list:
                                    listContent(context: &context)
                                }
                            }
                            else {
                                emptyState(context: &context)
                            }
                        },
                        search: {
                            searchControls(context: &context)
                        },
                        toolbar: {
                            toolbar(context: &context)
                        },
                        pagination: {
                            context.build(
                                NewAdminListPagination(
                                    state: .init(
                                        path: MediaAssetRoutes.list.description,
                                        pageState: state.pageState,
                                        search: state.search,
                                        queryItems: queryItems()
                                    )
                                )
                            )
                        }
                    )
                )
            }
        }
        .class("cms-section")
        .if(state.picker.isEnabled) {
            $0.data(
                "admin-media-picker-section",
                "gallery"
            )
        }
    }
}

extension AssetListView {
    fileprivate var hasAnyResults: Bool {
        !state.entries.isEmpty || state.currentFolder != nil
    }

    fileprivate func queryItems() -> [NewAdminListPagination.QueryItem] {
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
    ) -> [NewAdminListPagination.QueryItem] {
        var items: [NewAdminListPagination.QueryItem] = []
        if let parentId {
            items.append(.init(name: "parent_id", value: parentId))
        }
        if view != .grid {
            items.append(.init(name: "view", value: view.rawValue))
        }
        if state.picker.isEnabled {
            items.append(.init(name: "picker", value: "1"))
        }
        if let field = state.picker.field {
            items.append(.init(name: "field", value: field))
        }
        if !state.picker.allowedExtensions.isEmpty {
            items.append(
                .init(
                    name: "extensions",
                    value: state.picker.allowedExtensions.joined(separator: ",")
                )
            )
        }
        if let defaultFolderPath = state.picker.defaultFolderPath {
            items.append(
                .init(name: "default_folder_path", value: defaultFolderPath)
            )
        }
        if let search, !search.isEmpty {
            items.append(.init(name: "search", value: search))
        }
        if let page {
            items.append(.init(name: "page", value: "\(page)"))
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
        let path = MediaAssetRoutes.add.description
        return suffix.isEmpty
            ? path
            : "\(path)?\(suffix.joined(separator: "&"))"
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
        let path = MediaFolderRoutes.add.description
        return suffix.isEmpty
            ? path
            : "\(path)?\(suffix.joined(separator: "&"))"
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
        let encoded = query.map { "\($0.name)=\($0.value.queryEncoded())" }
        let path = MediaAssetRoutes.list.description
        return encoded.isEmpty
            ? path
            : "\(path)?\(encoded.joined(separator: "&"))"
    }

    fileprivate func previewLink(
        for storageKey: String,
        isVariant: Bool
    ) -> String {
        NewAdminMediaAsset.mediaURL(
            storageKey: storageKey,
            isVariant: isVariant
        )
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
        MediaFolderRoutes.edit(RouterPath(folder.id)).description
    }

    fileprivate func toolbar(context: inout BuilderContext) -> some FlowContent
    {
        Div {
            if state.permissions.allows(MediaPermissions.Assets.create)
                && !state.picker.isEnabled
            {
                context.build(
                    NewAdminButton("Add asset", href: addAssetPath())
                )
            }
            if state.permissions.allows(MediaPermissions.Assets.create)
                && !state.picker.isEnabled
            {
                context.build(
                    NewAdminButton(
                        "Add folder",
                        href: addFolderPath(),
                        style: .secondary
                    )
                )
            }
        }
        .class("button-row", "media-assets-toolbar-group")
    }

    fileprivate func searchControls(
        context: inout BuilderContext
    ) -> some FlowContent {
        Div {
            context.build(
                NewAdminTabBar(
                    links: [
                        .init(
                            label: "Grid",
                            href: browsePath(
                                parentId: state.parentId,
                                view: .grid,
                                search: state.search.isEmpty
                                    ? nil : state.search,
                                page: state.pageState.page
                            ),
                            isCurrent: state.view == .grid
                        ),
                        .init(
                            label: "List",
                            href: browsePath(
                                parentId: state.parentId,
                                view: .list,
                                search: state.search.isEmpty
                                    ? nil : state.search,
                                page: state.pageState.page
                            ),
                            isCurrent: state.view == .list
                        ),
                    ]
                )
            )
            if state.picker.isEnabled {
                pickerSearchControls(context: &context)
            }
            else {
                context.build(
                    NewAdminListSearch(
                        state: .init(
                            action: MediaAssetRoutes.list.description,
                            placeholder: "Quick search assets",
                            search: state.search,
                            resetPath: browsePath(parentId: state.parentId),
                            queryItems: queryItems()
                                .map {
                                    .init(name: $0.name, value: $0.value)
                                }
                        )
                    )
                )
            }
        }
        .class("media-assets-search-row")
    }

    fileprivate func pickerSearchControls(
        context: inout BuilderContext
    ) -> some FlowContent {
        context.build(
            NewAdminListSearch(
                state: .init(
                    action: browsePath(parentId: state.parentId),
                    placeholder: "Quick search assets",
                    search: state.search,
                    resetPath: browsePath(parentId: state.parentId),
                    queryItems: queryItems()
                        .map {
                            .init(name: $0.name, value: $0.value)
                        }
                )
            )
        )
        .data(
            "admin-media-picker-search-path",
            browsePath(parentId: state.parentId)
        )
    }

    fileprivate func emptyState(
        context: inout BuilderContext
    ) -> some FlowContent {
        if state.search.isEmpty {
            return context.build(
                NewAdminListEmptyState(
                    message: "No media assets or folders yet.",
                    icon: FeatherIcons.image(),
                    action: {
                        if state.permissions.allows(
                            MediaPermissions.Assets.create
                        ) && !state.picker.isEnabled {
                            context.build(
                                NewAdminButton(
                                    "Add asset",
                                    href: addAssetPath()
                                )
                            )
                        }
                    }
                )
            )
        }
        return context.build(
            NewAdminListNoResultsState(
                message: "No media assets or folders match your search.",
                icon: FeatherIcons.image(),
                action: {
                    context.build(
                        NewAdminButton(
                            "Reset search",
                            href: browsePath(parentId: state.parentId),
                            style: .secondary
                        )
                    )
                }
            )
        )
    }

    fileprivate func gridContent(context: inout BuilderContext)
        -> some FlowContent
    {
        Div {
            if let currentFolder = state.currentFolder {
                upCard(parentId: currentFolder.parentId, context: &context)
            }
            for entry in state.entries {
                switch entry {
                case .folder(let folder):
                    folderCard(folder, context: &context)
                case .asset(let item):
                    assetCard(item, context: &context)
                }
            }
        }
        .class("media-assets-grid")
    }

    fileprivate func listContent(context: inout BuilderContext)
        -> some FlowContent
    {
        let canRemove =
            state.permissions.allows(MediaPermissions.Assets.delete)
            && !state.picker.isEnabled
        let returnTo = browsePath(
            parentId: state.parentId,
            search: state.search.isEmpty ? nil : state.search,
            page: state.pageState.page
        )
        return context.build(
            NewAdminListSelectionForm(
                state: .init(
                    action: NewAdminLocation.remove(
                        path: MediaAssetRoutes.remove.description,
                        ids: [],
                        returnTo: returnTo
                    ),
                    pageState: state.pageState,
                    search: state.search,
                    button: .init("Remove selected", style: .destructive),
                    isEnabled: canRemove
                ),
                table: context.build(
                    NewAdminListShell(
                        layout: .init(
                            name: "media-assets",
                            columns: [
                                .fixed(84),
                                .fraction(2),
                                .fixed(100),
                                .fixed(120),
                                .fixed(260),
                            ]
                        ),
                        hasSelection: canRemove,
                        table: Table {
                            Thead {
                                Tr {
                                    if canRemove {
                                        context.build(
                                            NewAdminListSelectAllCheckbox()
                                        )
                                    }
                                    Th("Preview")
                                    Th("Name")
                                    Th("Type")
                                    Th("Size")
                                    Th("Actions")
                                }
                            }
                            Tbody {
                                if let currentFolder = state.currentFolder {
                                    upRow(
                                        parentId: currentFolder.parentId,
                                        canRemove: canRemove,
                                        context: &context
                                    )
                                }
                                for entry in state.entries {
                                    switch entry {
                                    case .folder(let folder):
                                        folderRow(
                                            folder,
                                            canRemove: canRemove,
                                            returnTo: returnTo,
                                            context: &context
                                        )
                                    case .asset(let item):
                                        assetRow(
                                            item,
                                            canRemove: canRemove,
                                            returnTo: returnTo,
                                            context: &context
                                        )
                                    }
                                }
                            }
                        }
                        .class("cms-table", "action-table")
                        .if(canRemove) { $0.class("select-table") }
                    )
                )
            )
        )
    }

    fileprivate func upCard(
        parentId: String?,
        context: inout BuilderContext
    ) -> some FlowContent {

        Div {
            A {
                Div {
                    FeatherIcons.cornerUpLeft()
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
                context.build(
                    NewAdminRowButton(
                        "Open",
                        href: browsePath(parentId: parentId),
                        style: .ghost(.secondary)
                    )
                )
            }
            .class("media-assets-card-actions")
        }
        .class("media-assets-card")
    }

    fileprivate func folderCard(
        _ folder: Components.Schemas.MediaFolderListItemSchema,
        context: inout BuilderContext
    ) -> some FlowContent {
        let actionSuffix = assetActionSuffix()

        return Div {
            A {
                Div {
                    FeatherIcons.folder()
                }
                .class("media-assets-card-preview", "media-assets-folder-icon")
            }
            .href(browsePath(parentId: folder.id))

            Div {
                H3 {
                    folder.name
                }
                P(folderItemCountLabel(for: folder))
            }
            .class("media-assets-card-body")

            Div {
                context.build(
                    NewAdminRowButton(
                        "View",
                        href: browsePath(parentId: folder.id),
                        style: .ghost(.primary)
                    )
                )
                if state.permissions.allows(MediaPermissions.Assets.update)
                    && !state.picker.isEnabled
                {
                    context.build(
                        NewAdminRowButton(
                            "Edit",
                            href: folderEditPath(folder),
                            style: .ghost(.secondary)
                        )
                    )
                }
                if state.permissions.allows(MediaPermissions.Assets.delete)
                    && !state.picker.isEnabled
                {
                    context.build(
                        NewAdminRowButton(
                            "Remove",
                            href:
                                "\(MediaAssetRoutes.remove(RouterPath(folder.id)).description)\(actionSuffix)",
                            style: .destructive
                        )
                    )
                }
            }
            .class("media-assets-card-actions")
        }
        .class("media-assets-card")
    }

    fileprivate func assetCard(
        _ item: AdminListMediaAssetModel.AssetItem,
        context: inout BuilderContext
    ) -> some FlowContent {

        let actionSuffix = assetActionSuffix()
        let detailsURL =
            "\(MediaAssetRoutes.details(RouterPath(item.asset.id)).description)\(actionSuffix)"
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
                                FeatherIcons.file()
                            }
                            .class("media-assets-folder-icon")
                        }
                    }
                    .class("media-assets-card-preview")
                }
                .type(.button)
                .class("media-assets-card-preview-button")
                .data("picker-select", item.asset.id)
                .data("picker-field", field)
                .data(
                    "picker-storage-key",
                    NewAdminMediaAsset.normalizedStorageKey(
                        item.asset.storageKey
                    )
                )
                .data(
                    "picker-preview-storage-key",
                    NewAdminMediaAsset.normalizedStorageKey(
                        item.preview?.storageKey ?? ""
                    )
                )
                .data("picker-base-name", item.asset.baseName)
                .data("picker-type", item.asset._type)
                .data("picker-title", item.asset.title ?? "")
                .data("picker-alt-text", item.asset.altText ?? "")
                .data("picker-status", item.asset.status)
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
                                FeatherIcons.file()
                            }
                            .class("media-assets-folder-icon")
                        }
                    }
                    .class("media-assets-card-preview")
                }
                .href(originalURL)
                .target(.blank)
            }

            Div {
                H3(displayTitle(for: item.asset))
                P(fileSizeLabel(bytes: item.asset.sizeBytes))
            }
            .class("media-assets-card-body")

            Div {
                if state.picker.isEnabled, let field = state.picker.field {
                    context.build(
                        NewAdminRowButton(
                            "Select",
                            style: .ghost(.primary)
                        )
                    )
                    .data("picker-select", item.asset.id)
                    .data("picker-field", field)
                    .data(
                        "picker-storage-key",
                        NewAdminMediaAsset.normalizedStorageKey(
                            item.asset.storageKey
                        )
                    )
                    .data(
                        "picker-preview-storage-key",
                        NewAdminMediaAsset.normalizedStorageKey(
                            item.preview?.storageKey ?? ""
                        )
                    )
                    .data("picker-base-name", item.asset.baseName)
                    .data("picker-type", item.asset._type)
                    .data("picker-title", item.asset.title ?? "")
                    .data("picker-alt-text", item.asset.altText ?? "")
                    .data("picker-status", item.asset.status)
                }
                else if state.permissions.allows(MediaPermissions.Assets.read) {
                    context.build(
                        NewAdminRowButton(
                            "View",
                            href: detailsURL,
                            style: .ghost(.primary)
                        )
                    )
                }
                if state.permissions.allows(MediaPermissions.Assets.update)
                    && !state.picker.isEnabled
                {
                    context.build(
                        NewAdminRowButton(
                            "Edit",
                            href:
                                "\(MediaAssetRoutes.edit(RouterPath(item.asset.id)).description)\(actionSuffix)",
                            style: .ghost(.secondary)
                        )
                    )
                }
                if state.permissions.allows(MediaPermissions.Assets.delete)
                    && !state.picker.isEnabled
                {
                    context.build(
                        NewAdminRowButton(
                            "Remove",
                            href:
                                "\(MediaAssetRoutes.remove(RouterPath(item.asset.id)).description)\(actionSuffix)",
                            style: .destructive
                        )
                    )
                }
            }
            .class("media-assets-card-actions")
        }
        .class("media-assets-card")
    }

    fileprivate func upRow(
        parentId: String?,
        canRemove: Bool,
        context: inout BuilderContext
    ) -> some BasicTag {
        Tr {
            if canRemove {
                Td("")
            }
            parentPreviewCell(
                href: browsePath(parentId: parentId),
                context: &context
            )
            Td {
                A("Up to parent").href(browsePath(parentId: parentId))
            }
            .data("label", "Name")
            Td("")
                .data("label", "Type")
            Td("-")
                .data("label", "Size")
            Td {
                context.build(
                    NewAdminRowButton(
                        "Open",
                        href: browsePath(parentId: parentId),
                        style: .ghost(.secondary)
                    )
                )
            }
            .data("label", "Actions")
            .class("action-cell")
        }
    }

    fileprivate func folderRow(
        _ folder: Components.Schemas.MediaFolderListItemSchema,
        canRemove: Bool,
        returnTo: String,
        context: inout BuilderContext
    ) -> some BasicTag {
        Tr {
            let actions: [NewAdminListRowActions.Action] =
                state.picker.isEnabled
                ? [
                    .init(
                        "View",
                        href: browsePath(parentId: folder.id),
                        style: .ghost(.primary),
                        permission: MediaPermissions.Assets.read
                    )
                ]
                : [
                    .init(
                        "View",
                        href: browsePath(parentId: folder.id),
                        style: .ghost(.primary),
                        permission: MediaPermissions.Assets.read
                    ),
                    .init(
                        "Edit",
                        href: folderEditPath(folder),
                        style: .ghost(.secondary),
                        permission: MediaPermissions.Assets.update
                    ),
                    .init(
                        "Remove",
                        href: NewAdminLocation.remove(
                            path: MediaAssetRoutes.remove.description,
                            ids: [folder.id],
                            returnTo: returnTo
                        ),
                        style: .destructive,
                        permission: MediaPermissions.Assets.delete
                    ),
                ]
            if canRemove {
                context.build(
                    NewAdminListRowCheckbox(id: folder.id)
                )
            }
            folderPreviewCell(
                label: folder.name,
                href: browsePath(parentId: folder.id),
                context: &context
            )
            folderTitleCell(for: folder)
            Td("Folder")
                .data("label", "Type")
            Td(folderItemCountLabel(for: folder))
                .data("label", "Size")
            context.build(
                NewAdminListRowActions(
                    label: "Actions",
                    actions: actions,
                    permissions: state.permissions
                )
            )
        }
    }

    fileprivate func assetRow(
        _ item: AdminListMediaAssetModel.AssetItem,
        canRemove: Bool,
        returnTo: String,
        context: inout BuilderContext
    ) -> some BasicTag {

        let previewURL = previewLink(
            for: item.preview?.storageKey ?? item.asset.storageKey,
            isVariant: item.preview != nil
        )
        let originalURL = assetOriginalLink(for: item.asset)
        return Tr {
            if canRemove {
                context.build(
                    NewAdminListRowCheckbox(id: item.asset.id)
                )
            }
            assetPreviewCell(
                for: item,
                previewURL: previewURL,
                originalURL: originalURL,
                context: &context
            )
            assetTitleCell(
                for: item,
                originalURL: originalURL,
                context: &context
            )
            Td(item.asset._type)
                .data("label", "Type")
            Td(fileSizeLabel(bytes: item.asset.sizeBytes))
                .data("label", "Size")
            if state.picker.isEnabled, let field = state.picker.field {
                Td {
                    context.build(
                        NewAdminRowButton(
                            "Select",
                            style: .ghost(.primary)
                        )
                    )
                    .data(
                        "picker-select",
                        item.asset.id
                    )
                    .data("picker-field", field)
                    .data(
                        "picker-storage-key",
                        NewAdminMediaAsset.normalizedStorageKey(
                            item.asset.storageKey
                        )
                    )
                    .data(
                        "picker-preview-storage-key",
                        NewAdminMediaAsset.normalizedStorageKey(
                            item.preview?.storageKey ?? ""
                        )
                    )
                    .data(
                        "picker-base-name",
                        item.asset.baseName
                    )
                    .data(
                        "picker-type",
                        item.asset._type
                    )
                    .data(
                        "picker-title",
                        item.asset.title ?? ""
                    )
                    .data(
                        "picker-alt-text",
                        item.asset.altText ?? ""
                    )
                    .data(
                        "picker-status",
                        item.asset.status
                    )
                }
                .data("label", "Actions")
                .class("action-cell")
            }
            else {
                context.build(
                    NewAdminListRowActions(
                        label: "Actions",
                        actions: [
                            .init(
                                "View",
                                href:
                                    "\(MediaAssetRoutes.details(RouterPath(item.asset.id)).description)\(assetActionSuffix())",
                                style: .ghost(.primary),
                                permission: MediaPermissions.Assets.read
                            ),
                            .init(
                                "Edit",
                                href:
                                    "\(MediaAssetRoutes.edit(RouterPath(item.asset.id)).description)\(assetActionSuffix())",
                                style: .ghost(.secondary),
                                permission: MediaPermissions.Assets.update
                            ),
                            .init(
                                "Remove",
                                href: NewAdminLocation.remove(
                                    path: MediaAssetRoutes.remove.description,
                                    ids: [item.asset.id],
                                    returnTo: returnTo
                                ),
                                style: .destructive,
                                permission: MediaPermissions.Assets.delete
                            ),
                        ],
                        permissions: state.permissions
                    )
                )
            }
        }
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

    fileprivate func parentPreviewCell(
        href: String,
        context: inout BuilderContext
    ) -> some BasicTag {

        Td {
            A {
                Div {
                    FeatherIcons.cornerUpLeft()
                }
                .class("media-assets-folder-icon")
            }
            .href(href)
            .ariaLabel("Open parent folder")
        }
        .class("media-assets-table-preview")
        .data("label", "Preview")
        .ariaLabel("Parent folder")
    }

    fileprivate func folderPreviewCell(
        label: String,
        href: String,
        context: inout BuilderContext
    ) -> some BasicTag {

        Td {
            A {
                Div {
                    FeatherIcons.folder()
                }
                .class("media-assets-folder-icon")
            }
            .href(href)
            .ariaLabel("Open \(label)")
        }
        .class("media-assets-table-preview")
        .data("label", "Preview")
        .ariaLabel(label)
    }

    fileprivate func assetPreviewCell(
        for item: AdminListMediaAssetModel.AssetItem,
        previewURL: String,
        originalURL: String,
        context: inout BuilderContext
    ) -> some BasicTag {

        Td {
            A {
                if item.preview != nil {
                    Img(src: previewURL, alt: displayTitle(for: item.asset))
                }
                else {
                    Div {
                        FeatherIcons.file()
                    }
                    .class("media-assets-folder-icon")
                }
            }
            .href(originalURL)
            .target(.blank)
            .ariaLabel("Open \(displayTitle(for: item.asset))")
        }
        .class("media-assets-table-preview")
        .data("label", "Preview")
    }

    fileprivate func folderTitleCell(
        for folder: Components.Schemas.MediaFolderListItemSchema
    ) -> some BasicTag {
        Td(folder.name)
            .data("label", "Name")
    }

    fileprivate func assetTitleCell(
        for item: AdminListMediaAssetModel.AssetItem,
        originalURL: String,
        context: inout BuilderContext
    ) -> some BasicTag {

        Td {
            Span {
                Span(fileName(for: item.asset))
                context.build(
                    NewAdminPreviewLink(
                        href: originalURL,
                        label: "Preview \(displayTitle(for: item.asset))"
                    )
                )
            }
            .style(
                "display:inline-flex;align-items:center;gap:0.35rem;vertical-align:middle;line-height:1.25;"
            )
        }
        .data("label", "Name")
    }
}
