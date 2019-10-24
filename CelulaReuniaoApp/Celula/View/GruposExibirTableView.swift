//
//  GruposExibirTableView.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 02/10/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import  Firebase

class GruposExibirTableView: UITableViewController {

    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    var grupos : [Celulas] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        atualizaTableViewExclusao()
        //Menu
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        let database = Database.database().reference()
        let autenticacao = Auth.auth()
        let usuarioLogado = autenticacao.currentUser?.uid as! String
        
        
        //evento para item removido
       //let autenticacao = Auth.auth()
       // let usuarioLogado = autenticacao.currentUser?.uid
        //let database = Database.database().reference()
        let grupoRemove = database.child("usuarios").child(usuarioLogado)
        
        grupoRemove.observe(DataEventType.childRemoved) { (snapshot) in
            print(snapshot)
            
            var indice = 0
            
            for p in self.grupos {
                if p.uidCelula == snapshot.key {
                    self.grupos.remove(at: indice)
                }
                indice = indice + 1
            }
            self.tableView.reloadData()
        }
        
        
        

        
        let grupo = database.child("usuarios").child(usuarioLogado).child("grupo")
        
        grupo.observe(DataEventType.childAdded) { (grupoSnapshot) in
            
            let dados = grupoSnapshot.value as! NSDictionary
            
            let uidGrupo = grupoSnapshot.key//grupo.key
            let lider = dados["lider"]
            let tipoGrupo = dados["tipoGrupo"]
            let anfitriao = dados["anfitriao"]
            let endereco = dados["endereco"]
            let dia = dados["dia"]
            let horario = dados["horario"]
            
            let gruposDados = Celulas(uidCelula: uidGrupo, nomeLider: lider as! String, nomeAnfitriao: anfitriao as! String, endCelula: endereco as! String, diaCelula: dia as! String, horarioCelula: horario as! String, tipoGrupo: tipoGrupo as! String)
            
            self.grupos.append(gruposDados)
            self.tableView.reloadData()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        atualizaTableViewExclusao()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return grupos.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cel = tableView.dequeueReusableCell(withIdentifier: "GrupoCell")
        
        let grupo = self.grupos[indexPath.row]
        
        cel?.textLabel?.text = grupo.tipoGrupo
        cel?.detailTextLabel?.text = grupo.nomeLider
        
        return cel!
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        let indice = indexPath.row
        //self.indexRow = indice
        let grupo = self.grupos[indice]
        self.performSegue(withIdentifier: "verParticipante", sender: grupo)
    }
    
    //remove registro
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            
            let grupoRemove = self.grupos[indexPath.row]
            
            let database = Database.database().reference()
            let autenticacao = Auth.auth()
            let usuarioLogado = autenticacao.currentUser?.uid as! String
            
            let grupo = database.child("usuarios").child(usuarioLogado).child("grupo").queryOrderedByKey().queryEqual(toValue: grupoRemove.uidCelula)
            
            
            grupo.observeSingleEvent(of: DataEventType.childAdded) { (grSnap) in
                let grDados = database.child("usuarios").child(usuarioLogado).child("grupo").child(grupoRemove.uidCelula)
                grDados.removeValue()
                
                
                self.atualizaTableViewExclusao ()
                self.tableView.reloadData()
                
            }
            
        }
    }
    

    func atualizaTableViewExclusao () {
        //evento para item removido
        let autenticacao = Auth.auth()
        let usuarioLogado = autenticacao.currentUser?.uid
        let database = Database.database().reference()
        let grupo = database.child("usuarios").child(usuarioLogado!).child("grupo")
        
        grupo.observe(DataEventType.childRemoved) { (snapshot) in
            print(snapshot)
            
            var indice = 0
            
            for p in self.grupos {
                if p.uidCelula == snapshot.key {
                    self.grupos.remove(at: indice)
                }
                indice = indice + 1
            }
            self.tableView.reloadData()
        }
    }
    

   


}
