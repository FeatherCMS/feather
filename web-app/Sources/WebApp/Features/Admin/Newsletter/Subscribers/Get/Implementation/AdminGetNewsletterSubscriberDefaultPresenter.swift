import Hummingbird

struct AdminGetNewsletterSubscriberDefaultPresenter:
    AdminGetNewsletterSubscriberPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        model: AdminGetNewsletterSubscriberModel,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Subscriber - Feather CMS",
            description: "View subscriber",
            imagePath: "images/puppy.png",
            sidebarState: renderEngine.adminSidebarState(
                request: request,
                permissions: permissions
            ),
            content: NewsletterSubscriberFormView(
                state: .init(
                    newsletterId: model.newsletterId,
                    email: model.item.email,
                    firstName: model.item.firstName,
                    lastName: model.item.lastName,
                    status: model.item.status,
                    isEdit: true,
                    error: nil,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Campaigns", link: "/admin/newsletters/"),
                        .init(label: "Subscriber", link: ""),
                    ]),
                    editAction:
                        "/admin/newsletters/subscribers/\(model.item.id)/edit/?campaignId=\(model.newsletterId)"
                )
            )
        )
    }

    func render(
        subscriberId: String,
        newsletterId: String,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        render(
            model: .init(
                newsletterId: newsletterId,
                item: .init(
                    id: subscriberId,
                    email: "",
                    firstName: "",
                    lastName: "",
                    status: "subscribed"
                )
            ),
            permissions: permissions
        )
    }
}
