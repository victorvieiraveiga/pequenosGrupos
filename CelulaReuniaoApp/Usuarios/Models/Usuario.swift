//
//  Usuario.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 17/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit

class Usuario {

    var nome: String
    var email: String
    var uid: String
    var temCelula: String

    init (nome: String, email: String,uid: String, temCelula: String) {
        self.nome = nome
        self.email = email
        self.uid = uid
        self.temCelula = temCelula
    }

}
