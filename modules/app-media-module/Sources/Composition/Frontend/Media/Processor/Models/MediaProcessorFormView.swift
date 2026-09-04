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

struct MediaProcessorFormView: Leaf {
    struct FormState {
        var fileSuffix: String = ""
        var matchExtensions: String = ""
        var commandTemplate: String = ""
        var error: String? = nil
    }

    let title: String
    let submitLabel: String
    let actionURL: String
    let form: FormState
    let breadcrumb: AdminBreadcrumb.State

    func html() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb).html()
            H1(title)
            if let error = form.error { P(error).class("error") }
            Form {
                FormInputField(
                    name: "fileSuffix",
                    label: "File suffix",
                    value: form.fileSuffix,
                    isRequired: true,
                    inputClass: "text-input"
                ).html()

                FormInputField(
                    name: "matchExtensions",
                    label: "Match extensions",
                    value: form.matchExtensions,
                    isRequired: true,
                    inputClass: "text-input"
                ).html()

                FormTextAreaField(
                    name: "commandTemplate",
                    label: "Command template",
                    value: form.commandTemplate,
                    rows: 4,
                    isRequired: true,
                    textareaClass: "text-input"
                ).html()

                Section {
                    P(
                        "The command template is executed for every matching uploaded file. Tokens are replaced before execution, so {input.fullname} points to the temporary source file and {output.fullname} points to the generated file that will be uploaded."
                    )
                    P(
                        "The output filename is generated automatically from the original basename, the file suffix, and the original extension."
                    )
                    P(
                        "Available tokens: {input.fullname}, {input.basename}, {input.extension}, {output.fullname}, {output.basename}, {output.extension}."
                    )
                    P(
                        "Image resize example, 64x64 pixels: convert {input.fullname} -resize 64x64^ -gravity center -extent 64x64 {output.fullname}"
                    )
                    P(
                        "Video preview example, static PNG frame: ffmpeg -y -ss 00:00:01 -i {input.fullname} -frames:v 1 -vf scale=640:360 {output.dirname}/{output.basename}.png"
                    )
                }
                .class("form-help")

                Section {
                    Div { Button(submitLabel).type(.submit) }
                        .class("button-row")
                }
            }
            .encType(.urlencoded)
            .method(.post)
            .action(actionURL)
            .class("cms-form")
        }
        .class("cms-section")
    }
}
