import Hummingbird

struct AdminEditNewsletterSubscriberDefaultPresenter:
    AdminEditNewsletterSubscriberPresenter
{
    let request: Request
    let renderEngine: any RenderingEngine

    func render(
        model: AdminGetNewsletterSubscriberModel,
        error: String?,
        permissions: Set<String>
    ) -> HTMLResponse {
        renderEngine.renderAdminPage(
            request: request,
            title: "Edit subscriber - Feather CMS",
            description: "Edit subscriber",
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
                    error: error,
                    breadcrumb: .init(links: [
                        .init(label: "Admin", link: "/admin/"),
                        .init(label: "Campaigns", link: "/admin/newsletters/"),
                        .init(
                            label: "Subscribers",
                            link: "/admin/newsletters/subscribers/"
                        ),
                    ]),
                    editAction:
                        "/admin/newsletters/subscribers/\(model.item.id)/edit/?campaignId=\(model.newsletterId)"
                )
            )
        )
    }
}
