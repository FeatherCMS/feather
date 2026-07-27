import Hummingbird
import AdminOpenAPI
import Foundation

struct AdminNewsletter {
    let renderingEngine: any RenderingEngine

    func route(on router: Router<AppRequestContext>) {
        AdminManageNewsletters(renderingEngine: renderingEngine).controller.route(on: router)
        AdminNewsletterIssueList(renderingEngine: renderingEngine).controller.route(on: router)
        AdminManageNewsletterSubscribers(renderingEngine: renderingEngine).controller.route(on: router)
        AdminNewsletterSubscribersDirectory(renderingEngine: renderingEngine).controller.route(on: router)
        AdminAddNewsletterSubscriber(renderingEngine: renderingEngine).controller.route(on: router)
        AdminAddContactNewsletter(renderingEngine: renderingEngine).controller.route(on: router)
        AdminAddContactNewsletterIssue(renderingEngine: renderingEngine).controller.route(on: router)
        router.get("/admin/newsletters/:id/issues/:issueId/edit/", use: getIssueEdit)
        router.post("/admin/newsletters/:id/issues/:issueId/edit/", use: postIssueEdit)
        router.get("/admin/newsletters/:id/issues/:issueId/remove/", use: getIssueRemove)
        router.post("/admin/newsletters/:id/issues/:issueId/remove/", use: postIssueRemove)
        router.post("/admin/newsletters/:id/issues/test-email/", use: postIssueTestEmail)
        router.post("/admin/newsletters/:id/issues/:issueId/test-email/", use: postIssueTestEmail)
    }

    private func getIssueEdit(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let newsletterId = try context.requiredParameter("id")
        let issueId = try context.requiredParameter("issueId")
        let response = try await context.managementAPI().contactNewsletterIssueGet(path: .init(contactNewsletterId: newsletterId, contactNewsletterIssueId: issueId))
        guard case .ok(let value) = response else { return HTMLResponse(content: "Unable to load issue", status: .notFound) }
        let issue = try value.body.json
        return renderIssueForm(request: request, permissions: context.currentUserPermissions, newsletterId: newsletterId, issueId: issueId, subject: issue.subject, content: issue.content, scheduledAt: issue.scheduledAt.map { String(describing: $0) } ?? "", error: nil)
    }

    private func postIssueEdit(request: Request, context: AppRequestContext) async throws -> Response {
        let newsletterId = try context.requiredParameter("id")
        let issueId = try context.requiredParameter("issueId")
        let form = try await request.decode(as: ContactNewsletterIssueAddForm.self, context: context)
        do {
            _ = try await context.managementAPI().contactNewsletterIssueUpdate(path: .init(contactNewsletterId: newsletterId, contactNewsletterIssueId: issueId), body: .json(.init(subject: form.normalizedSubject, content: form.content, scheduledAt: Double(form.scheduledAt))))
            return Response(
                status: .seeOther,
                headers: [
                    .location: AdminToastRedirect.location(
                        defaultPath: "/admin/newsletters/\(newsletterId)/issues/",
                        title: "Updated",
                        message: "Campaign issue updated successfully."
                    )
                ]
            )
        } catch {
            let page = renderIssueForm(request: request, permissions: context.currentUserPermissions, newsletterId: newsletterId, issueId: issueId, subject: form.subject, content: form.content, scheduledAt: form.scheduledAt, error: error.displayMessage)
            return try page.response(from: request, context: context)
        }
    }

    private func getIssueRemove(request: Request, context: AppRequestContext) async throws -> HTMLResponse {
        let newsletterId = try context.requiredParameter("id")
        let issueId = try context.requiredParameter("issueId")
        let breadcrumb = AdminBreadcrumb.State(links: [
            .init(label: "Admin", link: "/admin/"),
            .init(label: "Campaigns", link: "/admin/newsletters/"),
            .init(label: "Issues", link: "/admin/newsletters/\(newsletterId)/issues/")
        ])
        return renderingEngine.renderAdminPage(
            request: request,
            title: "Remove campaign issue - Feather CMS",
            description: "Remove campaign issue",
            imagePath: "images/puppy.png",
            sidebarState: renderingEngine.adminSidebarState(request: request, permissions: context.currentUserPermissions),
            content: AdminConfirmationDialog(state: .init(
                breadcrumb: breadcrumb,
                title: "Remove campaign issue",
                message: "Are you sure you want to remove this issue? This action cannot be undone.",
                submitLabel: "Remove issue",
                actionURL: "/admin/newsletters/\(newsletterId)/issues/\(issueId)/remove/",
                cancelURL: "/admin/newsletters/\(newsletterId)/issues/"
            ))
        )
    }

    private func postIssueRemove(request: Request, context: AppRequestContext) async throws -> Response {
        let newsletterId = try context.requiredParameter("id")
        let issueId = try context.requiredParameter("issueId")
        _ = try await context.managementAPI().contactNewsletterIssueDelete(path: .init(contactNewsletterId: newsletterId, contactNewsletterIssueId: issueId))
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: "/admin/newsletters/\(newsletterId)/issues/", title: "Removed", message: "Campaign issue removed successfully.")])
    }

    private func postIssueTestEmail(request: Request, context: AppRequestContext) async throws -> Response {
        let newsletterId = try context.requiredParameter("id")
        let issueId = context.parameters.get("issueId", as: String.self)
        let form = try await request.decode(as: NewsletterIssueTestEmailForm.self, context: context)
        let body = Components.RequestBodies.ContactNewsletterIssueTestEmailRequestBody.json(.init(email: form.email, subject: form.subject, content: form.content))
        if let issueId {
            _ = try await context.managementAPI().contactNewsletterIssueTestEmail(path: .init(contactNewsletterId: newsletterId, contactNewsletterIssueId: issueId), body: body)
        } else {
            _ = try await context.managementAPI().contactNewsletterTestEmail(path: .init(contactNewsletterId: newsletterId), body: body)
        }
        return Response(status: .seeOther, headers: [.location: AdminToastRedirect.location(defaultPath: issueId.map { "/admin/newsletters/\(newsletterId)/issues/\($0)/edit/" } ?? "/admin/newsletters/\(newsletterId)/issues/add/", title: "Sent", message: "Test email queued successfully.")])
    }

    private func renderIssueForm(request: Request, permissions: Set<String>, newsletterId: String, issueId: String?, subject: String, content: String, scheduledAt: String, error: String?) -> HTMLResponse {
        let breadcrumb = AdminBreadcrumb.State(links: [.init(label: "Admin", link: "/admin/"), .init(label: "Campaigns", link: "/admin/newsletters/"), .init(label: "Issues", link: "/admin/newsletters/\(newsletterId)/issues/")])
        return renderingEngine.renderAdminPage(request: request, title: "Edit campaign issue - Feather CMS", description: "Edit campaign issue", imagePath: "images/puppy.png", sidebarState: renderingEngine.adminSidebarState(request: request, permissions: permissions), content: ContactNewsletterIssueAddView(state: .init(subject: subject, content: content, scheduledAt: scheduledAt, newsletterId: newsletterId, issueId: issueId, error: error, breadcrumb: breadcrumb)))
    }
}
