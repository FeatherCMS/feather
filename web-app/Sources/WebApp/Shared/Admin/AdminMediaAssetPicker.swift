import CSS
import HTML
import SGML
import WebStandards

import struct Foundation.CharacterSet

struct AdminMediaAssetPicker: Component, FlowContent {
    enum OutputMode: String {
        case assetId
        case originalURL = "original_url"
    }

    struct FieldState {
        let key: String
        let label: String
        let value: String?
        let error: String?
    }

    struct State {
        let field: FieldState
        let selectedAsset: AdminMediaAssetReferenceModel?
        let browsePath: String
        let allowedExtensions: [String]
        let outputMode: OutputMode

        init(
            field: FieldState,
            selectedAsset: AdminMediaAssetReferenceModel?,
            browsePath: String,
            allowedExtensions: [String],
            outputMode: OutputMode = .assetId
        ) {
            self.field = field
            self.selectedAsset = selectedAsset
            self.browsePath = browsePath
            self.allowedExtensions = allowedExtensions
            self.outputMode = outputMode
        }
    }

    let state: State

    func selectors() -> [any Selector] {
        Class("admin-media-asset-picker") {
            Display(.grid)
            Gap(12.px)
        }
        Class("admin-media-asset-picker-current") {
            Display(.grid)
            Gap(12.px)
            Padding(14.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(14.px)
            Background(color: .color(.variable("cms-white")))
        }
        Class("admin-media-asset-picker-preview") {
            Width(120.px)
            Height(120.px)
            BorderRadius(12.px)
            Overflow(.hidden)
            Border(1.px, .solid, .variable("cms-gray-3"))
            Background(color: .color(.variable("cms-gray-1")))
            Display(.grid)
            UnsafeRawProperty(name: "place-items", value: "center")
        }
        Custom(".admin-media-asset-picker-preview img") {
            Width(100.percent)
            Height(100.percent)
            ObjectFit(.cover)
            Display(.block)
            Margin(0)
        }
        Custom(".admin-media-asset-picker-preview svg") {
            Width(2.75.rem)
            Height(2.75.rem)
            Color(.variable("cms-primary-bg"))
        }
        Class("admin-media-asset-picker-actions") {
            Display(.flex)
            Gap(8.px)
            FlexWrap(.wrap)
            AlignItems(.center)
        }
        Class("admin-media-asset-picker-modal") {
            Position(.fixed)
            UnsafeRawProperty(name: "inset", value: "0")
            Display(.none)
            AlignItems(.center)
            JustifyContent(.center)
            Padding(24.px)
            UnsafeRawProperty(name: "background", value: "rgb(15 23 42 / 0.68)")
            ZIndex(.number(2000))
        }
        Class("admin-media-asset-picker-modal-visible") {
            Display(.flex)
        }
        Class("admin-media-asset-picker-dialog") {
            UnsafeRawProperty(
                name: "width",
                value: "min(1200px, calc(100vw - 48px))"
            )
            UnsafeRawProperty(
                name: "height",
                value: "min(820px, calc(100vh - 48px))"
            )
            Display(.grid)
            UnsafeRawProperty(
                name: "grid-template-rows",
                value: "auto auto minmax(0, 1fr)"
            )
            Gap(12.px)
            Padding(18.px)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(20.px)
            Background(color: .color(.variable("cms-white")))
            UnsafeRawProperty(
                name: "box-shadow",
                value: "0 20px 48px rgb(15 23 42 / 0.22)"
            )
        }
        Class("admin-media-asset-picker-dialog-header") {
            Display(.flex)
            AlignItems(.center)
            JustifyContent(.spaceBetween)
            Gap(12.px)
        }
        Custom(
            ".admin-media-asset-picker-dialog-header h3, .admin-media-asset-picker-dialog-header p"
        ) {
            Margin(0)
        }
        Custom(".admin-media-asset-picker-dialog-header p") {
            Color(.variable("cms-light-font"))
        }
        Class("admin-media-asset-picker-tabs") {
            Display(.flex)
            AlignItems(.center)
            Border(1.px, .solid, .variable("cms-gray-3"))
            BorderRadius(999.px)
            MarginBottom(8.px)
            Padding(4.px)
            Gap(4.px)
            Width(100.percent)
        }
        Custom(".admin-media-asset-picker-tabs button") {
            Flex(1)
            Border(0)
            BorderRadius(999.px)
            Background(color: .transparent)
            Color(.variable("cms-light-font"))
            Padding(vertical: 8.px, horizontal: 12.px)
            LineHeight(1.2)
            TextAlign(.center)
            UnsafeRawProperty(name: "cursor", value: "pointer")
        }
        Custom(".admin-media-asset-picker-tabs button:hover:not(.is-current)") {
            Color(.variable("cms-link-hover"))
            TextDecoration(.underline)
        }
        Custom(".admin-media-asset-picker-tabs button.is-current") {
            UnsafeRawProperty(name: "background", value: "var(--cms-gray-4)")
            Color(.variable("cms-strong-font"))
        }
        Class("admin-media-asset-picker-panel") {
            MinHeight(0.px)
            Overflow(.auto)
            Padding(vertical: 0.px, horizontal: 4.px)
        }
        Custom(".admin-media-asset-picker-panel .cms-section") {
            Margin(0)
            Padding(0.px)
            Border(0)
            BorderRadius(0.px)
            UnsafeRawProperty(name: "background", value: "transparent")
            UnsafeRawProperty(name: "box-shadow", value: "none")
        }
        Custom(".admin-media-asset-picker-panel .cms-form") {
            Margin(0)
            Padding(0.px)
            Border(0)
            BorderRadius(0.px)
            UnsafeRawProperty(name: "background", value: "transparent")
            UnsafeRawProperty(name: "box-shadow", value: "none")
        }
        Custom(
            ".admin-media-asset-picker-panel [data-admin-media-picker-section]"
        ) {
            Padding(vertical: 0.px, horizontal: 4.px)
        }
        Custom(".admin-media-asset-picker-panel .cms-section > :first-child") {
            MarginTop(0.px)
        }
        Custom(".admin-media-asset-picker-panel .media-assets-toolbar") {
            MarginTop(8.px)
        }
        Custom(".admin-media-asset-picker-panel .media-assets-search-row") {
            Gap(8.px)
            MarginBottom(12.px)
        }
        Custom(
            ".admin-media-asset-picker-panel .media-assets-search-row .table-search-form"
        ) {
            MarginBottom(0)
        }
        Custom(
            ".admin-media-asset-picker-panel .table-search-form .table-search-reset"
        ) {
            Padding(vertical: 8.px, horizontal: 12.px)
        }
        Custom(
            ".admin-media-asset-picker-panel .media-assets-search-row .media-assets-toggle"
        ) {
            MarginLeft(.auto)
            AlignSelf(.center)
        }
        Custom(
            ".admin-media-asset-picker-panel .media-assets-card-actions .media-assets-inline-form"
        ) {
            Display(.none)
        }
        Class("admin-media-asset-picker-loading") {
            Display(.grid)
            UnsafeRawProperty(name: "place-items", value: "center")
            MinHeight(12.rem)
            Color(.variable("cms-light-font"))
        }
    }

    func content() -> some BasicTag {
        Section {
            Label {
                AdminFieldLabel(label: state.field.label, required: false)
            }

            Div {
                Input()
                    .type(.hidden)
                    .id(state.field.key)
                    .name(state.field.key)
                    .value(state.field.value)

                currentCard()

                if let error = state.field.error {
                    Span(error).class("field-error")
                }

                modal()
            }
            .class("admin-media-asset-picker")
        }
        .if(state.field.error != nil) { $0.class("has-error") }
    }
}

extension AdminMediaAssetPicker {
    fileprivate func currentCard() -> some FlowContent {
        Div {
            previewBlock(selectedAsset: state.selectedAsset)

            Div {
                if state.selectedAsset == nil {
                    H3("No asset selected")
                        .style("margin:0;")
                        .setAttribute(
                            name: "data-media-picker-title",
                            value: state.field.key
                        )
                        .setAttribute(
                            name: "data-empty-title",
                            value: "No asset selected"
                        )
                }
            }

            Div {
                Button("Choose asset")
                    .type(.button)
                    .class("secondary")
                    .setAttribute(
                        name: "data-media-picker-open",
                        value: state.field.key
                    )
                Button("Clear")
                    .type(.button)
                    .class("ghost")
                    .setAttribute(
                        name: "data-media-picker-clear",
                        value: state.field.key
                    )
                    .if(state.field.value?.isEmpty != false) {
                        $0.style("display:none;")
                    }
            }
            .class("admin-media-asset-picker-actions")
        }
        .class("admin-media-asset-picker-current")
    }

    fileprivate func previewBlock(
        selectedAsset: AdminMediaAssetReferenceModel?
    ) -> some FlowContent {
        Div {
            if let selectedAsset {
                if isImage(selectedAsset.type) {
                    Img(
                        src: previewURL(for: selectedAsset),
                        alt: displayTitle(selectedAsset)
                    )
                }
                else {
                    Icon(svg: FeatherIcons.file())
                }
            }
            else {
                Icon(svg: FeatherIcons.image())
            }
        }
        .class("admin-media-asset-picker-preview")
        .setAttribute(name: "data-media-picker-preview", value: state.field.key)
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
                    Button("Close")
                        .type(.button)
                        .class("ghost")
                        .setAttribute(
                            name: "data-media-picker-close",
                            value: state.field.key
                        )
                }
                .class("admin-media-asset-picker-dialog-header")

                Div {
                    Button("Gallery")
                        .type(.button)
                        .class("is-current")
                        .setAttribute(
                            name: "data-media-picker-tab",
                            value: "gallery"
                        )
                        .setAttribute(
                            name: "data-media-picker-field",
                            value: state.field.key
                        )
                    Button("Upload")
                        .type(.button)
                        .setAttribute(
                            name: "data-media-picker-tab",
                            value: "upload"
                        )
                        .setAttribute(
                            name: "data-media-picker-field",
                            value: state.field.key
                        )
                }
                .class("admin-media-asset-picker-tabs")

                Style("")
                    .setAttribute(
                        name: "data-media-picker-style",
                        value: state.field.key
                    )

                Div {
                    Div {
                        P("Loading...")
                    }
                    .class("admin-media-asset-picker-loading")
                }
                .class("admin-media-asset-picker-panel")
                .setAttribute(
                    name: "data-media-picker-panel",
                    value: state.field.key
                )
            }
            .class("admin-media-asset-picker-dialog")

            Script(pickerScript())
        }
        .id("mediaPickerModal-\(state.field.key)")
        .class("admin-media-asset-picker-modal")
        .setAttribute(
            name: "data-media-picker-browse-path",
            value: state.browsePath
        )
        .setAttribute(
            name: "data-media-picker-upload-path",
            value: uploadPath()
        )
        .setAttribute(name: "data-media-picker-active-tab", value: "gallery")
        .setAttribute(
            name: "data-media-picker-output",
            value: state.outputMode.rawValue
        )
    }

    fileprivate func pickerScript() -> String {
        """
        (function() {
          if (window.__adminMediaAssetPickerInit) { return; }
          window.__adminMediaAssetPickerInit = true;

          function modalFor(id) {
            return document.getElementById("mediaPickerModal-" + id);
          }

          function hideModal(modal) {
            if (!modal) { return; }
            modal.classList.remove("admin-media-asset-picker-modal-visible");
          }

          function visibleModal() {
            var modals = Array.from(document.querySelectorAll(".admin-media-asset-picker-modal-visible"));
            return modals.length ? modals[modals.length - 1] : null;
          }

          function escapeHtml(value) {
            return String(value || "")
              .replace(/&/g, "&amp;")
              .replace(/</g, "&lt;")
              .replace(/>/g, "&gt;")
              .replace(/\"/g, "&quot;")
              .replace(/'/g, "&#39;");
          }

          function encodedStorageKey(key) {
            var prefix = "media/assets/";
            var normalized = key && key.indexOf(prefix) === 0 ? key.slice(prefix.length) : (key || "");
            return encodeURI(normalized);
          }

          function mediaBaseUrl() {
            return "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)";
          }

          function originalUrl(asset) {
            return mediaBaseUrl() + "/media/assets/" + encodedStorageKey(asset.storageKey || "");
          }

          function fileName(asset) {
            if (!asset) { return "No asset selected"; }
            var baseName = String(asset.baseName || "");
            var type = String(asset.type || "");
            if (!baseName) { return "No asset selected"; }
            return type ? (baseName + "." + type) : baseName;
          }

          function displayTitle(asset) {
            return fileName(asset);
          }

          function isImageType(asset) {
            var type = String(asset && asset.type || "").toLowerCase();
            return ["png", "jpg", "jpeg", "webp", "gif"].indexOf(type) !== -1;
          }

          function previewMarkup(asset) {
            if (!asset) {
              return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><rect x="3" y="5" width="18" height="14" rx="2"></rect><circle cx="8.5" cy="10.5" r="1.5"></circle><path d="M21 15l-5-5L5 21"></path></svg>';
            }
            if (isImageType(asset)) {
              return '<img src="' + escapeHtml(originalUrl(asset)) + '" alt="' + escapeHtml(displayTitle(asset)) + '">';
            }
            return '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" aria-hidden="true"><path d="M14 2H6a2 2 0 0 0-2 2v16a2 2 0 0 0 2 2h12a2 2 0 0 0 2-2V8z"></path><path d="M14 2v6h6"></path></svg>';
          }

          function updatePicker(field, asset) {
            var input = document.getElementById(field);
            var modal = modalFor(field);
            var outputMode = modal ? (modal.getAttribute("data-media-picker-output") || "assetId") : "assetId";
            if (input) {
              input.value = asset
                ? (outputMode === "original_url" ? originalUrl(asset) : (asset.id || ""))
                : "";
            }

            var preview = document.querySelector('[data-media-picker-preview="' + field + '"]');
            if (preview) {
              preview.innerHTML = previewMarkup(asset);
            }

            var title = document.querySelector('[data-media-picker-title="' + field + '"]');
            if (title) {
              title.textContent = asset ? "" : (title.getAttribute("data-empty-title") || "No asset selected");
              title.style.display = asset ? "none" : "";
            }

            var clearButton = document.querySelector('[data-media-picker-clear="' + field + '"]');
            if (clearButton) {
              clearButton.style.display = asset ? "" : "none";
            }
          }

          function setActiveTab(modal, tab) {
            modal.setAttribute("data-media-picker-active-tab", tab);
            modal.querySelectorAll("[data-media-picker-tab]").forEach(function(button) {
              button.classList.toggle("is-current", button.getAttribute("data-media-picker-tab") === tab);
            });
          }

          function deriveUploadPath(url) {
            return url.indexOf("/admin/media/assets/add/") === 0
              ? url
              : url.replace("/admin/media/assets/", "/admin/media/assets/add/");
          }

          function deriveBrowsePath(url) {
            return url.indexOf("/admin/media/assets/add/") === 0
              ? url.replace("/admin/media/assets/add/", "/admin/media/assets/")
              : url;
          }

          function normalizeUploadExtension(filename, mime) {
            var lowerMime = String(mime || "").toLowerCase();
            var lowerName = String(filename || "").toLowerCase();
            var ext = "";
            var dot = lowerName.lastIndexOf(".");
            if (dot >= 0) { ext = lowerName.slice(dot + 1); }
            if (ext === "jpg") { return "jpeg"; }
            if (ext === "jpeg" || ext === "png" || ext === "webp" || ext === "gif" || ext === "mp4" || ext === "mov" || ext === "webm") { return ext; }
            if (lowerMime === "image/jpeg") { return "jpeg"; }
            if (lowerMime === "image/png") { return "png"; }
            if (lowerMime === "image/webp") { return "webp"; }
            if (lowerMime === "image/gif") { return "gif"; }
            if (lowerMime === "video/mp4") { return "mp4"; }
            if (lowerMime === "video/quicktime") { return "mov"; }
            if (lowerMime === "video/webm") { return "webm"; }
            if (ext) { return ext; }
            if (lowerMime.indexOf("/") >= 0) { return (lowerMime.split("/")[1] || "bin").toLowerCase(); }
            return "bin";
          }

          function readFileBase64(file) {
            return new Promise(function(resolve, reject) {
              var reader = new FileReader();
              reader.onload = function() {
                var result = String(reader.result || "");
                var idx = result.indexOf(",");
                resolve(idx >= 0 ? result.slice(idx + 1) : result);
              };
              reader.onerror = function() { reject(new Error("File read failed")); };
              reader.readAsDataURL(file);
            });
          }

          async function prepareUploadForm(container) {
            var fileInput = container.querySelector('input[type="file"][name="file"]');
            var dataInput = container.querySelector('input[name="data"]');
            var typeInput = container.querySelector('input[name="type"]');
            var fileNameInput = container.querySelector('input[name="fileName"]');
            var file = fileInput && fileInput.files && fileInput.files[0];
            if (!file) {
              throw new Error("Please choose a file.");
            }
            if (!dataInput || !typeInput || !fileNameInput) {
              throw new Error("Upload form is incomplete.");
            }
            typeInput.value = normalizeUploadExtension(file.name, file.type);
            fileNameInput.value = file.name || "";
            dataInput.value = await readFileBase64(file);
          }

          function buildUploadPayload(container) {
            var payload = new URLSearchParams();
            container.querySelectorAll("[name]").forEach(function(element) {
              var name = element.getAttribute("name");
              if (!name || element.type === "file") {
                return;
              }
              if ((element.type === "checkbox" || element.type === "radio") && !element.checked) {
                return;
              }
              payload.append(name, element.value || "");
            });
            return payload;
          }

          function extractSection(doc) {
            return doc.querySelector("[data-admin-media-picker-section]") || doc.querySelector(".cms-section");
          }

          function extractStyles(doc) {
            return Array.from(doc.querySelectorAll("head style"))
              .map(function(style) { return style.textContent || ""; })
              .join("\\n");
          }

          function executeScripts(panel, section) {
            Array.from(section.querySelectorAll("script")).forEach(function(oldScript) {
              var newScript = document.createElement("script");
              Array.from(oldScript.attributes).forEach(function(attribute) {
                newScript.setAttribute(attribute.name, attribute.value);
              });
              newScript.textContent = oldScript.textContent || "";
              panel.appendChild(newScript);
            });
          }

          function applySelectedAssetFromPanel(field, panel) {
            var marker = panel.querySelector("[data-media-picker-selected-id]");
            if (!marker) {
              return false;
            }
            window.__adminMediaAssetPickerHandleUploadedAsset(field, {
              id: marker.getAttribute("data-media-picker-selected-id"),
              storageKey: marker.getAttribute("data-media-picker-selected-storage-key"),
              baseName: marker.getAttribute("data-media-picker-selected-base-name"),
              type: marker.getAttribute("data-media-picker-selected-type"),
              title: marker.getAttribute("data-media-picker-selected-title"),
              altText: marker.getAttribute("data-media-picker-selected-alt-text"),
              status: marker.getAttribute("data-media-picker-selected-status")
            });
            return true;
          }

          window.__adminMediaAssetPickerHandleUploadedAsset = function(field, asset) {
            updatePicker(field, asset || null);
            var modal = modalFor(field);
            if (modal) {
              loadPanel(field, "gallery", browsePath(modal));
            }
          };

          window.__adminMediaAssetPickerReplacePanel = function(field, html) {
            var modal = modalFor(field);
            if (!modal) { return; }
            var panel = modal.querySelector('[data-media-picker-panel="' + field + '"]');
            var styleNode = modal.querySelector('[data-media-picker-style="' + field + '"]');
            if (!panel || !styleNode) { return; }
            var doc = new DOMParser().parseFromString(html, "text/html");
            var section = extractSection(doc);
            if (!section) {
              panel.innerHTML = '<p class="error">Unable to load media picker.</p>';
              return;
            }
            styleNode.textContent = extractStyles(doc);
            panel.innerHTML = section.outerHTML;
            executeScripts(panel, section);
          };

          async function loadPanel(field, tab, url, requestInit) {
            var modal = modalFor(field);
            if (!modal) { return; }
            var panel = modal.querySelector('[data-media-picker-panel="' + field + '"]');
            var styleNode = modal.querySelector('[data-media-picker-style="' + field + '"]');
            if (!panel || !styleNode) { return; }

            setActiveTab(modal, tab);
            modal.setAttribute("data-media-picker-browse-path", deriveBrowsePath(url));
            modal.setAttribute("data-media-picker-upload-path", deriveUploadPath(url));
            panel.innerHTML = '<div class="admin-media-asset-picker-loading">Loading...</div>';

            var response = await fetch(url, Object.assign({ credentials: "same-origin" }, requestInit || {}));
            var html = await response.text();
            var doc = new DOMParser().parseFromString(html, "text/html");
            var section = extractSection(doc);
            if (!section) {
              panel.innerHTML = '<p class="error">Unable to load media picker.</p>';
              return;
            }

            styleNode.textContent = extractStyles(doc);
            panel.innerHTML = section.outerHTML;
            executeScripts(panel, section);
            applySelectedAssetFromPanel(field, panel);
          }

          function browsePath(modal) {
            return modal.getAttribute("data-media-picker-browse-path");
          }

          function uploadPath(modal) {
            return modal.getAttribute("data-media-picker-upload-path");
          }

          function submitPickerSearch(container) {
            if (!container) { return; }
            var panel = container.closest("[data-media-picker-panel]");
            if (!panel) { return; }
            var field = panel.getAttribute("data-media-picker-panel");
            var modal = modalFor(field);
            if (!modal) { return; }
            var basePath = container.getAttribute("data-admin-media-picker-search-path") || browsePath(modal);
            var input = container.querySelector("[data-admin-media-picker-search-input]");
            var url = new URL(basePath, window.location.origin);
            var value = input ? String(input.value || "").trim() : "";
            if (value) {
              url.searchParams.set("search", value);
            } else {
              url.searchParams.delete("search");
            }
            loadPanel(field, modal.getAttribute("data-media-picker-active-tab") || "gallery", url.pathname + url.search);
          }

          document.addEventListener("click", async function(event) {
            var openTrigger = event.target.closest("[data-media-picker-open]");
            if (openTrigger) {
              var openId = openTrigger.getAttribute("data-media-picker-open");
              var openModal = modalFor(openId);
              if (openModal) {
                openModal.classList.add("admin-media-asset-picker-modal-visible");
                loadPanel(openId, openModal.getAttribute("data-media-picker-active-tab") || "gallery", browsePath(openModal));
              }
              return;
            }

            var closeTrigger = event.target.closest("[data-media-picker-close]");
            if (closeTrigger) {
              var closeId = closeTrigger.getAttribute("data-media-picker-close");
              var closeTarget = modalFor(closeId);
              hideModal(closeTarget);
              return;
            }

            var clearTrigger = event.target.closest("[data-media-picker-clear]");
            if (clearTrigger) {
              var clearId = clearTrigger.getAttribute("data-media-picker-clear");
              updatePicker(clearId, null);
              return;
            }

            var tabTrigger = event.target.closest("[data-media-picker-tab]");
            if (tabTrigger) {
              var tabField = tabTrigger.getAttribute("data-media-picker-field");
              var tabModal = modalFor(tabField);
              if (!tabModal) { return; }
              var tab = tabTrigger.getAttribute("data-media-picker-tab");
              loadPanel(
                tabField,
                tab,
                tab === "upload" ? uploadPath(tabModal) : browsePath(tabModal)
              );
              return;
            }

            var pickerSearchTrigger = event.target.closest("[data-admin-media-picker-search-submit]");
            if (pickerSearchTrigger) {
              event.preventDefault();
              submitPickerSearch(pickerSearchTrigger.closest("[data-admin-media-picker-search-path]"));
              return;
            }

            var uploadTrigger = event.target.closest("[data-admin-media-picker-upload-submit]");
            if (uploadTrigger) {
              event.preventDefault();
              var uploadContainer = uploadTrigger.closest("[data-admin-media-picker-upload]");
              if (!uploadContainer) { return; }
              var uploadPanel = uploadContainer.closest("[data-media-picker-panel]");
              if (!uploadPanel) { return; }
              var uploadField = uploadPanel.getAttribute("data-media-picker-panel");
              if (!uploadField) { return; }
              try {
                await prepareUploadForm(uploadContainer);
              } catch (error) {
                window.alert(error && error.message ? error.message : "Unable to prepare upload.");
                return;
              }
              var uploadResponse = await fetch(uploadContainer.getAttribute("data-action") || window.location.pathname, {
                method: "POST",
                body: buildUploadPayload(uploadContainer),
                credentials: "same-origin",
                headers: {
                  "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
                }
              });
              var uploadHtml = await uploadResponse.text();
              var uploadDoc = new DOMParser().parseFromString(uploadHtml, "text/html");
              var marker = uploadDoc.querySelector("[data-media-picker-selected-id]");
              if (marker && typeof window.__adminMediaAssetPickerHandleUploadedAsset === "function") {
                window.__adminMediaAssetPickerHandleUploadedAsset(uploadField, {
                  id: marker.getAttribute("data-media-picker-selected-id"),
                  storageKey: marker.getAttribute("data-media-picker-selected-storage-key"),
                  baseName: marker.getAttribute("data-media-picker-selected-base-name"),
                  type: marker.getAttribute("data-media-picker-selected-type"),
                  title: marker.getAttribute("data-media-picker-selected-title"),
                  altText: marker.getAttribute("data-media-picker-selected-alt-text"),
                  status: marker.getAttribute("data-media-picker-selected-status")
                });
                return;
              }
              if (typeof window.__adminMediaAssetPickerReplacePanel === "function") {
                window.__adminMediaAssetPickerReplacePanel(uploadField, uploadHtml);
              }
              return;
            }

            var selectTrigger = event.target.closest("[data-picker-select]");
            if (selectTrigger) {
              event.preventDefault();
              var field = selectTrigger.getAttribute("data-picker-field");
              updatePicker(field, {
                id: selectTrigger.getAttribute("data-picker-select"),
                storageKey: selectTrigger.getAttribute("data-picker-storage-key"),
                baseName: selectTrigger.getAttribute("data-picker-base-name"),
                type: selectTrigger.getAttribute("data-picker-type"),
                title: selectTrigger.getAttribute("data-picker-title"),
                altText: selectTrigger.getAttribute("data-picker-alt-text"),
                status: selectTrigger.getAttribute("data-picker-status")
              });
              var modal = modalFor(field);
              hideModal(modal);
              return;
            }

            var link = event.target.closest(".admin-media-asset-picker-panel a");
            if (link) {
              var href = link.getAttribute("href") || "";
              var target = link.getAttribute("target");
              if (!href || href.charAt(0) === "#" || target === "_blank") {
                return;
              }
              var panel = link.closest("[data-media-picker-panel]");
              if (!panel) { return; }
              event.preventDefault();
              var field = panel.getAttribute("data-media-picker-panel");
              var modal = modalFor(field);
              if (!modal) { return; }
              loadPanel(field, modal.getAttribute("data-media-picker-active-tab") || "gallery", href);
            }
          });

          document.addEventListener("keydown", function(event) {
            if (event.key === "Enter") {
              var pickerSearchInput = event.target.closest("[data-admin-media-picker-search-input]");
              if (pickerSearchInput) {
                event.preventDefault();
                submitPickerSearch(pickerSearchInput.closest("[data-admin-media-picker-search-path]"));
                return;
              }
            }
            if (event.key !== "Escape") { return; }
            var modal = visibleModal();
            if (!modal) { return; }
            event.preventDefault();
            hideModal(modal);
          });

          document.addEventListener("submit", async function(event) {
            var form = event.target.closest(".admin-media-asset-picker-panel form");
            if (!form) { return; }
            event.preventDefault();
            var panel = form.closest("[data-media-picker-panel]");
            if (!panel) { return; }
            var field = panel.getAttribute("data-media-picker-panel");
            var modal = modalFor(field);
            if (!modal) { return; }
            var method = (form.getAttribute("method") || "get").toUpperCase();
            var action = form.getAttribute("action") || window.location.pathname;
            if (method === "GET") {
              var getUrl = new URL(action, window.location.origin);
              new FormData(form).forEach(function(value, key) {
                if (String(value) !== "") {
                  getUrl.searchParams.set(key, String(value));
                } else {
                  getUrl.searchParams.delete(key);
                }
              });
              loadPanel(field, modal.getAttribute("data-media-picker-active-tab") || "gallery", getUrl.pathname + getUrl.search);
              return;
            }
            if (typeof form.__adminMediaPickerPrepare === "function") {
              try {
                await form.__adminMediaPickerPrepare();
              } catch (error) {
                window.alert(error && error.message ? error.message : "Unable to prepare upload.");
                return;
              }
            }
            loadPanel(field, modal.getAttribute("data-media-picker-active-tab") || "upload", action, {
              method: method,
              body: new FormData(form)
            });
          });

        })();
        """
    }

    fileprivate func displayTitle(
        _ asset: AdminMediaAssetReferenceModel
    ) -> String {
        fileName(asset)
    }

    fileprivate func fileName(
        _ asset: AdminMediaAssetReferenceModel
    ) -> String {
        asset.type.isEmpty ? asset.baseName : "\(asset.baseName).\(asset.type)"
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

    fileprivate func previewURL(
        for asset: AdminMediaAssetReferenceModel
    ) -> String {
        "\(AppEnvironmentStore.current.publicOrigins.mediaBaseURL.absoluteString)/media/assets/\(encodedStorageKey(asset.storageKey))"
    }

    fileprivate func uploadPath() -> String {
        if let queryIndex = state.browsePath.firstIndex(of: "?") {
            return "/admin/media/assets/add/" + state.browsePath[queryIndex...]
        }
        return "/admin/media/assets/add/"
    }

    fileprivate func isImage(
        _ type: String
    ) -> Bool {
        ["png", "jpg", "jpeg", "webp", "gif"].contains(type.lowercased())
    }
}
