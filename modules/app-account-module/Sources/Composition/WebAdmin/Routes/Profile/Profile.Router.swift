import AccountModule
import FeatherWebAdmin
import FeatherWebShared
import Foundation
import Hummingbird

extension Profile {
    struct Router {
        struct Routes: Sendable {
            let profile: WebRoute
            let profileEdit: WebRoute
            let mediaAssetList: WebRoute
            let profileBreadcrumb: [AdminBreadcrumb.Link]

            init(root: WebRoute, mediaAssetList: WebRoute) {
                let account = root.appending(pathComponent: "account")
                let profile = account.appending(pathComponent: "profile")
                self.profile = profile
                self.profileEdit = profile.appending(pathComponent: "edit")
                self.mediaAssetList = mediaAssetList
                self.profileBreadcrumb = [
                    .init(label: "Admin", link: root.path),
                    .init(label: "Account", link: account.path),
                    .init(label: "Profile", link: profile.path),
                ]
            }

            func profileImagePickerPath(_ field: String) -> String {
                var components = URLComponents()
                components.path = mediaAssetList.path
                components.queryItems = [
                    URLQueryItem(name: "picker", value: "1"),
                    URLQueryItem(name: "field", value: field),
                    URLQueryItem(
                        name: "extensions",
                        value: AllowedExtensions.images.queryValue
                    ),
                ]
                return components.string ?? components.path
            }

        }

        let routes: Routes
        private let environment: AppEnvironment
        private let renderingEngine: any RenderingEngine

        init(
            environment: AppEnvironment,
            renderingEngine: any RenderingEngine,
            routes: Routes
        ) {
            self.environment = environment
            self.renderingEngine = renderingEngine
            self.routes = routes
        }

        func route(on router: any RouterMethods<AuthenticatedRequestContext>) {
            Detail.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
            Edit.Router(
                environment: environment,
                renderingEngine: renderingEngine,
                routes: routes
            )
            .route(on: router)
        }
    }
}
