import FeatherAdmin
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebComponents
import WebBuilders

struct AssetEditView: Leaf {
    struct State {
        let model: AdminEditMediaAssetModel
        let isEdited: Bool
        let canAccess: Bool
        let breadcrumb: AdminBreadcrumb.State
    }

    let state: State

    func html() -> some BasicTag {
        Section {
            if !state.canAccess {
                H1("Forbidden")
                P("Your account cannot edit media assets.")
            }
            else {
                AdminBreadcrumb(state: state.breadcrumb).html()
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
                ).html()
                AdminDetailsField(label: "Type", value: state.model.type).html()
                AdminDetailsField(label: "Status", value: state.model.status).html()
                AdminDetailsField(
                    label: "Size bytes",
                    value: "\(state.model.sizeBytes)"
                ).html()

                Form {
                    FormInputField(
                        name: "title",
                        label: "Title",
                        value: state.model.title,
                        inputClass: "text-input"
                    ).html()

                    FormInputField(
                        name: "altText",
                        label: "Alt text",
                        value: state.model.altText,
                        inputClass: "text-input"
                    ).html()

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
