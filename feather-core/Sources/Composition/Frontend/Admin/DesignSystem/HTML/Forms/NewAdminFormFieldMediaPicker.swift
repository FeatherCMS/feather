public import CSS
import Foundation
import FeatherContracts
public import HTML
import SGML
import WebBuilders
public import WebComponents

public struct NewAdminFormFieldMediaPicker: Component {
    public enum OutputMode: String, Sendable {
        case assetId
        case originalURL = "original_url"
        case relativeURL = "relative_url"
    }

    public struct FieldState: Sendable {
        public let key: String
        public let label: String
        public let value: String?
        public let error: String?
        public let isRequired: Bool

        public init(
            key: String,
            label: String,
            value: String?,
            error: String?,
            isRequired: Bool = false
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
            self.isRequired = isRequired
        }
    }

    public struct State: Sendable {
        public let field: FieldState
        public let selectedAsset: NewAdminMediaAsset?
        public let browsePath: String
        public let defaultFolderPath: String?
        public let allowedExtensions: AllowedExtensions
        public let outputMode: OutputMode
        public let showsCurrentCard: Bool

        public init(
            field: FieldState,
            selectedAsset: NewAdminMediaAsset?,
            browsePath: String,
            defaultFolderPath: String? = nil,
            allowedExtensions: AllowedExtensions,
            outputMode: OutputMode = .assetId,
            showsCurrentCard: Bool = true
        ) {
            self.field = field
            self.selectedAsset = selectedAsset
            self.browsePath = browsePath
            self.defaultFolderPath = defaultFolderPath
            self.allowedExtensions = allowedExtensions
            self.outputMode = outputMode
            self.showsCurrentCard = showsCurrentCard
        }
    }

    public let state: State

    public init(state: State) {
        self.state = state
    }

    public func rules() -> [any Rule] {
        let root = ".new-admin-media-picker"

        return [
            Media {
                Custom(root) {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(8.px)
                }
                Custom("\(root) label") {
                    Display(.flex)
                    FlexDirection(.column)
                    Gap(8.px)
                }
                Custom("\(root) input[type='hidden']") {
                    Position(.absolute)
                    Width(1.px)
                    Height(1.px)
                    Overflow(.hidden)
                    UnsafeRawProperty(name: "clip", value: "rect(0 0 0 0)")
                    WhiteSpace(.nowrap)
                }
                Custom("\(root)__current") {
                    Display(.grid)
                    GridTemplateColumns(
                        .tracks([.length(136.px), .fraction(1.fr)])
                    )
                    AlignItems(.center)
                    Gap(16.px)
                    Padding(14.px)
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Tertiary.border)
                    )
                    BorderRadius(12.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
                }
                Custom("\(root)__preview") {
                    Width(120.px)
                    Height(120.px)
                    Display(.grid)
                    UnsafeRawProperty(name: "place-items", value: "center")
                    Overflow(.hidden)
                    BorderRadius(10.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Secondary.tint)
                    )
                    Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                }
                Custom("\(root)__preview img") {
                    Width(100.percent)
                    Height(100.percent)
                    ObjectFit(.cover)
                    Display(.block)
                    Margin(0)
                }
                Custom("\(root)__preview svg") {
                    Width(44.px)
                    Height(44.px)
                }
                Custom("\(root)__current h3") {
                    Margin(top: 0.px, right: 0.px, bottom: 8.px, left: 0.px)
                    Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                    FontSize(1.rem)
                    WordBreak(.breakWord)
                }
                Custom("\(root)__current h3.is-empty") {
                    Color(.variable(TokenKey.Colors.Materials.Primary.text))
                }
                Custom("\(root)__actions") {
                    Display(.flex)
                    FlexWrap(.wrap)
                    AlignItems(.center)
                    Gap(8.px)
                }
            },
            Media(.screen && .maxWidth(600.px)) {
                Custom("\(root)__current") {
                    GridTemplateColumns(.fraction(1.fr))
                }
            },
        ]
    }

    public func html(context: inout BuilderContext) -> Section {
        Section {
            Label {
                context.build(
                    NewAdminFormFieldLabel(
                        text: state.field.label,
                        isRequired: state.field.isRequired
                    )
                )
                Input()
                    .type(.hidden)
                    .id(state.field.key)
                    .name(state.field.key)
                    .value(state.field.value)
                    .if(state.field.isRequired) { $0.required() }
            }
            if state.showsCurrentCard {
                currentCard(context: &context)
            }
            else {
                pickerActions(context: &context)
            }
            if let error = state.field.error {
                Span(error).class("field-error")
            }
            Script(pickerScript())
        }
        .if(state.field.error != nil) { $0.class("has-error") }
        .class("new-admin-media-picker")
        .data("media-picker-field", state.field.key)
        .data("media-picker-output", state.outputMode.rawValue)
    }
}

extension NewAdminFormFieldMediaPicker {
    fileprivate func currentCard(context: inout BuilderContext)
        -> some FlowContent
    {
        let hasSelectedAsset = state.field.value?.isEmpty == false

        return Div {
            previewBlock()
            Div {
                H3(state.selectedAsset.map(displayTitle) ?? "No asset selected")
                    .if(!hasSelectedAsset) { $0.class("is-empty") }
                    .data("media-picker-title", state.field.key)
                    .data("empty-title", "No asset selected")
                Div {
                    pickerActions(context: &context)
                    context.build(
                        NewAdminControlButton(
                            "Clear",
                            style: hasSelectedAsset ? .destructive : .disabled
                        )
                    )
                    .class("new-admin-media-picker__clear", "row-button")
                    .data("media-picker-clear", state.field.key)
                }
                .class("new-admin-media-picker__actions")
            }
        }
        .class("new-admin-media-picker__current")
    }

    fileprivate func pickerActions(context: inout BuilderContext) -> some FlowContent {
        Div {
            context.build(
                MediaPickerDialogButton(
                    label: "Choose from assets",
                    style: .ghost(.primary),
                    url: dialogBrowsePath(),
                    field: state.field.key
                )
            )
            .class("new-admin-media-picker__choose", "row-button")
            context.build(
                MediaPickerDialogButton(
                    label: "Upload",
                    style: .ghost(.secondary),
                    url: dialogUploadPath(),
                    field: state.field.key
                )
            )
            .class("new-admin-media-picker__upload", "row-button")
        }
        .class("new-admin-media-picker__actions")
    }

    fileprivate func previewBlock() -> some FlowContent {
        Div {
            if let selectedAsset = state.selectedAsset {
                if let previewURL = previewURL(for: selectedAsset) {
                    Img(src: previewURL, alt: displayTitle(selectedAsset))
                }
                else {
                    FeatherIcons.file()
                }
            }
            else {
                FeatherIcons.image()
            }
        }
        .class("new-admin-media-picker__preview")
        .data("media-picker-preview", state.field.key)
    }

    fileprivate func pickerScript() -> String {
        #"""
        (function() {
          function escapeHTML(value) {
            return String(value || "")
              .replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/\"/g, "&quot;")
              .replace(/'/g, "&#39;");
          }

          function titleFor(asset) {
            var title = String(asset && asset.title || "").trim();
            return title || String(asset && asset.name || "No asset selected");
          }

          function previewFor(asset) {
            if (asset && asset.previewURL) {
              return '<img src="' + escapeHTML(asset.previewURL) + '" alt="' +
                escapeHTML(titleFor(asset)) + '">';
            }
            return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><path d="M14 2v6h6"></path></svg>';
          }

          function outputMode(field) {
            var root = document.querySelector(
              '[data-media-picker-field="' + field + '"]'
            );
            return root ? root.getAttribute("data-media-picker-output") : "assetId";
          }

          function update(field, asset) {
            var input = document.getElementById(field);
            var mode = outputMode(field);
            if (input) {
              input.value = asset && (mode === "original_url" || mode === "relative_url")
                ? String(asset.url || "")
                : asset ? String(asset.id || "") : "";
              input.dispatchEvent(new Event("change", { bubbles: true }));
            }
            var preview = document.querySelector(
              '[data-media-picker-preview="' + field + '"]'
            );
            if (preview) { preview.innerHTML = previewFor(asset); }
            var title = document.querySelector(
              '[data-media-picker-title="' + field + '"]'
            );
            if (title) {
              title.textContent = asset ? titleFor(asset) : title.getAttribute("data-empty-title");
              title.classList.toggle("is-empty", !asset);
            }
            var clear = document.querySelector(
              '[data-media-picker-clear="' + field + '"]'
            );
            if (clear) {
              clear.disabled = !asset;
              clear.classList.toggle("destructive", !!asset);
              clear.classList.toggle("disabled", !asset);
            }
          }

          function close(dialog) {
            if (!dialog) { return; }
            if (dialog.close) { dialog.close(); }
            else { dialog.remove(); }
          }

          function assetFromNode(node) {
            return {
              id: node.getAttribute("data-picker-select"),
              url: node.getAttribute("data-picker-url"),
              previewURL: node.getAttribute("data-picker-preview-url"),
              name: node.getAttribute("data-picker-name"),
              extension: node.getAttribute("data-picker-extension"),
              title: node.getAttribute("data-picker-title")
            };
          }

          function applyMarker(dialog) {
            if (!dialog || !dialog.matches("dialog[data-admin-dialog]")) { return; }
            var marker = dialog.querySelector("[data-media-picker-selected-id]");
            var field = dialog.getAttribute("data-media-picker-field");
            if (!marker || !field) { return; }
            update(field, {
              id: marker.getAttribute("data-media-picker-selected-id"),
              url: marker.getAttribute("data-media-picker-selected-url"),
              previewURL: marker.getAttribute("data-media-picker-selected-preview-url"),
              name: marker.getAttribute("data-media-picker-selected-name"),
              extension: marker.getAttribute("data-media-picker-selected-extension"),
              title: marker.getAttribute("data-media-picker-selected-title")
            });
            close(dialog);
          }

          if (!window.__newAdminMediaPickerController) {
            window.__newAdminMediaPickerController = true;
            document.addEventListener("click", function(event) {
              var select = event.target.closest && event.target.closest("[data-picker-select]");
              if (select) {
                event.preventDefault();
                var field = select.getAttribute("data-picker-field");
                if (field) {
                  update(field, assetFromNode(select));
                  close(select.closest("dialog[data-admin-dialog]"));
                }
                return;
              }
              var clear = event.target.closest && event.target.closest("[data-media-picker-clear]");
              if (clear) {
                update(clear.getAttribute("data-media-picker-clear"), null);
              }
            });
            var host = document.getElementById("new-admin-dialog-host");
            if (host && window.MutationObserver) {
              new MutationObserver(function() {
                host.querySelectorAll("dialog[data-admin-dialog]").forEach(applyMarker);
              }).observe(host, { childList: true, subtree: true });
            }
          }
        }());
        """#
    }

    fileprivate func displayTitle(_ asset: NewAdminMediaAsset) -> String {
        let title = asset.title?.whitespaceTrimmed
        return title?.isEmpty == false ? title! : asset.name
    }

    fileprivate func previewURL(for asset: NewAdminMediaAsset) -> String? {
        asset.previewURL.map(NewAdminMediaAsset.mediaURL(path:))
    }

    fileprivate func dialogBrowsePath() -> String {
        dialogPath(state.browsePath)
    }

    fileprivate func dialogUploadPath() -> String {
        let marker = "/admin/media/assets/"
        let addMarker = "/admin/media/assets/add/"
        let path: String
        if let range = state.browsePath.range(of: marker) {
            path = state.browsePath.replacingCharacters(in: range, with: addMarker)
        }
        else {
            path = state.browsePath
        }
        return dialogPath(path)
    }

    fileprivate func dialogPath(_ path: String) -> String {
        var query: [String] = []
        if !state.allowedExtensions.isAnything && !path.contains("extensions=") {
            query.append(
                "extensions=\(state.allowedExtensions.queryValue.queryEncoded())"
            )
        }
        if let defaultFolderPath = state.defaultFolderPath,
           !defaultFolderPath.isEmpty {
            query.append("default_folder_path=\(defaultFolderPath.queryEncoded())")
        }
        query.append("presentation=dialog")
        let separator = path.contains("?") ? "&" : "?"
        return "\(path)\(separator)\(query.joined(separator: "&"))"
    }
}

private struct MediaPickerDialogButton: Component {
    let label: String
    let style: NewAdminButtonStyle
    let url: String
    let field: String

    func html(context: inout BuilderContext) -> Button {
        var button = context.build(
            NewAdminControlButton(label, style: style)
        )
        button = button.data("admin-dialog-url", url)
        button = button.data("media-picker-open", field)
        return button
    }
}
