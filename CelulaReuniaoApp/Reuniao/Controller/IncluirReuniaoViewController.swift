//
//  IncluirReuniaoViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 21/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class IncluirReuniaoViewController: UIViewController {

    @IBOutlet weak var txtData: UILabel!
    @IBOutlet weak var dtDiaReuniao: UIDatePicker!

 
    
    var participantes : [Participante] = []
    var idCelula: String = "victorvieiraveiga@gmail.com"
    
    var partSelecionado : String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtData.text = dateFormatter.string(from: self.dtDiaReuniao.date)
        
 
    }
    
    
    @IBAction func dataReuniaoChange(_ sender: Any) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        txtData.text = dateFormatter.string(from: self.dtDiaReuniao.date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let Destino = segue.destination as! ExibeParticipantesReuniao
        if  txtData.text != nil {
            Destino.dataReuniao = txtData.text!
        }else {
            print ("erro")
        }
        Destino.idCelula = idCelula
    }
    
    
}





