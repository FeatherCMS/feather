import FeatherWebAdmin
import FeatherWebShared
import HTML
import Hummingbird
import NewsletterModule
import SGML
import WebBuilders
import WebComponents

extension Campaign.Subscriber.Form {
    struct Component: WebComponents.Component {
        struct State {
            let newsletterId: String
            let email: String
            let firstName: String
            let lastName: String
            let status: String
            let isEdit: Bool
            let error: String?
            let editAction: String?
            let pageHeader: AdminPageHeader.State
            let routes: Campaign.Router.Routes
        }

        let state: State

        func html(context: inout BuilderContext) -> some BasicTag {
            let action =
                state.editAction
                ?? (state.isEdit
                    ? state.routes.subscriberEditPath(
                        newsletterId: state.newsletterId,
                        subscriberId: state.email
                    )
                    : state.routes.subscriberAddPath(
                        newsletterId: state.newsletterId
                    ))
            return Section {
                context.build(
                    AdminBreadcrumb(
                        links: state.routes.campaignBreadcrumb
                    )
                )
                context.build(AdminPageHeader(state: state.pageHeader))
                context.build(
                    Campaign.Tabs(
                        id: state.newsletterId,
                        active: .subscribers,
                        routes: state.routes
                    )
                )
                let form = AdminForm(action: action) {
                    if let error = state.error {
                        P(error).class("admin-form__error")
                    }
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: "email",
                                label: "Email",
                                value: state.email,
                                type: .email,
                                isRequired: true,
                                isReadOnly: state.isEdit
                            )
                        )
                    )
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: "firstName",
                                label: "First name",
                                value: state.firstName
                            )
                        )
                    )
                    context.build(
                        AdminFormFieldInput(
                            state: .init(
                                name: "lastName",
                                label: "Last name",
                                value: state.lastName
                            )
                        )
                    )
                    context.build(
                        AdminFormFieldSelect(
                            state: .init(
                                name: "status",
                                label: "Status",
                                value: state.status,
                                options: [
                                    .init(
                                        label: "Subscribed",
                                        value: "subscribed"
                                    ),
                                    .init(
                                        label: "Unsubscribed",
                                        value: "unsubscribed"
                                    ),
                                ],
                                isRequired: true
                            )
                        )
                    )
                    Div {
                        context.build(
                            AdminSubmitButton(
                                state.isEdit
                                    ? "Save subscriber" : "Add subscriber",
                                style: .primary
                            )
                        )
                    }
                    .class("admin-form__actions")
                }
                context.build(
                    AdminRelationshipGroup(
                        pageHeader: .secondary(
                            title: "Subscriber details",
                            description:
                                "Manage this subscriber’s information and campaign status."
                        )
                    ) {
                        context.build(form)
                    }
                )
            }
            .class("cms-section")
        }
    }
}
