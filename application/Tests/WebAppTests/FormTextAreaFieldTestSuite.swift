import FeatherWebAdmin
import HTML
import SGML
import Testing
import WebComponents

@testable import WebModuleWebApp

@Suite
struct FormTextAreaFieldTestSuite {

    @Test
    func rendersRequiredTextArea() async throws {
        let result = render(
            AdminFormFieldTextArea(
                state: .init(
                    name: "notes",
                    label: "Notes",
                    value: "Hello",
                    style: .medium,
                    isRequired: true
                )
            )
        )

        #expect(result.contains("name=\"notes\""))
        #expect(result.contains("rows=\"6\""))
        #expect(result.contains("required"))
        #expect(result.contains(">Hello</textarea>"))
    }

    @Test
    func rendersHelpErrorAndStates() async throws {
        let result = render(
            AdminFormFieldTextArea(
                state: .init(
                    name: "content",
                    label: "Content",
                    value: "Draft",
                    error: "Content is invalid.",
                    help: "Write the page content.",
                    style: .large,
                    isDisabled: true,
                    isReadOnly: true
                )
            )
        )

        #expect(result.contains("admin-form-textarea--large"))
        #expect(result.contains("rows=\"9\""))
        #expect(result.contains("aria-invalid=\"true\""))
        #expect(result.contains("aria-errormessage=\"content-error\""))
        #expect(result.contains("disabled"))
        #expect(result.contains("readonly"))
        #expect(result.contains("class=\"admin-form-field-help\""))
        #expect(result.contains("Content is invalid."))
        #expect(result.contains("Write the page content."))
        #expect(result.contains(">Draft</textarea>"))
    }

    private func render(
        _ field: AdminFormFieldTextArea
    ) -> String {
        var context = BuilderContext()
        let root = context.build(field)
        return Document(root: root).render()
    }
}
