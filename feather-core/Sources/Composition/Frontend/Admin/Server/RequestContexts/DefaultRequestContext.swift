//
//  File.swift
//  web-app
//
//  Created by Tibor Bödecs on 2026. 03. 01..
//

import FeatherContracts
public import Hummingbird
import OpenAPIRuntime

public struct DefaultRequestContext: RequestParameterProviding, Sendable {

    public var coreContext: CoreRequestContextStorage

    public var sessionToken: String?
    public var account: AccountModel?
    public init(
        source: ApplicationRequestContextSource,
    ) {
        self.coreContext = .init(source: source)
    }

    public var requestDecoder: URLFormRequestDecoder {
        .init()
    }

}
