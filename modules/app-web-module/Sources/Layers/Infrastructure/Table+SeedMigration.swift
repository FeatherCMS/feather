import FeatherDBAL
public import FeatherDatabase
public import FeatherInfrastructure
public import FeatherModuleKit
import WebDomain
import WebModule

public struct TableSeedMigration: DatabaseMigration {
    public let context: DatabaseTransactionContext
    private let events: any EventPublisher

    public var connection: any DatabaseConnection {
        context.connection
    }

    public init(
        context: DatabaseTransactionContext,
        events: any EventPublisher
    ) {
        self.context = context
        self.events = events
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let pageRepository = Page.Repository.Database(context: context)
        let definitions = try await events.trigger(
            event: PageProvider(),
            using: WebModule.Event.Context()
        )
        for definition in definitions.flatMap({ $0 }) {
            let page = try Page.Model.create(
                title: definition.title,
                excerpt: definition.excerpt,
                content: definition.content,
                imageAssetId: definition.imageAssetId,
                metadata: definition.metadata.map {
                    .init(
                        template: $0.template,
                        slug: $0.slug,
                        publicationDate: $0.publicationDate,
                        expirationDate: $0.expirationDate,
                        status: .init(rawValue: $0.status.rawValue)
                            ?? .draft,
                        title: $0.title,
                        excerpt: $0.excerpt,
                        imageURL: $0.imageURL,
                        canonicalURL: $0.canonicalURL,
                        noIndex: $0.noIndex,
                        primaryKeyword: $0.primaryKeyword,
                        cssCodeInjection: $0.cssCodeInjection,
                        javascriptCodeInjection: $0.javascriptCodeInjection,
                        structuredDataCodeInjection: $0
                            .structuredDataCodeInjection
                    )
                }
                    ?? .init(
                        template: "default",
                        slug: definition.title.slugified,
                        status: .published
                    )
            )
            _ = try await pageRepository.insert(page)
        }
        try await installWebMenuExtensions(
            events: events
        )
    }

    private func installWebMenuExtensions(
        events: any EventPublisher
    ) async throws {
        let menus =
            try await events.trigger(
                event: MenuProvider(),
                using: WebModule.Event.Context()
            )
            .flatMap { $0 }

        let menuRepository = Menu.Repository.Database(context: context)
        let menuItemRepository = MenuItem.Repository.Database(context: context)

        for menu in menus {
            let items =
                try await events.trigger(
                    event: MenuItemProvider(menuKey: menu.key),
                    using: WebModule.Event.Context()
                )
                .flatMap { $0 }

            let savedMenu = try await menuRepository.insert(
                Menu.Model.create(
                    key: menu.key,
                    name: menu.name,
                    notes: menu.notes
                )
            )
            for item in items {
                _ = try await menuItemRepository.insert(
                    MenuItem.Model.create(
                        menuId: savedMenu.id,
                        label: item.label,
                        url: item.url,
                        priority: item.priority,
                        isBlank: item.isBlank,
                        permission: item.permission,
                        authentication: .init(
                            rawValue: item.authentication.rawValue
                        ) ?? .any,
                        notes: item.notes
                    )
                )
            }
        }
    }

}
