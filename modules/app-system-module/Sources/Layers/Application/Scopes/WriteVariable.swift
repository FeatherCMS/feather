//
//  WriteVariable.swift
//  app-system-module
//
//  Created by Binary Birds on 2026. 06. 18.

import FeatherApplication
import FeatherContracts
import SystemDomain

public struct WriteVariable: Scope {
    public let variable: any VariableRepository

    public init(variable: any VariableRepository) {
        self.variable = variable
    }
}
