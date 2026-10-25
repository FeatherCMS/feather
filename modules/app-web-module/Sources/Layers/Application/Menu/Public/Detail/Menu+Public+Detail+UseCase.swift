public import FeatherApplication
public import FeatherModuleKit
public import WebModule
import WebDomain

extension Menu.Public.Detail {
    public struct UseCase: FeatherApplication.UseCase {
        let authorizer: any Authorizer
        let query: any QueryExecutor<Scope>

        public init(
            authorizer: any Authorizer,
            query: any QueryExecutor<Scope>
        ) {
            self.authorizer = authorizer
            self.query = query
        }

        public func execute(
            subject: Subject?,
            input: Input
        ) async throws -> Output? {
            try await query.run { scope in
                guard let menu = try await scope.query.findMenu(key: input.key)
                else {
                    return nil
                }

                let items = try await scope.query.listMenuItems(
                    menuId: menu.id
                )
                var outputItems: [Output.Item] = []
                for item in items
                where try await isAvailable(item, subject: subject) {
                    outputItems.append(
                        .init(
                            id: item.id,
                            label: item.label,
                            url: item.url,
                            priority: item.priority,
                            isBlank: item.isBlank
                        )
                    )
                }

                return .init(
                    id: menu.id,
                    key: menu.key,
                    name: menu.name,
                    items: outputItems
                )
            }
        }

        private func isAvailable(
            _ item: Query.Item,
            subject: Subject?
        ) async throws -> Bool {
            switch item.authentication {
            case .any:
                break
            case .anonymous:
                guard subject == nil else { return false }
            case .authenticated:
                guard subject != nil else { return false }
            }

            guard !item.permission.isEmpty else { return true }
            guard let subject else { return false }
            return try await authorizer.can(
                subject: subject,
                perform: Action(key: .init(item.permission))
            )
        }
    }
}
