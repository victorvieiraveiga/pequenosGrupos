//
//  Participante.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 18/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import Foundation

class Participante {
    
    var nome: String
    var endereco : String
    var email: String
    var telefone: String
    var dataNascimento: String
    var idCelula : String
    var idParticipante: String
    var idImagem: String
    var urlImagem : String
    
    init (nome: String,endereco : String, email: String,telefone: String, dataNascimento: String, idCelula: String, idParticipante: String, idImagem: String, urlImagem: String ) {
        self.nome = nome
        self.endereco = endereco
        self.email = email
        self.telefone = telefone
        self.dataNascimento = dataNascimento
        self.idCelula = idCelula
        self.idParticipante = idParticipante
        self.idImagem = idImagem
        self.urlImagem = urlImagem
        
    }
    
}
