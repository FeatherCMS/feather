import FeatherAdmin
import FeatherValidation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

struct AssetAddView: Component {
    struct State {
        let form: FormState
    }

    struct FormState {
        var parentId: String = ""
        var fileName: String = ""
        var `extension`: String = "bin"
        var title: String = ""
        var altText: String = ""
        var data: String = ""
        var error: String? = nil
        var view: String = "grid"
        var action: String = "/admin/media/assets/add/"
        var isPicker: Bool = false
        var pickerField: String? = nil
        var allowedExtensions: AllowedExtensions = .anything
        var isDialog: Bool = false
        var previewVariant: String? = nil
        var selectedAsset: NewAdminMediaAsset? = nil
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            if !state.form.isPicker && !state.form.isDialog {
                context.build(
                    NewAdminBreadcrumb(links: MediaAssetRoutes.breadcrumb)
                )
                context.build(
                    NewAdminPageHeader(
                        state: .init(
                            title: "Add media asset",
                            description: "Upload a media asset to the library."
                        )
                    )
                )
            }
            if let error = state.form.error {
                P(error).class("new-admin-form__error")
            }
            if let selectedAsset = state.form.selectedAsset {
                Div {}
                    .data(
                        "media-picker-selected-id",
                        selectedAsset.id
                    )
                    .data(
                        "media-picker-selected-url",
                        NewAdminMediaAsset.mediaURL(path: selectedAsset.url)
                    )
                    .data(
                        "media-picker-selected-preview-url",
                        selectedPreviewURL(for: selectedAsset).map {
                            NewAdminMediaAsset.mediaURL(path: $0)
                        } ?? ""
                    )
                    .data(
                        "media-picker-selected-name",
                        selectedAsset.name
                    )
                    .data(
                        "media-picker-selected-extension",
                        selectedAsset.extension
                    )
                    .data(
                        "media-picker-selected-title",
                        selectedAsset.title ?? ""
                    )
                    .data(
                        "media-picker-selected-alt-text",
                        selectedAsset.altText ?? ""
                    )
                    .data(
                        "media-picker-selected-status",
                        selectedAsset.status
                    )
                    .data(
                        "media-picker-selected-field",
                        state.form.pickerField ?? ""
                    )
                    .hidden()
            }
            uploadForm(context: &context)
            Style(
                    """
                        .new-admin-media-upload__dropzone {
                            position: relative;
                            display: flex;
                            flex-direction: column;
                            align-items: center;
                            justify-content: center;
                            gap: 8px;
                            min-height: 150px;
                            padding: 24px;
                            overflow: hidden;
                            border: 2px dashed var(--material-color-tertiary-border);
                            border-radius: 12px;
                            background: var(--material-color-tertiary-tint);
                            color: var(--material-color-tertiary-text);
                            text-align: center;
                            margin-bottom: 12px;
                            transition: border-color .15s ease, background .15s ease;
                        }
                        .new-admin-media-upload__dropzone.is-dragover {
                            border-color: var(--link-color-hover);
                            background: var(--material-color-secondary-tint);
                        }
                        .new-admin-media-upload__icon {
                            display: block;
                            flex: 0 0 auto;
                            width: 32px;
                            height: 32px;
                            color: var(--link-color-default);
                        }
                        .new-admin-media-upload__help {
                            margin: 0;
                            color: var(--material-color-tertiary-text);
                            font-size: .9rem;
                        }
                        .new-admin-media-upload__input {
                            position: absolute;
                            inset: 0;
                            width: 100%;
                            height: 100%;
                            cursor: pointer;
                            opacity: 0;
                        }
                        .new-admin-media-upload__queue {
                            display: flex;
                            flex-direction: column;
                            gap: 6px;
                            margin: 0 0 12px;
                            padding: 0;
                            list-style: none;
                        }
                        .new-admin-media-upload > .new-admin-form__error {
                            margin: 0 0 12px;
                        }
                        .new-admin-media-upload__summary {
                            display: flex;
                            flex-direction: column;
                            gap: 8px;
                            margin: 0 0 12px;
                            padding: 10px 12px;
                            border: 1px solid var(--material-color-tertiary-border);
                            border-radius: 8px;
                            background: var(--material-color-tertiary-tint);
                        }
                        .new-admin-media-upload__summary[hidden] {
                            display: none;
                        }
                        .new-admin-media-upload__summary-header {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            gap: 12px;
                        }
                        .new-admin-media-upload__summary-total {
                            display: inline-flex;
                            align-items: center;
                            gap: 6px;
                        }
                        .new-admin-media-upload__summary-label,
                        .new-admin-media-upload__summary-size,
                        .new-admin-media-upload__summary-count,
                        .new-admin-media-upload__summary-progress {
                            color: var(--material-color-tertiary-text);
                            font-size: .86rem;
                        }
                        .new-admin-media-upload__summary-label {
                            font-weight: 600;
                        }
                        .new-admin-media-upload__progress[hidden],
                        .new-admin-media-upload__summary-progress[hidden] {
                            display: none;
                        }
                        .new-admin-media-upload__progress {
                            height: 6px;
                            overflow: hidden;
                            border-radius: 999px;
                            background: var(--material-color-tertiary-border);
                        }
                        .new-admin-media-upload__progress-bar {
                            width: 0;
                            height: 100%;
                            border-radius: inherit;
                            background: var(--link-color-default);
                            transition: width .15s ease;
                        }
                        .new-admin-media-upload__item {
                            display: flex;
                            align-items: center;
                            justify-content: space-between;
                            gap: 16px;
                            min-height: 58px;
                            padding: 9px 12px;
                            border: 1px solid var(--material-color-tertiary-border);
                            border-radius: 8px;
                            background: var(--material-color-tertiary-tint);
                        }
                        .new-admin-media-upload__details {
                            display: flex;
                            flex-direction: column;
                            min-width: 0;
                            gap: 3px;
                        }
                        .new-admin-media-upload__name {
                            min-width: 0;
                            overflow: hidden;
                            text-overflow: ellipsis;
                            white-space: nowrap;
                        }
                        .new-admin-media-upload__size {
                            color: var(--material-color-tertiary-text);
                            font-size: .82rem;
                        }
                        .new-admin-media-upload__actions {
                            display: inline-flex;
                            align-items: center;
                            justify-content: flex-end;
                            flex: 0 0 auto;
                            gap: 8px;
                            min-width: 88px;
                            min-height: 32px;
                        }
                        .new-admin-media-upload__status {
                            display: inline-flex;
                            align-items: center;
                            justify-content: flex-end;
                            min-width: 88px;
                            min-height: 32px;
                            color: var(--material-color-tertiary-text);
                            font-size: .86rem;
                            text-align: right;
                        }
                        .new-admin-media-upload__item.is-uploading .new-admin-media-upload__status {
                            color: var(--link-color-default);
                        }
                        .new-admin-media-upload__item.is-success .new-admin-media-upload__status {
                            color: var(--color-green-foreground);
                        }
                        .new-admin-media-upload__item.is-error .new-admin-media-upload__status {
                            color: var(--color-red-foreground);
                        }
                    """
            )
            Script(
                """
                (function () {
                    function initialize() {
                    var isPicker = \(state.form.isPicker ? "true" : "false");
                    var isDialog = \(state.form.isDialog ? "true" : "false");
                    var maxWorkers = 4;
                    var queue = [];
                    var isUploading = false;
                    var uploadStarted = false;
                    var workerURL = null;
                    var totalSizeElement = null;
                    var totalCountElement = null;
                    var totalProgressElement = null;
                    var progressBarElement = null;
                    var progressElement = null;
                    var summaryElement = null;
                    var allowedExtensions = [];
                    function normalizeExtension(filename, mime) {
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
                    function encoded(value) {
                        return encodeURIComponent(String(value || ""));
                    }
                    function uploadHeaders(form, file) {
                        var value = function (name) {
                            var input = form.querySelector('[name="' + name + '"]');
                            return input ? input.value : "";
                        };
                        var headers = {
                            "Content-Type": "application/octet-stream",
                            "X-Media-Asset-File-Name": encoded(file.name || ""),
                            "X-Media-Asset-Extension": encoded(
                                normalizeExtension(file.name, file.type)
                            )
                        };
                        if (isDialog) {
                            headers["Accept"] = "text/html; type=admin-dialog";
                        }
                        var optional = [
                            ["parentId", "X-Media-Asset-Parent-ID"],
                            ["title", "X-Media-Asset-Title"],
                            ["altText", "X-Media-Asset-Alt-Text"]
                        ];
                        optional.forEach(function (item) {
                            var current = value(item[0]);
                            if (current) { headers[item[1]] = encoded(current); }
                        });
                        return headers;
                    }
                    function fileKey(file) {
                        return [file.name, file.size, file.lastModified].join(":");
                    }
                    function formatBytes(value) {
                        var bytes = Number(value) || 0;
                        if (bytes < 1024) { return bytes + " B"; }
                        var units = ["KB", "MB", "GB", "TB"];
                        var unitIndex = -1;
                        do {
                            bytes /= 1024;
                            unitIndex += 1;
                        } while (bytes >= 1024 && unitIndex < units.length - 1);
                        var precision = bytes >= 10 ? 0 : 1;
                        return bytes.toFixed(precision) + " " + units[unitIndex];
                    }
                    function itemProgress(item) {
                        if (item.status === "success") { return 100; }
                        var size = Number(item.file.size) || 0;
                        if (!size) { return 0; }
                        return Math.min(
                            100,
                            Math.floor((Number(item.uploadedBytes) || 0) / size * 100)
                        );
                    }
                    function renderTotalProgress() {
                        if (
                            !totalSizeElement ||
                            !totalCountElement ||
                            !totalProgressElement ||
                            !progressBarElement ||
                            !progressElement ||
                            !summaryElement
                        ) {
                            return;
                        }
                        var totalSize = queue.reduce(function (total, item) {
                            return total + (Number(item.file.size) || 0);
                        }, 0);
                        var uploadedSize = queue.reduce(function (total, item) {
                            return total + (Number(item.uploadedBytes) || 0);
                        }, 0);
                        var progress = totalSize
                            ? Math.min(100, Math.floor(uploadedSize / totalSize * 100))
                            : 0;
                        totalCountElement.textContent = queue.length +
                            (queue.length === 1 ? " file" : " files");
                        totalSizeElement.textContent = formatBytes(totalSize);
                        totalProgressElement.textContent =
                            formatBytes(uploadedSize) + " of " +
                            formatBytes(totalSize) + " uploaded (" + progress + "%)";
                        progressBarElement.style.width = progress + "%";
                        summaryElement.hidden = queue.length === 0;
                        progressElement.hidden = !uploadStarted;
                        totalProgressElement.hidden = !uploadStarted;
                    }
                    function statusLabel(item) {
                        if (item.status === "uploading") {
                            return itemProgress(item) + "%";
                        }
                        if (item.status === "success") { return "Uploaded"; }
                        if (item.status === "error") { return item.error || "Failed"; }
                        return uploadStarted ? "Waiting" : "";
                    }
                    function renderQueue() {
                        if (!queueElement) { return; }
                        queueElement.replaceChildren();
                        queue.forEach(function (item, index) {
                            var row = document.createElement("li");
                            row.className = "new-admin-media-upload__item is-" + item.status;
                            var details = document.createElement("span");
                            details.className = "new-admin-media-upload__details";
                            var name = document.createElement("span");
                            name.className = "new-admin-media-upload__name";
                            name.textContent = item.file.name;
                            details.appendChild(name);
                            var size = document.createElement("span");
                            size.className = "new-admin-media-upload__size";
                            size.textContent = formatBytes(item.file.size);
                            details.appendChild(size);
                            row.appendChild(details);
                            var actions = document.createElement("span");
                            actions.className = "new-admin-media-upload__actions";
                            var label = statusLabel(item);
                            if (label) {
                                var status = document.createElement("span");
                                status.className = "new-admin-media-upload__status";
                                status.textContent = label;
                                actions.appendChild(status);
                            }
                            if (item.status === "pending" || item.status === "error") {
                                var removeButton = document.createElement("button");
                                removeButton.type = "button";
                                removeButton.className = "button destructive row-button";
                                removeButton.textContent = "Remove";
                                removeButton.setAttribute(
                                    "aria-label",
                                    "Remove " + item.file.name
                                );
                                removeButton.setAttribute(
                                    "data-media-upload-remove",
                                    String(index)
                                );
                                actions.appendChild(removeButton);
                            }
                            row.appendChild(actions);
                            queueElement.appendChild(row);
                        });
                        renderTotalProgress();
                    }
                    function addFiles(files) {
                        var rejected = [];
                        Array.from(files || []).forEach(function (file) {
                            if (!file || queue.some(function (item) {
                                return fileKey(item.file) === fileKey(file);
                            })) {
                                return;
                            }
                            var extension = normalizeExtension(file.name, file.type);
                            if (
                                allowedExtensions.length &&
                                allowedExtensions.indexOf(extension) < 0
                            ) {
                                rejected.push(file.name || "Selected file");
                                return;
                            }
                            queue.push({
                                file: file,
                                status: "pending",
                                error: "",
                                uploadedBytes: 0
                            });
                        });
                        if (rejected.length) {
                            setUploadError(
                                "Only " + allowedExtensions.join(", ") +
                                " files are allowed. Rejected: " + rejected.join(", ")
                            );
                        }
                        else if (queue.length) {
                            setUploadError("");
                        }
                        if (queue.length) {
                            queueElement.hidden = false;
                            renderQueue();
                        }
                    }
                    function updateUnloadGuard() {
                        if (isUploading) {
                            window.addEventListener("beforeunload", beforeUnload);
                        } else {
                            window.removeEventListener("beforeunload", beforeUnload);
                        }
                    }
                    function beforeUnload(event) {
                        var message = "Uploads are still in progress. Leave this page?";
                        event.preventDefault();
                        event.returnValue = message;
                        return message;
                    }
                    function setUploadError(message) {
                        var error = document.getElementById(
                            "mediaAssetUploadError"
                        );
                        if (!error) { return; }
                        error.textContent = message || "";
                        error.hidden = !message;
                    }
                    function workerSource() {
                        return `
                            function extractError(body) {
                                var marker = 'class="new-admin-form__error"';
                                var markerIndex = body.indexOf(marker);
                                if (markerIndex < 0) { return ""; }
                                var contentStart = body.indexOf(">", markerIndex);
                                var contentEnd = body.indexOf(
                                    "</p>",
                                    contentStart
                                );
                                if (contentStart < 0 || contentEnd < 0) {
                                    return "";
                                }
                                return body.slice(contentStart + 1, contentEnd)
                                    .replace(/<[^>]*>/g, "")
                                    .replace(/&amp;/g, "&")
                                    .replace(/&quot;/g, String.fromCharCode(34))
                                    .replace(/&#39;/g, "'")
                                    .replace(/&lt;/g, "<")
                                    .replace(/&gt;/g, ">")
                                    .trim();
                            }
                            self.onmessage = async function (event) {
                                var data = event.data;
                                var xhr = new XMLHttpRequest();
                                xhr.open("POST", data.url, true);
                                xhr.withCredentials = true;
                                Object.keys(data.headers || {}).forEach(function (name) {
                                    xhr.setRequestHeader(name, data.headers[name]);
                                });
                                if (xhr.upload) {
                                    xhr.upload.onprogress = function (event) {
                                        if (!event.lengthComputable) { return; }
                                        self.postMessage({
                                            status: "progress",
                                            loaded: event.loaded,
                                            total: event.total
                                        });
                                    };
                                }
                                xhr.onload = function () {
                                    var expectedURL = new URL(
                                        data.url,
                                        data.baseURL
                                    ).href;
                                    var redirected = xhr.responseURL &&
                                        xhr.responseURL !== expectedURL;
                                    var successful = xhr.status === 204 ||
                                        xhr.status === 201 ||
                                        (xhr.status >= 200 && xhr.status < 300 &&
                                            (redirected || data.isPicker));
                                    if (!successful) {
                                        self.postMessage({
                                            status: "error",
                                            error: extractError(xhr.responseText || "") ||
                                                "Upload failed with status " + xhr.status
                                        });
                                        return;
                                    }
                                    self.postMessage({
                                        status: "success",
                                        url: xhr.responseURL || "",
                                        html: data.isPicker ? (xhr.responseText || "") : ""
                                    });
                                };
                                xhr.onerror = function () {
                                    self.postMessage({
                                        status: "error",
                                        error: "Upload failed"
                                    });
                                };
                                xhr.ontimeout = function () {
                                    self.postMessage({
                                        status: "error",
                                        error: "Upload timed out"
                                    });
                                };
                                try {
                                    xhr.send(data.file);
                                } catch (error) {
                                    self.postMessage({
                                        status: "error",
                                        error: error && error.message ? error.message : "Upload failed"
                                    });
                                }
                            };
                        `;
                    }
                    function uploadFile(item) {
                        item.status = "uploading";
                        item.error = "";
                        item.uploadedBytes = 0;
                        renderQueue();
                        return new Promise(function (resolve) {
                            var worker;
                            var settled = false;
                            function finish(result) {
                                if (settled) { return; }
                                settled = true;
                                if (worker) { worker.terminate(); }
                                resolve(result);
                            }
                            try {
                                worker = new Worker(workerURL);
                                worker.onmessage = function (event) {
                                    if (event.data.status === "progress") {
                                        item.uploadedBytes = Math.min(
                                            Number(item.file.size) || 0,
                                            Number(event.data.loaded) || 0
                                        );
                                        renderQueue();
                                        return;
                                    }
                                    if (event.data.status === "success") {
                                        item.status = "success";
                                        item.uploadedBytes = item.file.size;
                                        renderQueue();
                                        finish({
                                            url: event.data.url || "",
                                            html: event.data.html || ""
                                        });
                                    } else {
                                        item.status = "error";
                                        item.error = event.data.error || "Upload failed";
                                        renderQueue();
                                        finish({ error: item.error });
                                    }
                                };
                                worker.onerror = function () {
                                    item.status = "error";
                                    item.error = "Upload failed";
                                    renderQueue();
                                    finish({ error: item.error });
                                };
                                worker.postMessage({
                                    url: form.action,
                                    file: item.file,
                                    baseURL: window.location.href,
                                    isPicker: isPicker,
                                    headers: uploadHeaders(form, item.file)
                                });
                            } catch (_) {
                                item.status = "error";
                                item.error = "Web worker upload is unavailable";
                                renderQueue();
                                finish({ error: item.error });
                            }
                        });
                    }
                    async function uploadQueue() {
                        if (isUploading) { return; }
                        var pending = queue.filter(function (item) {
                            return item.status !== "success";
                        });
                        if (!pending.length) {
                            setUploadError("Choose one or more files to upload.");
                            return;
                        }
                        if (!workerURL) {
                            workerURL = window.URL.createObjectURL(
                                new Blob([workerSource()], {
                                    type: "application/javascript"
                                })
                            );
                        }
                        uploadStarted = true;
                        setUploadError("");
                        queueElement.hidden = false;
                        renderQueue();
                        isUploading = true;
                        updateUnloadGuard();
                        var nextIndex = 0;
                        var returnURL = "";
                        var dialogHTML = "";
                        async function workerLoop() {
                            while (nextIndex < pending.length) {
                                var item = pending[nextIndex++];
                                var result = await uploadFile(item);
                                if (!returnURL && result.url) { returnURL = result.url; }
                                if (!dialogHTML && result.html) { dialogHTML = result.html; }
                            }
                        }
                        var loops = [];
                        var workerCount = Math.min(maxWorkers, pending.length);
                        for (var index = 0; index < workerCount; index += 1) {
                            loops.push(workerLoop());
                        }
                        await Promise.all(loops);
                        isUploading = false;
                        updateUnloadGuard();
                        if (workerURL) {
                            window.URL.revokeObjectURL(workerURL);
                            workerURL = null;
                        }
                        var failed = queue.filter(function (item) {
                            return item.status === "error";
                        });
                        if (failed.length) {
                            setUploadError(
                                "Some files could not be uploaded. Review the errors and try again."
                            );
                            return;
                        }
                        if (isPicker && isDialog && dialogHTML) {
                            var mounted = window.__newAdminDialog &&
                                window.__newAdminDialog.mountHTML(dialogHTML);
                            if (
                                mounted &&
                                window.__newAdminMediaPickerController &&
                                typeof window.__newAdminMediaPickerController.applyMarker ===
                                    "function"
                            ) {
                                window.__newAdminMediaPickerController.applyMarker(
                                    document.querySelector(
                                        "dialog[data-admin-dialog]"
                                    )
                                );
                            }
                            if (!mounted) {
                                setUploadError("Unable to select uploaded asset.");
                            }
                            return;
                        }
                        window.location.assign(returnURL || window.location.href);
                    }
                    var form = document.getElementById("mediaAssetAddForm");
                    if (form) {
                        allowedExtensions = String(
                            form.getAttribute("data-allowed-extensions") || ""
                        ).split(",").map(function (extension) {
                            return extension.trim().toLowerCase();
                        }).filter(function (extension) {
                            return extension.length > 0;
                        });
                    }
                    var fileInput = document.getElementById("file");
                    var dropzone = document.querySelector(
                        "[data-media-asset-dropzone]"
                    );
                    var queueElement = document.getElementById(
                        "mediaAssetUploadQueue"
                    );
                    totalSizeElement = document.getElementById(
                        "mediaAssetUploadTotalSize"
                    );
                    totalCountElement = document.getElementById(
                        "mediaAssetUploadTotalCount"
                    );
                    totalProgressElement = document.getElementById(
                        "mediaAssetUploadTotalProgress"
                    );
                    progressBarElement = document.getElementById(
                        "mediaAssetUploadProgressBar"
                    );
                    progressElement = document.getElementById(
                        "mediaAssetUploadProgress"
                    );
                    summaryElement = document.getElementById(
                        "mediaAssetUploadSummary"
                    );
                    if (!fileInput || !form) {
                        window.setTimeout(initialize, 0);
                        return;
                    }
                    if (form && form.dataset.mediaAssetUploadBound === "1") {
                        return;
                    }
                    if (form) {
                        form.dataset.mediaAssetUploadBound = "1";
                    }
                    fileInput.addEventListener("change", function () {
                        addFiles(fileInput.files);
                        fileInput.value = "";
                    });
                    if (!dropzone || !queueElement) { return; }
                    queueElement.addEventListener("click", function (event) {
                        var button = event.target.closest(
                            "[data-media-upload-remove]"
                        );
                        if (!button || isUploading) { return; }
                        var index = Number(
                            button.getAttribute("data-media-upload-remove")
                        );
                        if (!Number.isInteger(index) || !queue[index]) { return; }
                        if (
                            queue[index].status === "uploading" ||
                            queue[index].status === "success"
                        ) {
                            return;
                        }
                        queue.splice(index, 1);
                        queueElement.hidden = queue.length === 0;
                        renderQueue();
                    });
                    ["dragenter", "dragover"].forEach(function (eventName) {
                        dropzone.addEventListener(eventName, function (event) {
                            event.preventDefault();
                            dropzone.classList.add("is-dragover");
                        });
                    });
                    ["dragleave", "drop"].forEach(function (eventName) {
                        dropzone.addEventListener(eventName, function (event) {
                            event.preventDefault();
                            dropzone.classList.remove("is-dragover");
                        });
                    });
                    dropzone.addEventListener("drop", function (event) {
                        addFiles(event.dataTransfer && event.dataTransfer.files);
                    });
                    form.addEventListener("submit", function (event) {
                        event.stopPropagation();
                        event.stopImmediatePropagation();
                        event.preventDefault();
                        uploadQueue();
                    });
                    }
                    if (document.readyState === "loading") {
                        document.addEventListener("DOMContentLoaded", initialize, { once: true });
                    } else {
                        initialize();
                    }
                }());
                """
            )
        }
        .class("cms-section")
        .if(state.form.isPicker) {
            $0.data("media-picker-field", state.form.pickerField ?? "")
        }
    }

    private func selectedPreviewURL(
        for asset: NewAdminMediaAsset
    ) -> String? {
        state.form.previewVariant == "cover"
            ? asset.coverURL ?? asset.previewURL
            : asset.previewURL
    }

    func uploadForm(
        context: inout BuilderContext
    ) -> some FlowContent {
        let form = NewAdminForm(
            action: state.form.action,
            hiddenFields: [
                .init(name: "parentId", value: state.form.parentId),
                .init(name: "view", value: state.form.view),
            ]
        ) {
            uploadDropzone(context: &context)
            Input()
                .type(.hidden)
                .name("fileName")
                .id("fileName")
                .value(state.form.fileName)
            Input()
                .type(.hidden)
                .name("extension")
                .id("extension")
                .value(state.form.extension)
            uploadSummary()
            Div {
                context.build(NewAdminSubmitButton("Upload"))
            }
            .class("new-admin-form__actions")
        }
        return context.build(form)
            .id("mediaAssetAddForm")
            .data(
                "allowed-extensions",
                state.form.allowedExtensions.queryValue
            )
    }

    func uploadDropzone(
        context: inout BuilderContext
    ) -> some FlowContent {
        Section {
            Div {
                FeatherIcons.get(named: "plusCircle")!
                    .class("new-admin-media-upload__icon")
                Strong(
                    state.form.isPicker
                        ? "Drop a file here or choose a file"
                        : "Drop files here or choose files"
                )
                if !state.form.isPicker {
                    P("You can upload multiple files at once.")
                        .class("new-admin-media-upload__help")
                }
                Input()
                    .type(.file)
                    .name("file")
                    .id("file")
                    .if(!state.form.isPicker) {
                        $0.setAttribute(name: "multiple", value: "multiple")
                    }
                    .if(!state.form.allowedExtensions.isAnything) {
                        $0.setAttribute(
                            name: "accept",
                            value: state.form.allowedExtensions.values
                                .map { ".\($0)" }
                                .joined(separator: ",")
                        )
                    }
                    .class("new-admin-media-upload__input")
            }
            .class("new-admin-media-upload__dropzone")
            .data("media-asset-dropzone", "1")
            Ul {}
                .id("mediaAssetUploadQueue")
                .class("new-admin-media-upload__queue")
                .hidden()
            P {}
                .id("mediaAssetUploadError")
                .class("new-admin-form__error")
                .hidden()
        }
        .class("new-admin-form-field new-admin-media-upload")
    }

    func uploadSummary() -> some FlowContent {
        Div {
            Div {
                Span {}
                    .id("mediaAssetUploadTotalCount")
                    .class("new-admin-media-upload__summary-count")
                Div {
                    Span("Total")
                        .class("new-admin-media-upload__summary-label")
                    Span {}
                        .id("mediaAssetUploadTotalSize")
                        .class("new-admin-media-upload__summary-size")
                }
                .class("new-admin-media-upload__summary-total")
            }
            .class("new-admin-media-upload__summary-header")
            Div {
                Div {}
                    .id("mediaAssetUploadProgressBar")
                    .class("new-admin-media-upload__progress-bar")
            }
            .id("mediaAssetUploadProgress")
            .class("new-admin-media-upload__progress")
            .hidden()
            Span {}
                .id("mediaAssetUploadTotalProgress")
                .class("new-admin-media-upload__summary-progress")
                .hidden()
        }
        .id("mediaAssetUploadSummary")
        .class("new-admin-media-upload__summary")
        .hidden()
    }

}
