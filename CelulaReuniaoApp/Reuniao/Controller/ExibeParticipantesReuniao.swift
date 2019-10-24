//
//  ExibeParticipantesReuniao.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 21/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class ExibeParticipantesReuniao: UITableViewController {
    
    @IBOutlet var teView: UITableView!
    
    @IBOutlet weak var txDataReuniao: UILabel!
    
    var dataReuniao : String = ""
    
    var participantes : [Participante] = []
    
    var partiReuniaoDados: [String] = []
  //  var partiReuniaoDados: NSDictionary = [:]
    var idCelula: String = "victorvieiraveiga@gmail.com"
  

    
    override func viewDidLoad() {
        super.viewDidLoad()
        txDataReuniao.text = dataReuniao
        initialize()

    }
    //MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.participantes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "ReuniaoPaticipantes", for: indexPath)
       
        // Configure the cell...
        let participante = self.participantes[indexPath.row]
        celula.textLabel?.text = participante.nome
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        let indice = indexPath.row
        let participante = self.participantes[indice]
        //self.performSegue(withIdentifier: "verParticipante", sender: participante)
        
        //DESSELECIONAR PARTICIPANTE
        if let cell = tableView.cellForRow(at: indexPath) {
            
            if cell.accessoryType == .checkmark {
                cell.accessoryType = .none
                
                partiReuniaoDados.remove(at: indice)
                
               
            }//SELECIONAR PARTICIPANTES
            else {
                cell.accessoryType = .checkmark
                partiReuniaoDados.append(participante.nome)
            }
            
            print(partiReuniaoDados)
            print (indexPath.row)
            //print (nlinhas)
            
        }
    }
override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    let Destino = segue.destination as! SalvarReuniaoViewController
    
    Destino.participantes = partiReuniaoDados
    Destino.dataReuniao = dataReuniao
    Destino.idCelula = idCelula
    
}

}
extension ExibeParticipantesReuniao {
    
    func initialize () {
        let database = Database.database().reference()
        //pega id da celula do usuario logado
        let autenticacao = Auth.auth()
        if let usuarioLogado = autenticacao.currentUser?.uid {
            //autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            //let usuarioLogado = usuario?.uid
            let database = Database.database().reference()
            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            celula.observe(DataEventType.childAdded, with: { (CelulaSnapshot) in
                let dadosCel = CelulaSnapshot.value as! NSDictionary
                
                self.idCelula = dadosCel["idCelula"] as! String
                let participantes = database.child("participantes").queryOrdered(byChild: "idCelula").queryEqual(toValue: self.idCelula)
                participantes.observe(DataEventType.childAdded, with: { (usuSnapshot) in
                    // print (usuSnapshot)
                    
                    let dados = usuSnapshot.value as! NSDictionary
                    let nome = dados["nome"] as! String
                    let endereco = dados["endereco"] as! String
                    let email = dados["email"] as! String
                    let telefone = dados["telefone"] as! String
                    let dtNascimento = dados["dataNascimento"] as! String
                    let idCelula = self.idCelula
                    let idParticipante = usuSnapshot.key
                    let idImagem = dados["idImagem"] as! String
                    let urlImagem = dados["urlImagem"] as! String
                    
                    
                    let participante = Participante(nome: nome, endereco: endereco, email: email, telefone: telefone, dataNascimento: dtNascimento, idCelula: idCelula, idParticipante: idParticipante, idImagem: idImagem, urlImagem: urlImagem)
                    self.participantes.append(participante)
                    self.tableView.reloadData()
                })
            })
        }
    }
}
