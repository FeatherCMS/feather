import HTML
import SGML
import WebStandards

struct AssetAddView: Component {
    struct State {
        let form: FormState
        let breadcrumb: AdminBreadcrumb.State
    }

    struct FormState {
        var parentId: String = ""
        var fileName: String = ""
        var type: String = "bin"
        var title: String = ""
        var altText: String = ""
        var data: String = ""
        var error: String? = nil
        var view: String = "grid"
        var action: String = "/admin/media/assets/add/"
        var isPicker: Bool = false
        var selectedAsset: AdminMediaAssetReferenceModel? = nil
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.form.isPicker {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("Add media asset")
            }
            if let error = state.form.error { P(error).class("error") }
            if let selectedAsset = state.form.selectedAsset {
                Div {}
                    .data(
                        "media-picker-selected-id",
                        selectedAsset.id
                    )
                    .data(
                        "media-picker-selected-storage-key",
                        selectedAsset.storageKey
                    )
                    .data(
                        "media-picker-selected-base-name",
                        selectedAsset.baseName
                    )
                    .data(
                        "media-picker-selected-type",
                        selectedAsset.type
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
                    .hidden()
            }
            if state.form.isPicker {
                pickerUploadContainer()
            }
            else {
                uploadForm()
            }
            Script(
                """
                (function () {
                    var isPicker = \(state.form.isPicker ? "true" : "false");
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
                    function normalizeType(filename, mime) {
                        return normalizeExtension(filename, mime);
                    }
                    function setHiddenFields(file) {
                        if (!file) { return; }
                        if (typeInput) { typeInput.value = normalizeType(file.name, file.type); }
                        if (fileNameInput) { fileNameInput.value = file.name || ""; }
                    }
                    function readFileBase64(file) {
                        return new Promise(function (resolve, reject) {
                            var reader = new FileReader();
                            reader.onload = function () {
                                var result = String(reader.result || "");
                                var idx = result.indexOf(",");
                                resolve(idx >= 0 ? result.slice(idx + 1) : result);
                            };
                            reader.onerror = function () { reject(new Error("File read failed")); };
                            reader.readAsDataURL(file);
                        });
                    }
                    async function populateSelectedFile() {
                        var file = fileInput.files && fileInput.files[0];
                        if (!file) {
                            throw new Error("Please choose a file.");
                        }
                        setHiddenFields(file);
                        dataInput.value = await readFileBase64(file);
                    }
                    var form = document.getElementById("mediaAssetAddForm");
                    var fileInput = document.getElementById("file");
                    var dataInput = document.getElementById("data");
                    var typeInput = document.getElementById("type");
                    var fileNameInput = document.getElementById("fileName");
                    if (!fileInput || !dataInput) { return; }
                    fileInput.addEventListener("change", function () {
                        var file = fileInput.files && fileInput.files[0];
                        if (!file) { return; }
                        setHiddenFields(file);
                    });
                    if (isPicker) {
                        return;
                    }
                    if (!form) { return; }
                    form.addEventListener("submit", async function (event) {
                        event.preventDefault();
                        try {
                            await populateSelectedFile();
                        } catch (_) {
                            alert("Unable to read selected file.");
                            return;
                        }
                        form.submit();
                    });
                })();
                """
            )
        }
        .class("cms-section")
        .if(state.form.isPicker) {
            $0.data(
                "admin-media-picker-section",
                "upload"
            )
        }
    }

    func uploadForm() -> some FlowContent {
        Form {
            Input().type(.hidden).name("parentId")
                .value(state.form.parentId).id("parentId")
            Input().type(.hidden).name("fileName")
                .value(state.form.fileName).id("fileName")
            Input().type(.hidden).name("type").value(state.form.type)
                .id("type")
            Input().type(.hidden).name("view").value(state.form.view)
                .id("view")

            FormInputField(
                name: "title",
                label: "Title",
                value: state.form.title,
                id: "title",
                inputClass: "text-input"
            )

            FormInputField(
                name: "altText",
                label: "Alt text",
                value: state.form.altText,
                id: "altText",
                inputClass: "text-input"
            )

            FormInputField(
                name: "file",
                label: "File",
                id: "file",
                type: .file,
                isRequired: true,
                inputClass: "text-input"
            )
            Input().type(.hidden).name("data").id("data")
                .value(state.form.data)

            Section {
                Div { Button("Add").type(.submit) }.class("button-row")
            }
        }
        .method(.post)
        .action(state.form.action)
        .id("mediaAssetAddForm")
        .class("cms-form")
    }

    func pickerUploadContainer() -> some FlowContent {
        Div {
            Input().type(.hidden).name("parentId")
                .value(state.form.parentId).id("parentId")
            Input().type(.hidden).name("fileName")
                .value(state.form.fileName).id("fileName")
            Input().type(.hidden).name("type").value(state.form.type)
                .id("type")
            Input().type(.hidden).name("view").value(state.form.view)
                .id("view")

            FormInputField(
                name: "title",
                label: "Title",
                value: state.form.title,
                id: "title",
                inputClass: "text-input"
            )

            FormInputField(
                name: "altText",
                label: "Alt text",
                value: state.form.altText,
                id: "altText",
                inputClass: "text-input"
            )

            FormInputField(
                name: "file",
                label: "File",
                id: "file",
                type: .file,
                isRequired: true,
                inputClass: "text-input"
            )
            Input().type(.hidden).name("data").id("data")
                .value(state.form.data)

            Section {
                Div {
                    Button("Add")
                        .type(.button)
                        .data(
                            "admin-media-picker-upload-submit",
                            "1"
                        )
                }
                .class("button-row")
            }
        }
        .id("mediaAssetAddForm")
        .class("cms-form")
        .data("admin-media-picker-upload", "1")
        .data("action", state.form.action)
    }
}
