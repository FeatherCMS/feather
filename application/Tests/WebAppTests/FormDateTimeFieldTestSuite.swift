import FeatherWebAdmin
import HTML
import SGML
import Testing
import WebComponents

@testable import WebModuleWebApp

@Suite
struct FormDateTimeFieldTestSuite {

    @Test
    func rendersDateTimePicker() async throws {
        let result = render(
            AdminFormFieldDateTimePicker(
                state: .init(
                    name: "publicationDate",
                    label: "Publication date & time",
                    value: "2026-07-22T14:30:00Z",
                    isRequired: true
                )
            )
        )

        #expect(result.contains("class=\"admin-date-picker\""))
        #expect(result.contains("data-mode=\"dateTime\""))
        #expect(result.contains("id=\"publicationDate-display\""))
        #expect(result.contains("name=\"publicationDate\""))
        #expect(result.contains("id=\"publicationDate-picker\""))
        #expect(result.contains("role=\"dialog\""))
        #expect(result.contains("id=\"publicationDate-hour\""))
        #expect(result.contains("id=\"publicationDate-minute\""))
        #expect(result.contains("new Intl.DateTimeFormat"))
    }

    @Test
    func rendersHelpErrorAndDisabledState() async throws {
        let result = render(
            AdminFormFieldDateTimePicker(
                state: .init(
                    name: "publicationDate",
                    label: "Publication date & time",
                    error: "Date is invalid.",
                    help: "Choose when the content becomes visible.",
                    isDisabled: true
                )
            )
        )

        #expect(result.contains("admin-date-picker"))
        #expect(result.contains("has-error"))
        #expect(result.contains("aria-invalid=\"true\""))
        #expect(result.contains("aria-errormessage=\"publicationDate-error\""))
        #expect(result.contains("disabled"))
        #expect(result.contains("publicationDate-help"))
        #expect(result.contains("Date is invalid."))
    }

    private func render(
        _ field: AdminFormFieldDateTimePicker
    ) -> String {
        var context = BuilderContext()
        let root = context.build(field)
        return Document(root: root).render()
    }
}
