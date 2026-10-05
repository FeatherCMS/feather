public import FeatherContracts
public import FeatherDatabase
public import FeatherInfrastructure
import WebContracts
import WebDomain

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
        let pageRepository = PageDatabaseRepository(context: context)
        let definitions = try await events.trigger(
            event: WebPageProvider(),
            using: WebSeedEventContext()
        )
        for definition in definitions.flatMap({ $0 }) {
            let page = try Page.create(
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
                event: WebMenuProvider(),
                using: WebSeedEventContext()
            )
            .flatMap { $0 }

        let menuRepository = MenuDatabaseRepository(context: context)
        let menuItemRepository = MenuItemDatabaseRepository(context: context)

        for menu in menus {
            let items =
                try await events.trigger(
                    event: WebMenuItemProvider(menuKey: menu.key),
                    using: WebSeedEventContext()
                )
                .flatMap { $0 }

            let savedMenu = try await menuRepository.insert(
                Menu.create(
                    key: menu.key,
                    name: menu.name,
                    notes: menu.notes
                )
            )
            for item in items {
                _ = try await menuItemRepository.insert(
                    MenuItem.create(
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
