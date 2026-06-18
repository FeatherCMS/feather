import HTML
import SGML
import WebStandards

struct AdminStatusSelectField: Component, FlowContent {
    let formID: String
    let selectedStatus: String
    let options: [String]

    init(
        formID: String,
        selectedStatus: String,
        options: [String] = ["draft", "published", "archived"]
    ) {
        self.formID = formID
        self.selectedStatus = selectedStatus
        self.options = options
    }

    func content() -> some BasicTag {
        Select {
            for option in options {
                Option(option.capitalized)
                    .value(option)
                    .if(option == selectedStatus) {
                        $0.selected()
                    }
            }
        }
        .name("status")
        .setAttribute(name: "form", value: formID)
        .setAttribute(
            name: "onchange",
            value: "document.getElementById('\(formID)').requestSubmit();"
        )
        .class("table-status-select")
        .style(
            """
            min-height:32px;
            min-width:6.75rem;
            padding:0.45rem 2rem 0.45rem 0.6rem;
            font-size:0.875rem;
            line-height:1.2;
            box-shadow:none;
            vertical-align:middle;
            """
        )
    }
}
