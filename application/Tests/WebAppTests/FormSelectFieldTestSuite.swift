import FeatherWebAdmin
import HTML
import SGML
import Testing
import WebComponents

@testable import WebModuleWebApp

@Suite
struct FormSelectFieldTestSuite {

    @Test
    func rendersRequiredSelectWithSelectedOption() async throws {
        let result = render(
            AdminFormFieldSelect(
                state: .init(
                    name: "status",
                    label: "Status",
                    value: "published",
                    options: [
                        .init(label: "Draft", value: "draft"),
                        .init(label: "Published", value: "published"),
                    ],
                    isRequired: true
                )
            )
        )

        #expect(result.contains("name=\"status\""))
        #expect(result.contains("value=\"published\" selected"))
        #expect(result.contains("required"))
        #expect(result.contains("Draft"))
        #expect(result.contains("Published"))
    }

    @Test
    func rendersHelpErrorAndDisabledState() async throws {
        let result = render(
            AdminFormFieldSelect(
                state: .init(
                    name: "status",
                    label: "Status",
                    options: [
                        .init(label: "Draft", value: "draft"),
                        .init(label: "Archived", value: "archived"),
                    ],
                    error: "Status is invalid.",
                    help: "Select the current status.",
                    isDisabled: true
                )
            )
        )

        #expect(result.contains("has-error"))
        #expect(result.contains("aria-invalid=\"true\""))
        #expect(result.contains("aria-errormessage=\"status-error\""))
        #expect(result.contains("disabled"))
        #expect(result.contains("class=\"admin-form-field-help\""))
        #expect(result.contains("Status is invalid."))
        #expect(result.contains("Select the current status."))
    }

    private func render(
        _ field: AdminFormFieldSelect
    ) -> String {
        var context = BuilderContext()
        let root = context.build(field)
        return Document(root: root).render()
    }
}
