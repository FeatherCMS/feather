import Application
import Domain
import WebDomain

public struct EditSettings: UseCase {

    struct Action: PermissionAction {
        let key = WebPermissions.Settings.update
    }

    let authorizer: any Authorizer
    let transaction: any TransactionExecutor<WriteSettings>

    public init(
        authorizer: any Authorizer,
        transaction: any TransactionExecutor<WriteSettings>
    ) {
        self.authorizer = authorizer
        self.transaction = transaction
    }

    public struct Input: DTO {
        public let logo: String
        public let logoDark: String
        public let metaImage: String
        public let primaryColor: String
        public let secondaryColor: String
        public let tertiaryColor: String
        public let primaryFont: String
        public let secondaryFont: String
        public let homePageId: String?
        public let locale: String
        public let timezone: String
        public let title: String
        public let excerpt: String
        public let noIndex: Bool
        public let css: String
        public let js: String

        public init(
            logo: String,
            logoDark: String,
            metaImage: String,
            primaryColor: String,
            secondaryColor: String,
            tertiaryColor: String,
            primaryFont: String,
            secondaryFont: String,
            homePageId: String?,
            locale: String,
            timezone: String,
            title: String,
            excerpt: String,
            noIndex: Bool,
            css: String,
            js: String
        ) {
            self.logo = logo
            self.logoDark = logoDark
            self.metaImage = metaImage
            self.primaryColor = primaryColor
            self.secondaryColor = secondaryColor
            self.tertiaryColor = tertiaryColor
            self.primaryFont = primaryFont
            self.secondaryFont = secondaryFont
            self.homePageId = homePageId
            self.locale = locale
            self.timezone = timezone
            self.title = title
            self.excerpt = excerpt
            self.noIndex = noIndex
            self.css = css
            self.js = js
        }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> SettingsDetail {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        let model = try await transaction.run { context in
            var model = try await context.settings.get()
            try model.update(
                logo: input.logo,
                logoDark: input.logoDark,
                metaImage: input.metaImage,
                primaryColor: input.primaryColor,
                secondaryColor: input.secondaryColor,
                tertiaryColor: input.tertiaryColor,
                primaryFont: input.primaryFont,
                secondaryFont: input.secondaryFont,
                homePageId: input.homePageId,
                locale: input.locale,
                timezone: input.timezone,
                title: input.title,
                excerpt: input.excerpt,
                noIndex: input.noIndex,
                css: input.css,
                js: input.js
            )
            return try await context.settings.update(model)
        }
        return model.asDetail
    }
}
