import FeatherWebAdmin
public import FeatherModuleKit
import OpenAPIRuntime
import RedirectAdminAPI
import SystemModule
import SystemWebAdmin

extension Event {
    public enum Handlers {
        public static func register(
            in events: inout EventRegistry,
            environment: AppEnvironment,
            routes: Router.Routes = .standard
        ) {
            registerMenu(in: &events, routes: routes.rule)
            registerDashboard(in: &events, environment: environment)
        }

        private static func registerMenu(
            in events: inout EventRegistry,
            routes: RedirectModule.Rule.Router.Routes
        ) {
            events.register(
                event: SystemWebAdmin.Admin.Menu.Group.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { _, _ in
                [
                    .init(
                        key: "redirect",
                        groupKey: "admin",
                        label: "Redirect",
                        icon: "gitBranch",
                        priority: 80
                    )
                ]
            }
            events.register(
                event: SystemWebAdmin.Admin.Menu.Item.Provider.self,
                context: SystemWebAdmin.Admin.Menu.Context.self
            ) { event, _ in
                guard event.menuKey == "redirect" else { return [] }
                return [
                    .init(
                        menuKey: "redirect",
                        label: "Rules",
                        icon: "cornerUpRight",
                        link: routes.list.path,
                        permission: "redirect:rules:list"
                    )
                ]
            }
        }

        private static func registerDashboard(
            in events: inout EventRegistry,
            environment: AppEnvironment
        ) {
            events.register(
                event: SystemWebAdmin.Dashboard.Event.Provider.self,
                context: SystemWebAdmin.Dashboard.Event.Context.self
            ) { _, context in
                let api = API.Client(
                    environment: environment,
                    requestContext: context.requestContext
                )
                guard
                    context.requestContext.currentUserPermissions.contains(
                        "redirect:rules:list"
                    )
                else {
                    return [
                        .init(
                            contentStats: [],
                            dailyTraffic: nil,
                            topPages: nil,
                            insightCards: []
                        )
                    ]
                }

                let count = try? await api.withOpenAPIRepositoryErrorMapping {
                    client in
                    let response = try await client.redirectRuleQuery(
                        headers: .init(accept: [.init(contentType: .json)]),
                        body: .json(
                            .init(
                                page: .init(size: 1, number: 1),
                                filters: .init(search: nil, statusCode: nil)
                            )
                        )
                    )
                    switch response {
                    case .ok(let value): return try value.body.json.data.total
                    case .unauthorized:
                        throw OpenAPIRepositoryError.unauthorized
                    case .forbidden:
                        throw OpenAPIRepositoryError.forbidden
                    case .undocumented(let statusCode, let response):
                        throw try await api.failure(
                            statusCode: statusCode,
                            responseBody: response.body
                        )
                    }
                }
                return [
                    .init(
                        contentStats: count.map {
                            [.init(label: "Redirect rules", value: "\($0)")]
                        } ?? [],
                        dailyTraffic: nil,
                        topPages: nil,
                        insightCards: []
                    )
                ]
            }
        }
    }
}
