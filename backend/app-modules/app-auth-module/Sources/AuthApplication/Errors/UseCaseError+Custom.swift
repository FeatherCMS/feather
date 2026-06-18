//
//  File.swift
//  backend
//
//  Created by Tibor Bödecs on 2026. 02. 28..
//

//import FeatherValidation

public extension UseCaseError {

    static func authentication() -> Self {
        .init(
            reason: .auth,
            logMessage: "authentication_error",
            userFriendlyMessage: "Authentication error."
        )
    }

    //    static func validation(_ error: ValidationError) -> Self {
    //        .init(
    //            reason: .validation,
    //            logMessage: "validation_error",
    //            userFriendlyMessage: "Validation error.",
    //            underlyingErrors: [error]
    //        )
    //    }
}
