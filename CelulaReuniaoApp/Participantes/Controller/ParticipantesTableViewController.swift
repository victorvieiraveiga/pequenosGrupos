//
//  ParticipantesTableViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 04/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import SDWebImage

class ParticipantesTableViewController: UITableViewController {

    
    @IBOutlet weak var menuMapa: UITabBarItem!
    
    
    var context : NSManagedObjectContext!
    
    let  celula = BuscaIdCelula()
    var participantes : [Participante] = []
    var idCelula : String = ""
    var indexRow : Int = -1
    
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        //Atualiza Table View Apos exclusao
        atualizaTableViewExclusao()

        let logado = VerificaUsuarioLogado()
        
        if logado == "desconectado" {
            performSegue(withIdentifier: "voltaHome", sender: logado)
        }
        else {
            let database = Database.database().reference()
        
            //pega id da celula do usuario logado
            let autenticacao = Auth.auth()
            autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
            
            let usuarioLogado = usuario?.uid
            let database = Database.database().reference()
            let celula = database.child("celula").queryOrderedByKey().queryEqual(toValue: usuarioLogado)
            
            celula.observe(DataEventType.childAdded, with: { (CelulaSnapshot) in
                    let dadosCel = CelulaSnapshot.value as! NSDictionary
                    self.idCelula = dadosCel["idCelula"] as! String
                    let participantes = database.child("participantes").queryOrdered(byChild: "idCelula").queryEqual(toValue: self.idCelula)
        
                participantes.observe(DataEventType.childAdded, with: { (usuSnapshot) in
                    let dados = usuSnapshot.value as! NSDictionary
                    let nome = dados["nome"] as! String
                    let endereco = dados["endereco"] as! String
                    let email = dados["email"] as! String
                    let telefone = dados["telefone"] as! String
                    let dtNascimento = dados["dataNascimento"] as! String
                    //let idImagem =
                    let idCelula = self.idCelula
                    let idParticipante = usuSnapshot.key
                    let idImagem = dados["idImagem"] as! String
                    let urlImagem = dados["urlImagem"] as!String
                    let participante = Participante(nome: nome, endereco: endereco, email: email, telefone: telefone, dataNascimento: dtNascimento, idCelula: idCelula, idParticipante: idParticipante, idImagem: idImagem, urlImagem:urlImagem  )
                 
                    self.participantes.append(participante)
                    self.tableView.reloadData()
            
                    })
                })
            }
        }
    }
    


    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.participantes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula: ItemCell = tableView.dequeueReusableCell(withIdentifier: "celulaParticipantes", for: indexPath) as! ItemCell

        
        
        // Configure the cell...
        let participante = self.participantes[indexPath.row]
        
        let nome = participante.nome
        let endereco = participante.endereco
//        let telefone = participante.value(forKey: "telefone")
//        let email = participante.value(forKey: "email")
        let nascimento = participante.dataNascimento
        
        if  participante.urlImagem != "" {
            let url = URL(string: participante.urlImagem )
            
            celula.foto?.sd_setImage(with: url, completed: { (image, erro, cache, url) in
                print("foto exibida")
            })
        }
        
        celula.nomeLabel.text = nome as? String
        //celula.dataNascimentoLbel.text = nascimento as? String
        celula.enderecoLabel.text = endereco as? String
        
        return celula
    }
    //seleciona registra e vai para o detalhe
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        self.indexRow = indice
        let participante = self.participantes[indice]
        self.performSegue(withIdentifier: "verParticipante", sender: participante)
    }
    
    //remove registro
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let partRemove = self.participantes[indexPath.row]
            
            let database = Database.database().reference()

                let participante = database.child("participantes").queryOrderedByKey().queryEqual(toValue: partRemove.idParticipante)

            participante.observeSingleEvent(of: DataEventType.childAdded) { (partSnap) in
                let PartDados = database.child("participantes").child(partRemove.idParticipante)
                PartDados.removeValue()
                
                self.tableView.reloadData()
            }
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verParticipante" {
            let viewDestino  = segue.destination as! IncluirParticipantes
            
            viewDestino.participantes = participantes
            viewDestino.index = self.indexRow
        }
        if segue.identifier == "mapaSegue" {
            let viewDestino  = segue.destination as! MapaParticipantes
            
            viewDestino.participante = participantes
            
        }
    }
    
    
    func VerificaUsuarioLogado () -> String {
        var logado : String = ""
        
        let autenticacao = Auth.auth()
        
        if let usuariologado = autenticacao.currentUser?.uid {
            logado = "logado"
        }
        else {
            logado = "desconectado"
        }
        return logado
    }
    
    
    func atualizaTableViewExclusao () {
        //evento para item removido
        let database = Database.database().reference()
        let part = database.child("participantes")
        
        part.observe(DataEventType.childRemoved) { (snapshot) in
            print(snapshot)
            
            var indice = 0
            
            for p in self.participantes {
                if p.idParticipante == snapshot.key {
                    self.participantes.remove(at: indice)
                }
                indice = indice + 1
            }
            self.tableView.reloadData()
        }
    }

}
