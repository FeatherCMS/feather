import FeatherAdmin
import FeatherContracts
import FeatherValidation
import Foundation
import HTML
import Hummingbird
import MediaAdminAPI
import OpenAPIRuntime
import SGML
import WebBuilders
import WebComponents

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
    let permissions: NewAdminListActions
    let requiredPermission: PermissionKey
    let removeHref: String?

    func html(context: inout RenderContext) -> some BasicTag {
        Section {
            context.render(
                NewAdminBreadcrumb(links: MediaProcessorRoutes.breadcrumb)
            )
            context.render(
                NewAdminPageHeader(
                    state: .init(
                        title: title,
                        description:
                            "Configure an automated media processing rule."
                    )
                )
            )
            if !permissions.allows(requiredPermission) {
                context.render(
                    NewAdminStatusView(
                        state: .init(
                            title: "Forbidden",
                            message:
                                "Your account cannot edit media processors."
                        ),
                        icon: FeatherIcons.lock()
                    )
                )
            }
            else {
                let adminForm = NewAdminForm(action: actionURL) {
                    if let error = form.error {
                        P(error).class("new-admin-form__error")
                    }
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "fileSuffix",
                                label: "File suffix",
                                value: form.fileSuffix,
                                isRequired: true
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldInput(
                            state: .init(
                                name: "matchExtensions",
                                label: "Match extensions",
                                value: form.matchExtensions,
                                isRequired: true
                            )
                        )
                    )
                    context.render(
                        NewAdminFormFieldTextArea(
                            state: .init(
                                name: "commandTemplate",
                                label: "Command template",
                                value: form.commandTemplate,
                                style: .small,
                                isRequired: true
                            )
                        )
                    )

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

                    Div {
                        context.render(NewAdminSubmitButton(submitLabel))
                        if let removeHref {
                            context.render(
                                NewAdminButton(
                                    "Remove",
                                    href: removeHref,
                                    style: .destructive
                                )
                            )
                        }
                    }
                    .class("new-admin-form__actions")
                }
                context.render(adminForm)
            }
        }
        .class("cms-section")
    }
}
