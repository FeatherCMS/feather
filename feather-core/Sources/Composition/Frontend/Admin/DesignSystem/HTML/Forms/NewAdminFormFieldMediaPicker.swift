import CSS
import HTML
import SGML
import WebBuilders
import WebComponents

import struct Foundation.CharacterSet

private typealias HTMLButton = HTML.Button

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

        public init(
            key: String,
            label: String,
            value: String?,
            error: String?
        ) {
            self.key = key
            self.label = label
            self.value = value
            self.error = error
        }
    }

    public struct State: Sendable {
        public let field: FieldState
        public let selectedAsset: AdminMediaAssetReferenceModel?
        public let browsePath: String
        public let allowedExtensions: [String]
        public let outputMode: OutputMode
        public let showsCurrentCard: Bool

        public init(
            field: FieldState,
            selectedAsset: AdminMediaAssetReferenceModel?,
            browsePath: String,
            allowedExtensions: [String],
            outputMode: OutputMode = .assetId,
            showsCurrentCard: Bool = true
        ) {
            self.field = field
            self.selectedAsset = selectedAsset
            self.browsePath = browsePath
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
                    Gap(5.px)
                    FontWeight(.normal)
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                    Opacity(0.8)
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
                    Margin(0)
                    Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                    FontSize(1.rem)
                    WordBreak(.breakWord)
                }
                Custom("\(root)__actions") {
                    Display(.flex)
                    FlexWrap(.wrap)
                    AlignItems(.center)
                    Gap(8.px)
                }
                Custom("\(root)__actions button") {
                    Padding(vertical: 8.px, horizontal: 12.px)
                    BorderRadius(8.px)
                    Cursor(.pointer)
                }
                Custom("\(root)__choose") {
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Accents.Primary.border)
                    )
                    Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                    Color(.variable(TokenKey.Colors.Accents.Primary.text))
                }
                Custom("\(root)__clear") {
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Tertiary.border)
                    )
                    Background(
                        .variable(TokenKey.Colors.Materials.Tertiary.tint)
                    )
                    Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                }
                Custom("\(root)__modal") {
                    Position(.fixed)
                    UnsafeRawProperty(name: "inset", value: "0")
                    Display(.none)
                    AlignItems(.center)
                    JustifyContent(.center)
                    Padding(24.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
                    ZIndex(.number(2000))
                }
                Custom("\(root)__modal.is-visible") {
                    Display(.flex)
                }
                Custom("\(root)__dialog") {
                    Width(100.percent)
                    Height(100.percent)
                    MaxWidth(1200.px)
                    MaxHeight(820.px)
                    Display(.grid)
                    GridTemplateRows(
                        .tracks([.auto, .auto, .fraction(1.fr)])
                    )
                    Gap(12.px)
                    Padding(18.px)
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Primary.border)
                    )
                    BorderRadius(16.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Primary.tint)
                    )
                }
                Custom("\(root)__dialog-header") {
                    Display(.flex)
                    AlignItems(.flexStart)
                    JustifyContent(.spaceBetween)
                    Gap(12.px)
                }
                Custom("\(root)__dialog-header h3, \(root)__dialog-header p") {
                    Margin(0)
                }
                Custom("\(root)__dialog-header p") {
                    MarginTop(6.px)
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                }
                Custom("\(root)__close") {
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Tertiary.border)
                    )
                    BorderRadius(8.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Tertiary.tint)
                    )
                    Color(.variable(TokenKey.Colors.Materials.Secondary.text))
                    Padding(vertical: 8.px, horizontal: 12.px)
                    Cursor(.pointer)
                }
                Custom("\(root)__tabs") {
                    Display(.flex)
                    Gap(4.px)
                    Padding(4.px)
                    Border(
                        1.px,
                        .solid,
                        .variable(TokenKey.Colors.Materials.Secondary.border)
                    )
                    BorderRadius(999.px)
                    Background(
                        .variable(TokenKey.Colors.Materials.Secondary.tint)
                    )
                }
                Custom("\(root)__tabs button") {
                    Flex(1)
                    Border(0)
                    BorderRadius(999.px)
                    Padding(vertical: 8.px, horizontal: 12.px)
                    Background(.transparent)
                    Color(.variable(TokenKey.Colors.Materials.Primary.text))
                    Cursor(.pointer)
                }
                Custom("\(root)__tabs button:hover:not(.is-current)") {
                    Color(.variable(TokenKey.Colors.Link.hover))
                }
                Custom("\(root)__tabs button.is-current") {
                    Background(.variable(TokenKey.Colors.Accents.Primary.tint))
                    Color(.variable(TokenKey.Colors.Accents.Primary.text))
                }
                Custom("\(root)__panel") {
                    MinHeight(0.px)
                    Overflow(.auto)
                }
                Custom("\(root)__loading") {
                    Display(.grid)
                    UnsafeRawProperty(name: "place-items", value: "center")
                    MinHeight(12.rem)
                    Color(.variable(TokenKey.Colors.Materials.Tertiary.text))
                }
                Custom("\(root) .field-error") {
                    Color(.variable(TokenKey.Colors.Palette.Red.text))
                    FontSize(0.86.rem)
                }
            },
            Media(.screen && .maxWidth(600.px)) {
                Custom("\(root)__current") {
                    GridTemplateColumns(.fraction(1.fr))
                }
            },
        ]
    }

    public func html(context: inout RenderContext) -> Section {
        Section {
            Label {
                Span(state.field.label)
                Input()
                    .type(.hidden)
                    .id(state.field.key)
                    .name(state.field.key)
                    .value(state.field.value)
            }
            if state.showsCurrentCard {
                currentCard(context: &context)
            }
            else {
                HTMLButton("")
                    .type(.button)
                    .data("media-picker-open", state.field.key)
                    .hidden()
            }
            if let error = state.field.error {
                Span(error).class("field-error")
            }
            modal()
        }
        .if(state.field.error != nil) { $0.class("has-error") }
        .class("new-admin-media-picker")
    }
}

extension NewAdminFormFieldMediaPicker {
    fileprivate func currentCard(context: inout RenderContext)
        -> some FlowContent
    {
        Div {
            previewBlock()
            Div {
                H3(state.selectedAsset.map(displayTitle) ?? "No asset selected")
                    .data("media-picker-title", state.field.key)
                    .data("empty-title", "No asset selected")
                Div {
                    HTMLButton("Choose asset")
                        .type(.button)
                        .class("new-admin-media-picker__choose")
                        .data("media-picker-open", state.field.key)
                    HTMLButton("Clear")
                        .type(.button)
                        .class("new-admin-media-picker__clear")
                        .data("media-picker-clear", state.field.key)
                        .if(state.field.value?.isEmpty != false) { $0.hidden() }
                }
                .class("new-admin-media-picker__actions")
            }
        }
        .class("new-admin-media-picker__current")
    }

    fileprivate func previewBlock() -> some FlowContent {
        Div {
            if let selectedAsset = state.selectedAsset {
                if isImage(selectedAsset.type) {
                    Img(
                        src: previewURL(for: selectedAsset),
                        alt: displayTitle(selectedAsset)
                    )
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

    fileprivate func modal() -> some FlowContent {
        let helperText =
            state.allowedExtensions.isEmpty
            ? "Browse folders, search assets, or upload a new item."
            : "Allowed types: \(state.allowedExtensions.joined(separator: ", "))."

        return Div {
            Div {
                Div {
                    Div {
                        H3(state.field.label)
                        P(helperText)
                    }
                    .class("new-admin-media-picker__dialog-header")
                    HTMLButton("Close")
                        .type(.button)
                        .class("new-admin-media-picker__close")
                        .data("media-picker-close", state.field.key)
                }
                .class("new-admin-media-picker__dialog-header")
                Div {
                    HTMLButton("Gallery")
                        .type(.button)
                        .class("is-current")
                        .data("media-picker-tab", "gallery")
                        .data("media-picker-field", state.field.key)
                    HTMLButton("Upload")
                        .type(.button)
                        .data("media-picker-tab", "upload")
                        .data("media-picker-field", state.field.key)
                }
                .class("new-admin-media-picker__tabs")
                Style("")
                    .data("media-picker-style", state.field.key)
                Div {
                    Div {
                        "Loading..."
                    }
                    .class("new-admin-media-picker__loading")
                }
                .class("new-admin-media-picker__panel")
                .data("media-picker-panel", state.field.key)
            }
            .class("new-admin-media-picker__dialog")
            Script(pickerScript())
        }
        .id("newAdminMediaPickerModal-\(state.field.key)")
        .class("new-admin-media-picker__modal")
        .data("media-picker-browse-path", state.browsePath)
        .data("media-picker-upload-path", uploadPath())
        .data("media-picker-active-tab", "gallery")
        .data("media-picker-output", state.outputMode.rawValue)
    }

    fileprivate func pickerScript() -> String {
        #"""
        (function() {
          if (window.__newAdminMediaPickerInit) { return; }
          window.__newAdminMediaPickerInit = true;

          function modalFor(field) {
            return document.getElementById("newAdminMediaPickerModal-" + field);
          }

          function hide(modal) {
            if (modal) { modal.classList.remove("is-visible"); }
          }

          function browsePath(modal) {
            return modal.getAttribute("data-media-picker-browse-path") || "";
          }

          function uploadPath(modal) {
            return modal.getAttribute("data-media-picker-upload-path") || "";
          }

          function deriveBrowsePath(url) {
            return url.indexOf("/admin/media/assets/add/") === 0
              ? url.replace("/admin/media/assets/add/", "/admin/media/assets/")
              : url;
          }

          function deriveUploadPath(url) {
            return url.indexOf("/admin/media/assets/add/") === 0
              ? url
              : url.replace("/admin/media/assets/", "/admin/media/assets/add/");
          }

          function encodedStorageKey(key) {
            var prefix = "media/assets/";
            var value = String(key || "");
            return encodeURI(value.indexOf(prefix) === 0 ? value.slice(prefix.length) : value);
          }

          function mediaURL(asset) {
            return "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)/media/assets/" + encodedStorageKey(asset.storageKey);
          }

          function fileName(asset) {
            var base = String(asset && asset.baseName || "");
            var type = String(asset && asset.type || "");
            return base ? (type ? base + "." + type : base) : "No asset selected";
          }

          function isImage(asset) {
            return ["png", "jpg", "jpeg", "webp", "gif"].indexOf(String(asset && asset.type || "").toLowerCase()) >= 0;
          }

          function escapeHTML(value) {
            return String(value || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/\"/g, "&quot;").replace(/'/g, "&#39;");
          }

          function preview(asset) {
            if (!asset) {
              return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><rect x="3" y="5" width="18" height="14" rx="2"></rect><circle cx="8.5" cy="10.5" r="1.5"></circle><path d="M21 15l-5-5L5 21"></path></svg>';
            }
            return isImage(asset)
              ? '<img src="' + escapeHTML(mediaURL(asset)) + '" alt="' + escapeHTML(fileName(asset)) + '">'
              : '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><path d="M14 2v6h6"></path></svg>';
          }

          function update(field, asset) {
            var modal = modalFor(field);
            var input = document.getElementById(field);
            var output = modal ? modal.getAttribute("data-media-picker-output") : "assetId";
            if (input) {
              input.value = asset ? (output === "original_url" ? mediaURL(asset) : (output === "relative_url" ? "/media/assets/" + encodedStorageKey(asset.storageKey) : asset.id || "")) : "";
              input.dispatchEvent(new Event("change", { bubbles: true }));
            }
            var previewNode = document.querySelector('[data-media-picker-preview="' + field + '"]');
            if (previewNode) { previewNode.innerHTML = preview(asset); }
            var title = document.querySelector('[data-media-picker-title="' + field + '"]');
            if (title) { title.textContent = asset ? fileName(asset) : title.getAttribute("data-empty-title"); }
            var clear = document.querySelector('[data-media-picker-clear="' + field + '"]');
            if (clear) { clear.hidden = !asset; }
          }

          function setTab(modal, tab) {
            modal.setAttribute("data-media-picker-active-tab", tab);
            modal.querySelectorAll("[data-media-picker-tab]").forEach(function(button) {
              button.classList.toggle("is-current", button.getAttribute("data-media-picker-tab") === tab);
            });
          }

          function extractSection(doc) {
            return doc.querySelector("[data-admin-media-picker-section]") || doc.querySelector(".cms-section");
          }

          function executeScripts(panel, section) {
            Array.from(section.querySelectorAll("script")).forEach(function(script) {
              var replacement = document.createElement("script");
              replacement.textContent = script.textContent || "";
              panel.appendChild(replacement);
            });
          }

          function applyMarker(field, panel) {
            var marker = panel.querySelector("[data-media-picker-selected-id]");
            if (!marker) { return false; }
            update(field, {
              id: marker.getAttribute("data-media-picker-selected-id"),
              storageKey: marker.getAttribute("data-media-picker-selected-storage-key"),
              baseName: marker.getAttribute("data-media-picker-selected-base-name"),
              type: marker.getAttribute("data-media-picker-selected-type")
            });
            return true;
          }

          function normalizeExtension(filename, mime) {
            var name = String(filename || "").toLowerCase();
            var type = String(mime || "").toLowerCase();
            var dot = name.lastIndexOf(".");
            var extension = dot >= 0 ? name.slice(dot + 1) : "";
            if (extension === "jpg") { return "jpeg"; }
            if (extension) { return extension; }
            if (type.indexOf("/") >= 0) { return type.split("/")[1] || "bin"; }
            return "bin";
          }

          function readFile(file) {
            return new Promise(function(resolve, reject) {
              var reader = new FileReader();
              reader.onload = function() {
                var result = String(reader.result || "");
                var comma = result.indexOf(",");
                resolve(comma >= 0 ? result.slice(comma + 1) : result);
              };
              reader.onerror = function() { reject(new Error("File read failed.")); };
              reader.readAsDataURL(file);
            });
          }

          async function prepareUpload(container) {
            var fileInput = container.querySelector('input[type="file"][name="file"]');
            var dataInput = container.querySelector('input[name="data"]');
            var typeInput = container.querySelector('input[name="type"]');
            var nameInput = container.querySelector('input[name="fileName"]');
            var file = fileInput && fileInput.files && fileInput.files[0];
            if (!file || !dataInput || !typeInput || !nameInput) {
              throw new Error("Please choose a file.");
            }
            typeInput.value = normalizeExtension(file.name, file.type);
            nameInput.value = file.name || "";
            dataInput.value = await readFile(file);
          }

          function uploadPayload(container) {
            var payload = new URLSearchParams();
            container.querySelectorAll("[name]").forEach(function(element) {
              if (element.type === "file") { return; }
              if ((element.type === "checkbox" || element.type === "radio") && !element.checked) { return; }
              payload.append(element.name, element.value || "");
            });
            return payload;
          }

          async function load(field, tab, url, options) {
            var modal = modalFor(field);
            var panel = modal && modal.querySelector('[data-media-picker-panel="' + field + '"]');
            var style = modal && modal.querySelector('[data-media-picker-style="' + field + '"]');
            if (!modal || !panel || !style) { return; }
            setTab(modal, tab);
            modal.setAttribute("data-media-picker-browse-path", deriveBrowsePath(url));
            modal.setAttribute("data-media-picker-upload-path", deriveUploadPath(url));
            panel.innerHTML = '<div class="new-admin-media-picker__loading">Loading...</div>';
            var response = await fetch(url, Object.assign({ credentials: "same-origin" }, options || {}));
            var doc = new DOMParser().parseFromString(await response.text(), "text/html");
            var section = extractSection(doc);
            if (!section) { panel.textContent = "Unable to load media picker."; return; }
            style.textContent = Array.from(doc.querySelectorAll("head style")).map(function(node) { return node.textContent || ""; }).join("\n");
            panel.innerHTML = section.outerHTML;
            executeScripts(panel, section);
            applyMarker(field, panel);
          }

          function submitSearch(container) {
            var panel = container.closest("[data-media-picker-panel]");
            var field = panel && panel.getAttribute("data-media-picker-panel");
            var modal = field && modalFor(field);
            if (!modal) { return; }
            var url = new URL(container.getAttribute("data-admin-media-picker-search-path") || browsePath(modal), window.location.origin);
            var input = container.querySelector("[data-admin-media-picker-search-input]");
            var search = input ? String(input.value || "").trim() : "";
            if (search) { url.searchParams.set("search", search); } else { url.searchParams.delete("search"); }
            load(field, modal.getAttribute("data-media-picker-active-tab") || "gallery", url.pathname + url.search);
          }

          document.addEventListener("click", async function(event) {
            var open = event.target.closest("[data-media-picker-open]");
            if (open) {
              var field = open.getAttribute("data-media-picker-open");
              var modal = modalFor(field);
              if (modal) { modal.classList.add("is-visible"); load(field, "gallery", browsePath(modal)); }
              return;
            }
            var close = event.target.closest("[data-media-picker-close]");
            if (close) { hide(modalFor(close.getAttribute("data-media-picker-close"))); return; }
            var clear = event.target.closest("[data-media-picker-clear]");
            if (clear) { update(clear.getAttribute("data-media-picker-clear"), null); return; }
            var tab = event.target.closest("[data-media-picker-tab]");
            if (tab) {
              var field = tab.getAttribute("data-media-picker-field");
              var modal = modalFor(field);
              load(field, tab.getAttribute("data-media-picker-tab"), tab.getAttribute("data-media-picker-tab") === "upload" ? uploadPath(modal) : browsePath(modal));
              return;
            }
            var search = event.target.closest("[data-admin-media-picker-search-submit]");
            if (search) { event.preventDefault(); submitSearch(search.closest("[data-admin-media-picker-search-path]")); return; }
            var select = event.target.closest("[data-picker-select]");
            if (select) {
              event.preventDefault();
              var field = select.getAttribute("data-picker-field");
              update(field, {
                id: select.getAttribute("data-picker-select"),
                storageKey: select.getAttribute("data-picker-storage-key"),
                baseName: select.getAttribute("data-picker-base-name"),
                type: select.getAttribute("data-picker-type")
              });
              hide(modalFor(field));
              return;
            }
            var upload = event.target.closest("[data-admin-media-picker-upload-submit]");
            if (upload) {
              event.preventDefault();
              var container = upload.closest("[data-admin-media-picker-upload]");
              var panel = container && container.closest("[data-media-picker-panel]");
              var field = panel && panel.getAttribute("data-media-picker-panel");
              var modal = field && modalFor(field);
              if (!container || !field || !modal) { return; }
              try {
                await prepareUpload(container);
                var response = await fetch(container.getAttribute("data-action") || uploadPath(modal), {
                  method: "POST",
                  body: uploadPayload(container),
                  credentials: "same-origin",
                  headers: { "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8" }
                });
                var documentHTML = await response.text();
                var uploadDocument = new DOMParser().parseFromString(documentHTML, "text/html");
                var marker = uploadDocument.querySelector("[data-media-picker-selected-id]");
                if (marker) {
                  update(field, {
                    id: marker.getAttribute("data-media-picker-selected-id"),
                    storageKey: marker.getAttribute("data-media-picker-selected-storage-key"),
                    baseName: marker.getAttribute("data-media-picker-selected-base-name"),
                    type: marker.getAttribute("data-media-picker-selected-type")
                  });
                  hide(modal);
                }
                else {
                  load(field, "upload", uploadPath(modal), {
                    method: "POST",
                    body: uploadPayload(container)
                  });
                }
              }
              catch (error) {
                window.alert(error && error.message ? error.message : "Unable to upload media.");
              }
              return;
            }
            var link = event.target.closest(".new-admin-media-picker__panel a");
            if (link && link.getAttribute("target") !== "_blank") {
              event.preventDefault();
              var panel = link.closest("[data-media-picker-panel]");
              var field = panel && panel.getAttribute("data-media-picker-panel");
              var modal = field && modalFor(field);
              if (modal) { load(field, modal.getAttribute("data-media-picker-active-tab") || "gallery", link.getAttribute("href")); }
            }
          });

          document.addEventListener("keydown", function(event) {
            if (event.key === "Enter" && event.target.closest("[data-admin-media-picker-search-input]")) {
              event.preventDefault(); submitSearch(event.target.closest("[data-admin-media-picker-search-path]"));
            }
            if (event.key === "Escape") {
              document.querySelectorAll(".new-admin-media-picker__modal.is-visible").forEach(hide);
            }
          });
        })();
        """#
    }

    fileprivate func displayTitle(_ asset: AdminMediaAssetReferenceModel)
        -> String
    {
        asset.type.isEmpty ? asset.baseName : "\(asset.baseName).\(asset.type)"
    }

    fileprivate func encodedStorageKey(_ key: String) -> String {
        let prefix = "media/assets/"
        let raw =
            key.hasPrefix(prefix) ? String(key.dropFirst(prefix.count)) : key
        let allowed = CharacterSet(
            charactersIn:
                "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~/"
        )
        return raw.addingPercentEncoding(withAllowedCharacters: allowed) ?? raw
    }

    fileprivate func previewURL(for asset: AdminMediaAssetReferenceModel)
        -> String
    {
        "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)/media/assets/\(encodedStorageKey(asset.storageKey))"
    }

    fileprivate func uploadPath() -> String {
        if let queryIndex = state.browsePath.firstIndex(of: "?") {
            return "/admin/media/assets/add/" + state.browsePath[queryIndex...]
        }
        return "/admin/media/assets/add/"
    }

    fileprivate func isImage(_ type: String) -> Bool {
        ["png", "jpg", "jpeg", "webp", "gif"].contains(type.lowercased())
    }
}
