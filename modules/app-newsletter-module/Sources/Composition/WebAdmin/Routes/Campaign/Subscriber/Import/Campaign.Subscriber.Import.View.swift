import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Campaign.Subscriber.Import {
    struct View: Component {
        struct State {
            let newsletterId: String
            let error: String?
            let routes: Campaign.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            Section {
                context.build(
                    AdminBreadcrumb(
                        links: state.routes.campaignBreadcrumb + [
                            .init(
                                label: "Subscribers",
                                link: state.routes.subscribersPath(
                                    newsletterId: state.newsletterId
                                )
                            )
                        ]
                    )
                )
                context.build(
                    AdminPageHeader(
                        state: .primary(
                            title: "Import subscribers",
                            description:
                                "Add a CSV email list to this campaign."
                        )
                    )
                )
                context.build(
                    Campaign.Tabs(
                        id: state.newsletterId,
                        active: .subscribers,
                        routes: state.routes
                    )
                )
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "CSV file",
                            description:
                                "Use a UTF-8 CSV with an email header. Optional columns are first_name, last_name, and status."
                        )
                    ) {
                        let form = AdminForm(
                            action: state.routes.subscriberImportPath(
                                newsletterId: state.newsletterId
                            ),
                            hiddenFields: [.init(name: "csv", value: "")]
                        ) {
                            if let error = state.error {
                                P(error).class("admin-form__error")
                            }
                            Div {
                                Label("CSV file").for("newsletterSubscriberCSV")
                                Input()
                                    .type(.file)
                                    .id("newsletterSubscriberCSV")
                                    .setAttribute(
                                        name: "accept",
                                        value: ".csv,text/csv"
                                    )
                                    .setAttribute(
                                        name: "aria-label",
                                        value: "CSV file"
                                    )
                            }
                            P(
                                "Files can be up to 5 MB and 5,000 data rows. Quoted fields, commas, escaped double quotes, and line breaks inside quoted values are supported. Empty rows and repeated or already-imported email addresses are skipped."
                            )
                            .class("admin-form__help")
                            Div {
                                context.build(
                                    AdminSubmitButton("Import subscribers")
                                )
                                context.build(
                                    AdminButton(
                                        "Cancel",
                                        href: state.routes.subscribersPath(
                                            newsletterId: state.newsletterId
                                        ),
                                        style: .secondary
                                    )
                                )
                            }
                            .class("admin-form__actions")
                        }
                        context.build(form)
                    }
                )
            }
            .class("cms-section")
        }

        func scripts() -> [String] {
            [
                #"""
                (function () {
                    var fileInput = document.getElementById(
                        "newsletterSubscriberCSV"
                    );
                    var form = fileInput && fileInput.closest("form");
                    if (!form) { return; }
                    var csvInput = form.querySelector('input[name="csv"]');
                    if (!fileInput || !csvInput) { return; }
                    form.addEventListener("submit", function (event) {
                        if (!fileInput.files || !fileInput.files.length) {
                            event.preventDefault();
                            window.alert("Choose a CSV file to import.");
                            return;
                        }
                        event.preventDefault();
                        if (fileInput.files[0].size > 5000000) {
                            window.alert("CSV files must be 5 MB or smaller.");
                            return;
                        }
                        var reader = new FileReader();
                        reader.onload = function () {
                            try {
                                csvInput.value = new TextDecoder("utf-8", {
                                    fatal: true
                                }).decode(reader.result);
                                form.submit();
                            } catch (error) {
                                window.alert(
                                    "The selected CSV file must use valid UTF-8 text."
                                );
                            }
                        };
                        reader.onerror = function () {
                            window.alert("The selected CSV file could not be read.");
                        };
                        reader.readAsArrayBuffer(fileInput.files[0]);
                    });
                }());
                """#
            ]
        }
    }
}
