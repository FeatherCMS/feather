import HTML
import SGML
import WebStandards

struct AssetEditView: Component {
    struct State {
        let model: AdminEditMediaAssetModel
        let isEdited: Bool
        let canAccess: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func content() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your account cannot edit media assets.")
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb)
                H1("Edit media asset")
                if state.isEdited {
                    P("Media asset updated successfully.")
                }
                if let error = state.model.error {
                    P(error).class("error")
                }

                AdminDetailsField(
                    label: "Storage key",
                    value: state.model.storageKey
                )
                AdminDetailsField(label: "Type", value: state.model.type)
                AdminDetailsField(label: "Status", value: state.model.status)
                AdminDetailsField(
                    label: "Size bytes",
                    value: "\(state.model.sizeBytes)"
                )

                Form {
                    Section {
                        Label {
                            AdminFieldLabel(label: "Title", required: false)
                            Input().type(.text).class("text-input")
                                .name("title")
                                .value(state.model.title).id("title")
                        }
                    }

                    Section {
                        Label {
                            AdminFieldLabel(label: "Alt text", required: false)
                            Input().type(.text).class("text-input")
                                .name("altText")
                                .value(state.model.altText).id("altText")
                        }
                    }

                    Section {
                        Div { Button("Save").type(.submit) }.class("button-row")
                    }
                }
                .method(.post)
                .action("/admin/media/assets/\(state.model.id)/edit/")
                .class("cms-form")
            }
        }
        .class("cms-section")
    }
}
