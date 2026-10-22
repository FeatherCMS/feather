public import FeatherApplication
public import FeatherModuleKit
public import WebDomain

extension Page.Remove {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let transaction: any TransactionExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            transaction: any TransactionExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.transaction = transaction
        }

        public func execute(subject: Subject, input: Input) async throws
            -> Output
        {
            let action = Action()
            guard try await authorizer.can(subject: subject, perform: action)
            else {
                throw AuthError(kind: .forbidden, message: action.key.rawValue)
            }
            let ids = try await transaction.run { scope in
                let removed = try await scope.page.delete(ids: input.ids)
                _ = try await scope.metadata.delete(
                    referenceType: "web.page",
                    referenceIds: input.ids
                )
                if let id = input.ids.first, removed.contains(id) {
                    var settings = try await scope.settings.get()
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
                        _ = try await scope.settings.update(settings)
                    }
                }
                return removed
            }
            return .init(ids: ids)
        }
    }
}
