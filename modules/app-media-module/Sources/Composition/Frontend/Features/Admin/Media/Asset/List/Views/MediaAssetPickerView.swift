import CSS
import FeatherAdmin
import FeatherContracts
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct MediaAssetPickerView: Component {
    struct State {
        let entries: [AdminListMediaAssetModel.EntryItem]
        let pageState: NewAdminListPageState
        let search: String
        let parentId: String?
        let currentFolder: Components.Schemas.MediaFolderDetailSchema?
        let ancestors: [Components.Schemas.MediaFolderDetailSchema]
        let view: AdminListMediaAssetModel.ViewMode
        let picker: AdminListMediaAssetModel.PickerState
    }

    let state: State

    func rules() -> [any CSS.Rule] {
        NewAdminListSearch(
            state: .init(
                action: "",
                placeholder: "",
                search: ""
            )
        ).rules() + [
            Media {
                Class("media-asset-picker") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(12.px)
                    Overflow(.visible)
                    MinHeight(0.px)
                }
                Class("media-asset-picker__body") {
                    Display(.flex)
                    FlexDirection(.column)
                    FlexGrow(1)
                    MinHeight(0.px)
                }
                Class("media-asset-picker__navigation") {
                    Display(.flex)
                    AlignItems(.center)
                    JustifyContent(.spaceBetween)
                    FlexWrap(.wrap)
                    Gap(12.px)
                }
                Class("media-asset-picker__path") {
                    Flex(1, .number(1), .auto)
                    MinWidth(0.px)
                    Overflow(.visible)
                }
                Custom(
                    ".media-asset-picker__path .new-admin-path-breadcrumb"
                ) {
                    MarginBottom(0.px)
                    MaxWidth(100.percent)
                    UnsafeRawProperty(name: "width", value: "fit-content")
                }
                Class("media-asset-picker__view") {
                    FlexShrink(0)
                }
                Class("media-asset-picker__search") {
                    Padding(3.px)
                    Overflow(.visible)
                }
                Custom(".media-asset-picker__search .new-admin-list-search") {
                    MarginBottom(0.px)
                }
                Class("media-asset-picker__grid") {
                    Display(.grid)
                    Gap(16.px)
                    UnsafeRawProperty(name: "align-items", value: "start")
                    UnsafeRawProperty(
                        name: "grid-template-columns",
                        value: "repeat(auto-fill, minmax(220px, 1fr))"
                    )
                }
                Class("media-asset-picker__card") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(8.px)
                    Padding(10.px)
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Primary.border)
                    )
                    BorderRadius(14.px)
                    Background(.variable(TokenKey.Colors.Materials.Primary.tint))
                }
                Class("media-asset-picker__preview") {
                    Display(.grid)
                    UnsafeRawProperty(name: "place-items", value: "center")
                    Position(.relative)
                    Overflow(.hidden)
                    BorderRadius(10.px)
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Secondary.border)
                    )
                    Background(
                        .variable(TokenKey.Colors.Materials.Secondary.tint)
                    )
                    UnsafeRawProperty(name: "aspect-ratio", value: "4 / 3")
                }
                Custom(".media-asset-picker__preview img") {
                    Position(.absolute)
                    UnsafeRawProperty(name: "inset", value: "0")
                    Width(100.percent)
                    Height(100.percent)
                    ObjectFit(.cover)
                    Display(.block)
                    Margin(0)
                }
                Custom(".media-asset-picker__preview svg") {
                    Width(3.rem)
                    Height(3.rem)
                    Color(.variable(TokenKey.Colors.Link.default))
                }
                Class("media-asset-picker__card-body") {
                    MinWidth(0.px)
                }
                Custom(".media-asset-picker__card-body h3") {
                    Margin(0)
                    FontSize(0.96.rem)
                    LineHeight(1.3)
                    WordBreak(.breakWord)
                }
                Class("media-asset-picker__card-actions") {
                    Display(.flex)
                    AlignItems(.center)
                    Gap(6.px)
                }
                Class("media-asset-picker__table-preview") {
                    Width(72.px)
                }
                Custom(".media-asset-picker__folder-icon") {
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
                    Background(
                        .variable(TokenKey.Colors.Materials.Secondary.tint)
                    )
                    Overflow(.hidden)
                }
                Custom(".media-asset-picker__folder-icon svg") {
                    Width(28.px)
                    Height(28.px)
                    Color(.variable(TokenKey.Colors.Link.default))
                }
                Custom(".media-asset-picker__table-preview a") {
                    Display(.inlineBlock)
                    TextDecoration(.none)
                }
                Custom(".media-asset-picker .table-shell") {
                    Overflow(.visible)
                }
                Custom(".media-asset-picker .table-shell .table-wrap") {
                    OverflowX(.auto)
                    OverflowY(.visible)
                    Padding(3.px)
                }
                Custom(".media-asset-picker .table-shell .cms-table") {
                    MinWidth(440.px)
                }
                Custom(".media-asset-picker .table-pagination") {
                    MarginTop(0.px)
                }
                Class("media-asset-picker__selection-actions") {
                    Display(.flex)
                    JustifyContent(.flexStart)
                    FlexShrink(0)
                    PaddingTop(12.px)
                    PaddingBottom(2.px)
                    BorderTop(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Tertiary.border)
                    )
                }
            },
            Media(.maxWidth(768.px)) {
                Custom(".media-asset-picker__navigation") {
                    AlignItems(.flexStart)
                }
                Custom(".media-asset-picker__view") {
                    Width(100.percent)
                }
            },
        ]
    }

    func html(context: inout BuilderContext) -> Section {
        Section {
            Div {
                Div {
                    Div {
                        context.build(
                            NewAdminPathBreadcrumb(items: folderPathItems())
                        )
                    }
                    .class("media-asset-picker__path")
                    context.build(viewSelector())
                        .class("media-asset-picker__view")
                }
            .class("media-asset-picker__navigation")

            Div {
                searchControls(context: &context)
            }
            .class("media-asset-picker__search")

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
                context.build(
                    NewAdminListEmptyState(
                        message: state.search.isEmpty
                            ? "No media assets or folders yet."
                            : "No media assets or folders match your search.",
                        icon: FeatherIcons.image()
                    )
                )
            }

            context.build(
                NewAdminListPagination(
                    state: .init(
                        path: MediaAssetRoutes.list.description,
                        pageState: state.pageState,
                        search: state.search,
                        queryItems: queryItems(
                            parentId: state.parentId,
                            view: state.view,
                            search: nil,
                            page: nil
                        )
                    )
                )
            )
        }
        .class("media-asset-picker__body")

        if state.picker.selectionMode == .multiple,
           state.picker.field != nil {
            Div {
                Button("Use assets")
                    .type(.button)
                    .class("button", "primary")
                    .data("picker-apply", "true")
                    .disabled()
            }
            .class("media-asset-picker__selection-actions")
            Div {}
                .data("media-picker-selection-markers", "true")
                .hidden()
            Script(multiSelectionScript())
        }
        else if state.picker.selectionMode == .single,
                state.picker.field != nil {
            Script(singleSelectionScript())
        }
        }
        .class("media-asset-picker")
        .data("media-picker-field", state.picker.field ?? "")
        .data("media-picker-selection", state.picker.selectionMode.rawValue)
        .data(
            "media-picker-reset-selection",
            state.picker.resetSelection ? "true" : "false"
        )
    }
}

private extension MediaAssetPickerView {
    var hasAnyResults: Bool {
        !state.entries.isEmpty || state.currentFolder != nil
    }

    func queryItems(
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
        items.append(.init(name: "picker", value: "1"))
        if let field = state.picker.field {
            items.append(.init(name: "field", value: field))
        }
        if !state.picker.allowedExtensions.isAnything {
            items.append(
                .init(
                    name: "extensions",
                    value: state.picker.allowedExtensions.queryValue
                )
            )
        }
        if parentId != nil,
            let defaultFolderPath = state.picker.defaultFolderPath
        {
            items.append(
                .init(name: "default_folder_path", value: defaultFolderPath)
            )
        }
        if let previewVariant = state.picker.previewVariant {
            items.append(
                .init(name: "preview_variant", value: previewVariant)
            )
        }
        items.append(
            .init(
                name: "selection",
                value: state.picker.selectionMode.rawValue
            )
        )
        if let search, !search.isEmpty {
            items.append(.init(name: "search", value: search))
        }
        if let page {
            items.append(.init(name: "page", value: "\(page)"))
        }
        return items
    }

    func browsePath(
        parentId: String?,
        view: AdminListMediaAssetModel.ViewMode? = nil,
        search: String? = nil,
        page: Int? = nil
    ) -> String {
        let items = queryItems(
            parentId: parentId,
            view: view ?? state.view,
            search: search,
            page: page
        )
        let encoded = items.map {
            "\($0.name)=\($0.value.queryEncoded())"
        }
        let path = MediaAssetRoutes.list.description
        return encoded.isEmpty
            ? path
            : "\(path)?\(encoded.joined(separator: "&"))"
    }

    func folderPathItems() -> [NewAdminPathBreadcrumb.Item] {
        var items: [NewAdminPathBreadcrumb.Item] = [
            .init(
                label: "My assets",
                href: browsePath(parentId: nil),
                isCurrent: state.currentFolder == nil
            )
        ]
        for ancestor in state.ancestors {
            items.append(
                .init(
                    label: ancestor.name,
                    href: browsePath(parentId: ancestor.id),
                    isCurrent: false
                )
            )
        }
        if let currentFolder = state.currentFolder {
            items.append(
                .init(label: currentFolder.name, isCurrent: true)
            )
        }
        return items
    }

    func viewSelector() -> NewAdminSegmentedControl {
        NewAdminSegmentedControl(
            links: [
                .init(
                    label: "Grid",
                    href: browsePath(parentId: state.parentId, view: .grid),
                    isCurrent: state.view == .grid
                ),
                .init(
                    label: "List",
                    href: browsePath(parentId: state.parentId, view: .list),
                    isCurrent: state.view == .list
                ),
            ]
        )
    }

    func searchControls(context: inout BuilderContext) -> Div {
        var search = context.build(
            NewAdminListSearch(
                state: .init(
                action: browsePath(parentId: state.parentId),
                    placeholder: "Quick search assets",
                    search: state.search,
                    resetPath: browsePath(parentId: state.parentId),
                queryItems: queryItems(
                    parentId: state.parentId,
                    view: state.view,
                    search: nil,
                    page: nil
                ).map {
                        .init(name: $0.name, value: $0.value)
                    }
                )
            )
        )
        search = search.data("admin-media-picker-search", "true")
        return Div {
            search
            Script(pickerSearchScript())
        }
    }

    func pickerSearchScript() -> String {
        #"""
        (function() {
          var forms = document.querySelectorAll(
            'form[data-admin-media-picker-search]'
          );
          forms.forEach(function(form) {
            if (form.dataset.dialogSearchReady === "true") { return; }
            form.dataset.dialogSearchReady = "true";
            form.addEventListener("submit", function(event) {
              if (!form.closest("dialog[data-admin-dialog]")) { return; }
              if (!window.__newAdminDialog ||
                  !window.__newAdminDialog.openURL) { return; }
              event.preventDefault();
              event.stopImmediatePropagation();
              var url = new URL(form.action, window.location.href);
              new FormData(form).forEach(function(value, key) {
                if (typeof value === "string") {
                  url.searchParams.set(key, value);
                }
              });
              window.__newAdminDialog.openURL(url.href, form.action);
            }, true);
          });
        }());
        """#
    }

    func multiSelectionScript() -> String {
        #"""
        (function() {
          var root = document.querySelector(
            '.media-asset-picker[data-media-picker-selection="multiple"]'
          );
          if (!root || root.dataset.multiSelectionReady === "true") { return; }
          root.dataset.multiSelectionReady = "true";
          var selected = new Map();
          var field = root.getAttribute('data-media-picker-field') || '';
          var storageKey = 'new-admin-media-picker:' + field;
          var apply = root.querySelector('[data-picker-apply]');
          var markers = root.querySelector('[data-media-picker-selection-markers]');

          if (root.getAttribute('data-media-picker-reset-selection') === 'true') {
            try { sessionStorage.removeItem(storageKey); } catch (_) {}
          }
          try {
            var stored = JSON.parse(sessionStorage.getItem(storageKey) || '[]');
            (Array.isArray(stored) ? stored : []).forEach(function(asset) {
              if (asset && asset.id) { selected.set(asset.id, asset); }
            });
          } catch (_) {}

          function assetFromNode(node) {
            return {
              id: node.getAttribute('data-picker-select'),
              url: node.getAttribute('data-picker-url') || '',
              previewURL: node.getAttribute('data-picker-preview-url') || '',
              name: node.getAttribute('data-picker-name') || '',
              extension: node.getAttribute('data-picker-extension') || '',
              title: node.getAttribute('data-picker-title') || '',
              altText: node.getAttribute('data-picker-alt-text') || '',
              status: node.getAttribute('data-picker-status') || ''
            };
          }

          function render() {
            root.querySelectorAll('[data-picker-select]').forEach(function(button) {
              var isSelected = selected.has(button.getAttribute('data-picker-select'));
              button.classList.toggle('is-selected', isSelected);
              button.textContent = isSelected ? 'Selected' : 'Select';
              button.setAttribute('aria-pressed', isSelected ? 'true' : 'false');
            });
            if (apply) { apply.disabled = selected.size === 0; }
            try {
              sessionStorage.setItem(
                storageKey,
                JSON.stringify(Array.from(selected.values()))
              );
            } catch (_) {}
            if (!markers) { return; }
            markers.replaceChildren();
            selected.forEach(function(asset) {
              var marker = document.createElement('div');
              marker.hidden = true;
              marker.setAttribute('data-media-picker-selected-id', asset.id);
              marker.setAttribute('data-media-picker-selected-url', asset.url);
              marker.setAttribute('data-media-picker-selected-preview-url', asset.previewURL);
              marker.setAttribute('data-media-picker-selected-name', asset.name);
              marker.setAttribute('data-media-picker-selected-extension', asset.extension);
              marker.setAttribute('data-media-picker-selected-title', asset.title);
              marker.setAttribute('data-media-picker-selected-alt-text', asset.altText);
              marker.setAttribute('data-media-picker-selected-status', asset.status);
              markers.appendChild(marker);
            });
          }

          root.addEventListener('click', function(event) {
            var button = event.target.closest && event.target.closest('[data-picker-select]');
            if (button) {
              event.preventDefault();
              event.stopPropagation();
              var id = button.getAttribute('data-picker-select');
              if (selected.has(id)) { selected.delete(id); }
              else { selected.set(id, assetFromNode(button)); }
              render();
              return;
            }
            var applyButton = event.target.closest && event.target.closest('[data-picker-apply]');
            if (applyButton && !applyButton.disabled) {
              document.dispatchEvent(
                new CustomEvent('new-admin-media-picker-selection', {
                  detail: {
                    field: field,
                    assets: Array.from(selected.values())
                  }
                })
              );
              try { sessionStorage.removeItem(storageKey); } catch (_) {}
              var dialog = root.closest('dialog[data-admin-dialog]');
              if (dialog) {
                if (dialog.close) { dialog.close(); }
                else { dialog.remove(); }
              }
            }
          });
          render();
        }());
        """#
    }

    func singleSelectionScript() -> String {
        #"""
        (function() {
          var root = document.querySelector(
            '.media-asset-picker[data-media-picker-selection="single"]'
          );
          if (!root || root.dataset.singleSelectionReady === "true") { return; }
          root.dataset.singleSelectionReady = "true";
          var field = root.getAttribute('data-media-picker-field') || '';

          function assetFromNode(node) {
            return {
              id: node.getAttribute('data-picker-select'),
              url: node.getAttribute('data-picker-url') || '',
              previewURL: node.getAttribute('data-picker-preview-url') || '',
              name: node.getAttribute('data-picker-name') || '',
              extension: node.getAttribute('data-picker-extension') || '',
              title: node.getAttribute('data-picker-title') || '',
              altText: node.getAttribute('data-picker-alt-text') || '',
              status: node.getAttribute('data-picker-status') || ''
            };
          }

          root.addEventListener('click', function(event) {
            var button = event.target.closest && event.target.closest(
              '[data-picker-select]'
            );
            if (!button) { return; }
            event.preventDefault();
            document.dispatchEvent(
              new CustomEvent('new-admin-media-picker-selection', {
                detail: {
                  field: field,
                  assets: [assetFromNode(button)]
                }
              })
            );
            var dialog = root.closest('dialog[data-admin-dialog]');
            if (dialog) {
              if (dialog.close) { dialog.close(); }
              else { dialog.remove(); }
            }
          });
        }());
        """#
    }

    func gridContent(context: inout BuilderContext) -> Div {
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
        .class("media-asset-picker__grid")
    }

    func upCard(
        parentId: String?,
        context: inout BuilderContext
    ) -> Div {
        let href = browsePath(parentId: parentId)
        return Div {
            A {
                Div { FeatherIcons.cornerUpLeft() }
                    .class("media-asset-picker__preview")
            }
            .href(href)
            .ariaLabel("Open parent folder")
            Div {
                H3("..")
                P("Parent folder")
            }
            .class("media-asset-picker__card-body")
            Div {
                context.build(
                    NewAdminRowButton("View", href: href, style: .ghost(.primary))
                )
            }
            .class("media-asset-picker__card-actions")
        }
        .class("media-asset-picker__card")
    }

    func folderCard(
        _ folder: Components.Schemas.MediaFolderListItemSchema,
        context: inout BuilderContext
    ) -> Div {
        let href = browsePath(parentId: folder.id)
        return Div {
            A {
                Div { FeatherIcons.folder() }
                    .class("media-asset-picker__preview")
            }
            .href(href)
            .ariaLabel("Open \(folder.name)")
            Div {
                H3(folder.name)
                P(
                    folder.assetCount == 1
                        ? "1 item" : "\(folder.assetCount) items"
                )
            }
            .class("media-asset-picker__card-body")
            Div {
                context.build(
                    NewAdminRowButton("View", href: href, style: .ghost(.primary))
                )
            }
            .class("media-asset-picker__card-actions")
        }
        .class("media-asset-picker__card")
    }

    func assetCard(
        _ item: AdminListMediaAssetModel.AssetItem,
        context: inout BuilderContext
    ) -> Div {
        return Div {
            Div {
                if let preview = item.preview {
                    Img(
                        src: NewAdminMediaAsset.mediaURL(path: preview.url),
                        alt: pickerTitle(for: item.asset)
                    )
                }
                else {
                    FeatherIcons.file()
                }
            }
            .class("media-asset-picker__preview")
            Div {
                H3(pickerTitle(for: item.asset))
            }
            .class("media-asset-picker__card-body")
            if let field = state.picker.field {
                Div {
                    context.build(
                        MediaAssetPickerSelectButton(
                            item: item.asset,
                            field: field,
                            preview: item.preview
                        )
                    )
                }
                .class("media-asset-picker__card-actions")
            }
        }
        .class("media-asset-picker__card")
    }

    func listContent(context: inout BuilderContext) -> some FlowContent {
        return context.build(
            NewAdminListShell(
            layout: .init(
                name: "media-asset-picker-list",
                columns: [.fixed(84), .fraction(1), .fixed(160)]
            ),
            hasSelection: false,
            table: Table {
                Thead {
                    Tr {
                        Th("Preview")
                        Th("Name")
                        Th("Actions")
                    }
                }
            Tbody {
                    if let currentFolder = state.currentFolder {
                        upRow(parentId: currentFolder.parentId, context: &context)
                    }
                    for entry in state.entries {
                        switch entry {
                        case .folder(let folder):
                            folderRow(folder, context: &context)
                        case .asset(let item):
                            assetRow(item, context: &context)
                        }
                    }
                }
            }
            .class("cms-table", "action-table")
            )
        )
    }

    func upRow(
        parentId: String?,
        context: inout BuilderContext
    ) -> Tr {
        let href = browsePath(parentId: parentId)
        return Tr {
            Td {
                A {
                    Div { FeatherIcons.cornerUpLeft() }
                        .class("media-asset-picker__folder-icon")
                }
                .href(href)
                .ariaLabel("Open parent folder")
            }
            .class("media-asset-picker__table-preview")
            .data("label", "Preview")
            Td("..").data("label", "Name")
            Td {
                context.build(
                    NewAdminRowButton("View", href: href, style: .ghost(.primary))
                )
            }
            .data("label", "Actions")
            .class("action-cell")
        }
    }

    func folderRow(
        _ folder: Components.Schemas.MediaFolderListItemSchema,
        context: inout BuilderContext
    ) -> Tr {
        let href = browsePath(parentId: folder.id)
        return Tr {
            Td {
                A {
                    Div { FeatherIcons.folder() }
                        .class("media-asset-picker__folder-icon")
                }
                .href(href)
                .ariaLabel("Open \(folder.name)")
            }
            .class("media-asset-picker__table-preview")
            .data("label", "Preview")
            Td(folder.name).data("label", "Name")
            Td {
                context.build(
                    NewAdminRowButton("View", href: href, style: .ghost(.primary))
                )
            }
            .data("label", "Actions")
            .class("action-cell")
        }
    }

    func assetRow(
        _ item: AdminListMediaAssetModel.AssetItem,
        context: inout BuilderContext
    ) -> Tr {
        Tr {
            Td {
                if let preview = item.preview {
                    context.build(
                        NewAdminImageCell(
                            imageURL: NewAdminMediaAsset.mediaURL(
                                path: preview.url
                            ),
                            alt: pickerTitle(for: item.asset),
                            size: .square
                        )
                    )
                }
                else {
                    Div {
                        FeatherIcons.file()
                    }
                    .class("media-asset-picker__folder-icon")
                }
            }
            .class("media-asset-picker__table-preview")
            .data("label", "Preview")
            Td(pickerTitle(for: item.asset)).data("label", "Name")
            Td {
                if let field = state.picker.field {
                    context.build(
                        MediaAssetPickerSelectButton(
                            item: item.asset,
                            field: field,
                            preview: item.preview
                        )
                    )
                }
            }
            .data("label", "Actions")
            .class("action-cell")
        }
    }

    func pickerTitle(
        for item: Components.Schemas.MediaAssetListItemSchema
    ) -> String {
        let title = item.title?.whitespaceTrimmed
        return title?.isEmpty == false ? title! : fileName(for: item)
    }

    func fileName(
        for item: Components.Schemas.MediaAssetListItemSchema
    ) -> String {
        item._extension.isEmpty ? item.name : "\(item.name).\(item._extension)"
    }
}

private struct MediaAssetPickerSelectButton: Component {
    let item: Components.Schemas.MediaAssetListItemSchema
    let field: String
    let preview: Components.Schemas.MediaAssetResolveVariantSchema?

    func html(context: inout BuilderContext) -> A {
        var button = context.build(
            NewAdminRowButton("Select", style: .primary)
        )
        button = button.data("picker-select", item.id)
        button = button.data("picker-field", field)
        button = button.data(
            "picker-url",
            NewAdminMediaAsset.mediaURL(path: item.url)
        )
        button = button.data(
            "picker-preview-url",
            preview.map {
                NewAdminMediaAsset.mediaURL(path: $0.url)
            } ?? ""
        )
        button = button.data("picker-name", item.name)
        button = button.data("picker-extension", item._extension)
        button = button.data("picker-title", pickerTitle(for: item))
        button = button.data("picker-alt-text", item.altText ?? "")
        button = button.data("picker-status", item.status)
        return button
    }

    private func pickerTitle(
        for item: Components.Schemas.MediaAssetListItemSchema
    ) -> String {
        let title = item.title?.whitespaceTrimmed
        return title?.isEmpty == false ? title! : item.name
    }
}
