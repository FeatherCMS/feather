import FeatherAdmin
import Foundation
import Hummingbird
import WebContracts

public struct AdminWebMetadataEditHandler: Sendable {
    private let controller: AdminEditWebMetadataDefaultController

    public init(
        renderingEngine: any RenderingEngine,
        templateOptions: [WebPageTemplateOption] = []
    ) {
        controller = AdminEditWebMetadataDefaultController(
            templateOptions: templateOptions,
            buildRuntime: { request, context in
                (
                    interactor: AdminEditWebMetadataDefaultInteractor(
                        repository: AdminEditWebMetadataOpenAPIRepository(
                            api: context.webManagementAPI()
                        )
                    ),
                    presenter: AdminEditWebMetadataDefaultPresenter(
                        request: request,
                        renderingEngine: renderingEngine
                    )
                )
            }
        )
    }

    public func get(
        request: Request,
        context: AppRequestContext,
        referenceType: String,
        navigationTabs: [AdminPillTabs.Link] = [],
        configuration: AdminWebMetadataEditConfiguration? = nil
    ) async throws -> HTMLResponse {
        let tabs =
            navigationTabs.isEmpty
            ? defaultNavigationTabs(request: request)
            : navigationTabs
        return try await controller.getEditWebMetadataForContent(
            request: request,
            context: context,
            referenceType: referenceType,
            navigationTabs: tabs,
            configuration: configuration
        )
    }

    public func post(
        request: Request,
        context: AppRequestContext,
        referenceType: String,
        navigationTabs: [AdminPillTabs.Link] = [],
        configuration: AdminWebMetadataEditConfiguration? = nil
    ) async throws -> Response {
        let tabs =
            navigationTabs.isEmpty
            ? defaultNavigationTabs(request: request)
            : navigationTabs
        return try await controller.postEditWebMetadataForContent(
            request: request,
            context: context,
            referenceType: referenceType,
            navigationTabs: tabs,
            configuration: configuration
        )
    }

    private func defaultNavigationTabs(
        request: Request
    ) -> [AdminPillTabs.Link] {
        let path = request.uri.path
        guard let marker = path.range(of: "/edit/metadata/") else {
            return []
        }
        let detailsPath = String(path[..<marker.lowerBound]) + "/edit/"
        return [
            .init(label: "Details", href: detailsPath, isCurrent: false),
            .init(label: "Metadata", href: path, isCurrent: true),
        ]
    }
}
