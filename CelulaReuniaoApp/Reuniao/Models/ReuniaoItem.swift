//
//  ReuniaoItem.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 25/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit

class ReuniaoItem {

    var dataReuniao: String
    var participantes: String
    var observacoes: String
    var idCelula: String
    var idReuniao: String
    var celulaNome : String
    
    init(dataReuniao: String,participantes: String, observacoes: String, idCelula: String, idReuniao: String, celulaNome: String) {
        self.dataReuniao = dataReuniao
        self.participantes = participantes
        self.observacoes = observacoes
        self.idCelula = idCelula
        self.idReuniao = idReuniao
        self.celulaNome = celulaNome
        
    }
    

}
