//
//  Celula.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 08/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit

class Celulas {
    
    var uidCelula: String
    var nomeLider: String
    var nomeAnfitriao : String
    var endCelula: String
    var diaCelula: String
    var horarioCelula: String
    //var idUsuario: String
    var tipoGrupo : String
    
    
    
    init(uidCelula: String, nomeLider: String,nomeAnfitriao : String,endCelula: String,diaCelula:String, horarioCelula: String, tipoGrupo: String)
    {
        self.uidCelula = uidCelula
        self.nomeLider = nomeLider
        self.nomeAnfitriao = nomeAnfitriao
        self.endCelula = endCelula
        self.diaCelula = diaCelula
        self.horarioCelula = horarioCelula
        self.tipoGrupo = tipoGrupo
       // self.idUsuario = idUsuario
    }
    
}
