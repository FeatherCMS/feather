import HTML
import SGML
import WebStandards

struct MediaProcessorFormView: Component {
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

    func content() -> some BasicTag {
        Section {
            AdminBreadcrumb(state: breadcrumb)
            H1(title)
            if let error = form.error { P(error).class("error") }
            Form {
                Section {
                    Label {
                        AdminFieldLabel(label: "File suffix", required: true)
                        Input().type(.text).class("text-input")
                            .name("fileSuffix").id("fileSuffix")
                            .value(form.fileSuffix)
                    }
                }

                Section {
                    Label {
                        AdminFieldLabel(
                            label: "Match extensions",
                            required: true
                        )
                        Input().type(.text).class("text-input")
                            .name("matchExtensions").id("matchExtensions")
                            .value(form.matchExtensions)
                    }
                }

                Section {
                    Label {
                        AdminFieldLabel(
                            label: "Command template",
                            required: true
                        )
                        Textarea(form.commandTemplate).class("text-input")
                            .name("commandTemplate").id("commandTemplate")
                    }
                }

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
