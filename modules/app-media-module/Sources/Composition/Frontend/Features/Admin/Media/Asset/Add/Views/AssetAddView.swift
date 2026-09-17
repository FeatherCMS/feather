import FeatherAdmin
import FeatherValidation
import Foundation
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
        var selectedAsset: NewAdminMediaAsset? = nil
    }

    let state: State

    func html(context: inout BuilderContext) -> some BasicTag {
        Section {
            if !state.form.isPicker {
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
                        selectedAsset.url
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
                    .hidden()
            }
            if state.form.isPicker {
                pickerUploadContainer(context: &context)
            }
            else {
                uploadForm(context: &context)
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
                    function setHiddenFields(file) {
                        if (!file) { return; }
                        if (extensionInput) { extensionInput.value = normalizeExtension(file.name, file.type); }
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
                    var extensionInput = document.getElementById("extension");
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
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "title",
                        label: "Title",
                        value: state.form.title
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "altText",
                        label: "Alt text",
                        value: state.form.altText
                    )
                )
            )
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "file",
                        label: "File",
                        type: .file,
                        isRequired: true
                    )
                )
            )
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
            Input().type(.hidden).name("data").id("data").value(state.form.data)
            Div {
                context.build(NewAdminSubmitButton("Add asset"))
            }
            .class("new-admin-form__actions")
        }
        return context.build(form).id("mediaAssetAddForm")
    }

    func pickerUploadContainer(
        context: inout BuilderContext
    ) -> some FlowContent {
        Div {
            Input().type(.hidden).name("parentId")
                .value(state.form.parentId).id("parentId")
            Input().type(.hidden).name("fileName")
                .value(state.form.fileName).id("fileName")
            Input().type(.hidden).name("extension").value(state.form.extension)
                .id("extension")
            Input().type(.hidden).name("view").value(state.form.view)
                .id("view")
            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "title",
                        label: "Title",
                        value: state.form.title
                    )
                )
            )

            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "altText",
                        label: "Alt text",
                        value: state.form.altText
                    )
                )
            )

            context.build(
                NewAdminFormFieldInput(
                    state: .init(
                        name: "file",
                        label: "File",
                        type: .file,
                        isRequired: true
                    )
                )
            )
            Input().type(.hidden).name("data").id("data")
                .value(state.form.data)

            Section {
                Div {
                    context.build(NewAdminControlButton("Add asset"))
                        .data(
                            "admin-media-picker-upload-submit",
                            "1"
                        )
                }
                .class("button-row")
            }
        }
        .id("mediaAssetAddForm")
        .class("new-admin-form")
        .data("admin-media-picker-upload", "1")
        .data("action", state.form.action)
    }
}
