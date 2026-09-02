import FeatherApplication
import FeatherContracts
import FeatherDomain
import WebContracts
import WebDomain

//
//  RemovePage.swift
//  app-web-module
//
//  Created by Binary Birds on 2026. 06. 18.

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
        public let ids: [String]

        public init(ids: [String]) { self.ids = ids }
    }

    public func execute(
        subject: Subject,
        input: Input
    ) async throws -> [String] {
        let action = Action()

        guard try await authorizer.can(subject: subject, perform: action) else {
            throw AuthError(kind: .forbidden, message: action.key.rawValue)
        }

        return try await transaction.run { scope in
            let removedPage = try await scope.page.delete(ids: input.ids)
            for id in input.ids {
                _ = try await scope.metadata.delete(
                    reference: .existing(.init(type: "web.page", id: id))
                )
            }
            let id = input.ids.first
            if let id, removedPage.contains(id) {
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
            return removedPage
        }
    }
}
