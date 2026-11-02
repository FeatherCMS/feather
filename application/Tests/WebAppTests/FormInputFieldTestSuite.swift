import FeatherWebAdmin
import HTML
import SGML
import Testing
import WebComponents

@testable import WebModuleWebApp

@Suite
struct FormInputFieldTestSuite {

    @Test
    func rendersRequiredInput() async throws {
        let result = render(
            AdminFormFieldInput(
                state: .init(
                    name: "title",
                    label: "Title",
                    value: "Hello",
                    isRequired: true
                )
            )
        )

        #expect(result.contains("name=\"title\""))
        #expect(result.contains("value=\"Hello\""))
        #expect(result.contains("required"))
        #expect(result.contains("Title"))
    }

    @Test
    func rendersHelpErrorAndInputType() async throws {
        let result = render(
            AdminFormFieldInput(
                state: .init(
                    name: "email",
                    label: "Email",
                    value: "invalid",
                    error: "Email is invalid.",
                    help: "Use your work email.",
                    type: .email
                )
            )
        )

        #expect(result.contains("type=\"email\""))
        #expect(result.contains("value=\"invalid\""))
        #expect(result.contains("aria-invalid=\"true\""))
        #expect(result.contains("aria-errormessage=\"email-error\""))
        #expect(result.contains("class=\"admin-form-field-help\""))
        #expect(result.contains("Email is invalid."))
        #expect(result.contains("Use your work email."))
    }

    @Test
    func rendersDisabledAndReadOnlyStates() async throws {
        let result = render(
            AdminFormFieldInput(
                state: .init(
                    name: "slug",
                    label: "Slug",
                    isDisabled: true,
                    isReadOnly: true
                )
            )
        )

        #expect(result.contains("name=\"slug\""))
        #expect(result.contains("disabled"))
        #expect(result.contains("readonly"))
    }

    private func render(
        _ input: AdminFormFieldInput
    ) -> String {
        var context = BuilderContext()
        let root = context.build(input)
        return Document(root: root).render()
    }
}
