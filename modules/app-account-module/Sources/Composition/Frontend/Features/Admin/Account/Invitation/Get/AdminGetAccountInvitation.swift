import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import UserAdminAPI
import UserFrontend

struct AdminGetAccountInvitation {
    let controller: any AdminGetAccountInvitationController

    init(renderingEngine: any RenderingEngine) {
        self.controller = AdminGetAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminGetAccountInvitationDefaultInteractor(
                        repository: AccountInvitationOpenAPIRepository(
                            api: context.accountAdminAPI()
                        )
                    ),
                    presenter: AdminGetAccountInvitationDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    ),
                    roleNames: { roleIDs in
                        let userAPI = UserAdminAPIClient(
                            apiBaseURL: AppEnvironmentStore.current.apiBaseURL,
                            sessionToken: context.sessionToken
                        )
                        guard let response = try? await userAPI
                            .withOpenAPIRepositoryErrorMapping({ client in
                                try await client.userRoleSearch(
                                    headers: .init(
                                        accept: [.init(contentType: .json)]
                                    ),
                                    body: .json(
                                        .init(
                                            page: .init(size: 100, number: 1),
                                            filters: .init(search: nil)
                                        )
                                    )
                                )
                            }),
                            case .ok(let value) = response,
                            let body = try? value.body.json
                        else { return roleIDs }
                        let namesByID = Dictionary(
                            uniqueKeysWithValues: body.data.items.map {
                                ($0.id, $0.name ?? $0.id)
                            }
                        )
                        return roleIDs.map { namesByID[$0] ?? $0 }
                    }
                )
            }
        )
    }
}
