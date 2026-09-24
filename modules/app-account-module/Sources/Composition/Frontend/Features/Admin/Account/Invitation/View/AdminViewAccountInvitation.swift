import FeatherAdmin
import OpenAPIRuntime
import UserAdminAPI
import UserFrontend

struct AdminViewAccountInvitation {
    let controller: any AdminViewAccountInvitationController

    init(
        apiBuilder: AccountAPIBuilder,
        renderingEngine: any RenderingEngine
    ) {
        self.controller = AdminViewAccountInvitationDefaultController(
            buildRuntime: { request, context in
                (
                    interactor: AdminViewAccountInvitationDefaultInteractor(
                        repository: AccountInvitationOpenAPIRepository(
                            api: apiBuilder.makeAccountAdmin(context)
                        ),
                        roleNamesProvider: { roleIDs in
                            let userAPI = apiBuilder.makeUserAdmin(context)
                            guard
                                let response =
                                    try? await userAPI
                                    .withOpenAPIRepositoryErrorMapping({
                                        client in
                                        try await client.userRoleSearch(
                                            headers: .init(accept: [
                                                .init(contentType: .json)
                                            ]),
                                            body: .json(
                                                .init(
                                                    page: .init(
                                                        size: 100,
                                                        number: 1
                                                    ),
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
                    ),
                    presenter: AdminViewAccountInvitationDefaultPresenter(
                        request: request,
                        context: context,
                        renderingEngine: renderingEngine
                    ),
                )
            }
        )
    }
}
