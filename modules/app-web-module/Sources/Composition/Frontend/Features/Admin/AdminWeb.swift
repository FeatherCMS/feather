import FeatherAdmin
import Hummingbird
import OpenAPIRuntime
import WebContracts

public struct AdminWeb {
    public let renderingEngine: any RenderingEngine
    public let referenceTypeOptions: [WebMetadataReferenceTypeOption]
    public let templateOptions: [WebPageTemplateOption]

    public init(
        renderingEngine: any RenderingEngine,
        referenceTypeOptions: [WebMetadataReferenceTypeOption] = [],
        templateOptions: [WebPageTemplateOption] = []
    ) {
        self.renderingEngine = renderingEngine
        self.referenceTypeOptions = referenceTypeOptions
        self.templateOptions = templateOptions
    }

    public func route(
        on router: Router<DefaultRequestContext>
    ) {
        AdminGetWebHome(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebSettings(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminWebPageMetadataRoutes.register(
            router: router,
            renderingEngine: renderingEngine,
            templateOptions: templateOptions
        )

        AdminRemoveWebPage(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebMetadata(
            renderingEngine: renderingEngine,
            referenceTypeOptions: referenceTypeOptions
        )
        .controller.route(on: router)

        AdminGetWebMetadata(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebMetadata(
            renderingEngine: renderingEngine,
            templateOptions: templateOptions
        )
        .controller.route(on: router)

        AdminListWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveWebMenu(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminListWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminGetWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminAddWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminEditWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)

        AdminRemoveWebMenuItem(
            renderingEngine: renderingEngine
        )
        .controller.route(on: router)
    }
}
