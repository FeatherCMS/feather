import Application
import Domain
import WebDomain
import WebDomain

public struct RemovePage: UseCase {
    struct Action: PermissionAction {
        let key = WebPermissions.Pages.delete
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WritePageMetadata>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WritePageMetadata>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let id: String

        public init(
            id: String
        ) {
            self.id = id
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> Bool {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let id = input.id

        return try await transaction.run { context in
            let removedPage = try await context.page.delete(id: id)
            _ = try await context.metadata.delete(
                reference: .init(type: "web.page", id: id)
            )
            if removedPage {
                var settings = try await context.settings.get()
                if settings.homePageId == id {
                    try settings.update(
                        logo: settings.logo,
                        logoDark: settings.logoDark,
                        metaImage: settings.metaImage,
                        primaryColor: settings.primaryColor,
                        secondaryColor: settings.secondaryColor,
                        tertiaryColor: settings.tertiaryColor,
                        primaryFont: settings.primaryFont,
                        secondaryFont: settings.secondaryFont,
                        homePageId: nil,
                        locale: settings.locale,
                        timezone: settings.timezone,
                        title: settings.title,
                        excerpt: settings.excerpt,
                        noIndex: settings.noIndex,
                        css: settings.css,
                        js: settings.js
                    )
                    _ = try await context.settings.update(settings)
                }
            }
            return removedPage
        }
    }
}
