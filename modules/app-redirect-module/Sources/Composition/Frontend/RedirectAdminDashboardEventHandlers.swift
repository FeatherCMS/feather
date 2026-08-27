import FeatherAdmin
import FeatherContracts
import Foundation
import OpenAPIRuntime
import RedirectAdminAPI
import SystemFrontend

public enum RedirectAdminDashboardEventHandlers {
    public static func register(in events: inout EventRegistry) {
        events.register(
            event: AdminHomeOverviewProvider.self,
            context: AdminDashboardEventContext.self
        ) { _, context in
            let api = RedirectAdminAPIClient(
                apiBaseURL: context.apiBaseURL,
                sessionToken: context.sessionToken
            )
            guard context.permissions.contains("redirect:rules:list") else {
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
                let response = try await client.redirectRuleSearch(
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
                    throw OpenAPIRepositoryError.unauthorized(
                        message: unauthorizedMessage
                    )
                case .forbidden:
                    throw OpenAPIRepositoryError.forbidden(
                        message: forbiddenMessage
                    )
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

    private static var unauthorizedMessage: String {
        "Please sign in again to load the admin dashboard."
    }
    private static var forbiddenMessage: String {
        "Your account cannot access the admin dashboard."
    }
}
