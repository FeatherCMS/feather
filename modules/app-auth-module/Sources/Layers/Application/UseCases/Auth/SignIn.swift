//
//  SignIn.swift
//  app-auth-module
//
//  Created by Binary Birds on 2026. 06. 18.

import AuthDomain
import FeatherApplication
import FeatherContracts
import FeatherDomain
import UserDomain

import struct Foundation.Date

protocol SignIn: UseCase {

    func makeAuthResponse(
        userIdentityRepository: any IdentityRepository,
        userSessionRepository: any SessionRepository,
        user: Identity,
        authenticationType: String,
        authenticationReference: String,
        isPersistent: Bool
    ) async throws -> AuthDetail

}

extension SignIn {

    func makeAuthResponse(
        userIdentityRepository: any IdentityRepository,
        userSessionRepository: any SessionRepository,
        user: Identity,
        authenticationType: String,
        authenticationReference: String,
        isPersistent: Bool
    ) async throws -> AuthDetail {
        let identityId = user.id

        let (roles, permissions) = try await (
            userIdentityRepository.findRolesBy(
                identityId: identityId
            ),
            userIdentityRepository.findPermissionsBy(
                identityId: identityId
            )
        )

        let sessionLifetime =
            isPersistent
            ? Session.Lifetimes.persistent : Session.Lifetimes.regular

        let session = try await userSessionRepository.insert(
            Session.create(
                token: generateToken(),
                identityId: identityId,
                authenticationType: authenticationType,
                authenticationReference: authenticationReference,
                expiresAtInterval: sessionLifetime,
                isPersistent: isPersistent
            )
        )

        return .init(
            user: user,
            session: session,
            roles: roles,
            permissions: permissions
        )
    }
}
