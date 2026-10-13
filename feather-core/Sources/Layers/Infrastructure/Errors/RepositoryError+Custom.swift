//
//  RepositoryError+Custom.swift
//  feather-core
//
//  Created by Tibor Bödecs on 2026. 02. 28.
//

extension RepositoryError {

    public static var notFound: Self {
        .init(
            reason: .database(.notFound),
            logMessage: "Entity not found",
            userFriendlyMessage: "Entity not found."
        )
    }

    public static func invalidEnumValue(
        _ value: String
    ) -> Self {
        .init(
            reason: .database(.rowDecoding),
            logMessage: "Invalid enum value: \(value)",
            userFriendlyMessage: "Invalid enum value.",
            underlyingErrors: []
        )
    }
}
