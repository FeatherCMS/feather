public import FeatherApplication
public import FeatherModuleKit
import WebDomain
public import WebModule

extension Settings.Edit {
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

            let model = try await transaction.run { scope in
                var model = try await scope.settings.get()
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
                return try await scope.settings.update(model)
            }
            return .init(model: model)
        }
    }
}
