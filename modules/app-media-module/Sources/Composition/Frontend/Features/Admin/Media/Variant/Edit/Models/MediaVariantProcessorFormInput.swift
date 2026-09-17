import FeatherAdmin
import FeatherValidation
import Foundation

struct MediaVariantProcessorFormInput: Decodable, Sendable, Equatable, Hashable
{
    let name: String
    let matchExtensions: String
    let commandTemplate: String
    let isActive: NewAdminFormFieldCheckbox.Input

    var normalizedName: String {
        name.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var normalizedExtensions: String {
        matchExtensions.trimmingCharacters(in: .whitespacesAndNewlines)
    }
    var normalizedCommand: String {
        commandTemplate.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func validate() async throws(ValidationError) {
        try await GroupValidator {
            Validator(
                key: "name",
                value: name,
                required: true,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Processor name is required."),
                    .max(
                        length: 254,
                        message:
                            "Processor name must be shorter than 255 characters."
                    ),
                ]
            )
            Validator(
                key: "matchExtensions",
                value: matchExtensions,
                required: true,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Input extensions are required.")
                ]
            )
            Validator(
                key: "commandTemplate",
                value: commandTemplate,
                required: true,
                invocation: .all,
                rules: [
                    .trimmedNonempty(message: "Command template is required.")
                ]
            )
        }
        .validate()
    }
}
