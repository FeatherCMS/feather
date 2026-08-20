import FeatherApplication
import FeatherContracts
import FeatherDatabase
import FeatherDomain
import FeatherInfrastructure
import SystemApplication
import WebApplication
import WebDomain
import WebContracts

public struct TableSeedMigration: DatabaseMigration {
    public let connection: any DatabaseConnection
    private let idGenerator: any IDGenerator
    private let events: (any EventPublisher)?

    public var id: String {
        "WebInfrastructure.TableSeedMigration.v9"
    }

    public init(
        connection: any DatabaseConnection,
        idGenerator: any IDGenerator,
        events: (any EventPublisher)? = nil
    ) {
        self.connection = connection
        self.idGenerator = idGenerator
        self.events = events
    }

    public func apply(
        on connection: any DatabaseConnection
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        if let events {
            let pageRepository = PageDatabaseRepository(context: context)
            let definitions = try await events.trigger(
                event: WebPageProvider(),
                using: WebEventContext()
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
                            slug: definition.title.slugify(),
                            status: .published
                        )
                )
                _ = try await pageRepository.insert(page)
            }
            try await installWebMenuExtensions(
                on: connection,
                events: events
            )
        }
    }

    private func installWebMenuExtensions(
        on connection: any DatabaseConnection,
        events: any EventPublisher
    ) async throws {
        let context = DatabaseTransactionContext(
            connection: connection,
            idGenerator: idGenerator
        )
        let menus =
            try await events.trigger(
                event: WebMenuProvider(),
                using: WebEventContext()
            )
            .flatMap { $0 }

        let menuRepository = MenuDatabaseRepository(context: context)
        let menuItemRepository = MenuItemDatabaseRepository(context: context)

        for menu in menus {
            let items =
                try await events.trigger(
                    event: WebMenuItemProvider(menuKey: menu.key),
                    using: WebEventContext()
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
