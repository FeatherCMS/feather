import FeatherWebAdmin
import HTML
import NewsletterApplication
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Issue.TestEmail {
    struct Dialog: Component {
        let newsletterId: String
        let issueId: String?
        let routes: Campaign.Router.Routes

        func html(context: inout BuilderContext) -> some BasicTag {
            let action =
                issueId.map {
                    routes.issueDetailTestEmailPath(
                        newsletterId: newsletterId,
                        issueId: $0
                    )
                } ?? routes.issueTestEmailPath(newsletterId: newsletterId)

            return Div {
                context.build(
                    AdminForm(
                        action: action,
                        hiddenFields: [
                            .init(name: "subject", value: ""),
                            .init(name: "content", value: ""),
                        ]
                    ) {
                        context.build(
                            AdminFormFieldInput(
                                state: .init(
                                    name: "email",
                                    label: "Test email address",
                                    type: .email,
                                    isRequired: true
                                )
                            )
                        )
                        Div {
                            context.build(AdminSubmitButton("Send"))
                        }
                        .class("admin-form__actions")
                    }
                )
                Script(
                    """
                        (function () {
                            var dialog = document.querySelector('dialog[data-admin-dialog]');
                            if (!dialog) return;
                            var forms = Array.from(document.querySelectorAll('form.admin-form'));
                            var issueForm = forms.find(function (form) {
                                return !form.closest('dialog');
                            });
                            if (!issueForm) return;
                            var subject = issueForm.querySelector('[name="subject"]');
                            var content = issueForm.querySelector('[name="content"]');
                            var testSubject = dialog.querySelector('[name="subject"]');
                            var testContent = dialog.querySelector('[name="content"]');
                            if (subject && testSubject) testSubject.value = subject.value;
                            if (content && testContent) testContent.value = content.value;
                        }());
                    """
                )
            }
        }
    }
}
