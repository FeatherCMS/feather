//
//  Identity+Model+Tests.swift
//  app-user-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherDomain
import Testing
import UserModule

import struct Foundation.Date

@testable import UserDomain

@Suite
struct IdentityModelTests {

    @Test
    func identityCreatePreservesActiveStatus() async throws {
        let identity = Identity.Model.create(status: .active)

        #expect(identity.status == .active)
    }

    @Test
    func identityUpdateChangesStatus() async throws {
        var identity = makeIdentity()
        identity.update(status: .set(.active))
        #expect(identity.status == .active)
    }

}

private func makeIdentity() -> Identity.Model {
    .init(
        id: "a1",
        status: .invited,
        isRoot: false,
        createdAt: Date(),
        updatedAt: Date()
    )
}
