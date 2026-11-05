import FeatherWebAdmin
import HTML
import SGML
import Testing
import WebComponents

@testable import WebModuleWebApp

@Suite
struct CheckboxFieldTestSuite {

    @Test
    func rendersCheckedCheckbox() async throws {
        let result = render(
            AdminFormFieldCheckbox(
                state: .init(
                    name: "persistent",
                    checkboxLabel: "Remember me",
                    isChecked: true
                )
            )
        )

        #expect(result.contains("name=\"persistent\""))
        #expect(result.contains("checked"))
        #expect(result.contains("Remember me"))
    }

    @Test
    func rendersErrorAndDisabledState() async throws {
        let result = render(
            AdminFormFieldCheckbox(
                state: .init(
                    name: "noIndex",
                    label: "Indexing",
                    checkboxLabel: "Prevent indexing",
                    error: "No index value is invalid.",
                    help: "Control search engine indexing.",
                    isDisabled: true
                )
            )
        )

        #expect(result.contains("has-error"))
        #expect(result.contains("aria-invalid=\"true\""))
        #expect(result.contains("disabled"))
        #expect(result.contains("No index value is invalid."))
        #expect(result.contains("Control search engine indexing."))
    }

    private func render(
        _ field: AdminFormFieldCheckbox
    ) -> String {
        var context = BuilderContext()
        let root = context.build(field)
        return Document(root: root).render()
    }
}
