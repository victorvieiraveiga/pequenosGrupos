//
//  ListarUsuariosTableViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 01/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import Firebase

class ListarUsuariosTableViewController: UITableViewController {
    //var context : NSManagedObjectContext!
    //var usuarios : [NSManagedObject] = []
    var usuariosCelula : NSDictionary = [:]
    
    var usuarios : [Usuario] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let database = Database.database().reference()
        let usuarios = database.child("usuarios")
        
        usuarios.observe(DataEventType.childAdded, with: { (usuSnapshot) in
           // print (usuSnapshot)
            
            let dados = usuSnapshot.value as! NSDictionary
            
            let nomeUsuario = dados["nome"] as! String
            let emailUsuario = dados["email"] as! String
            let temCelula = dados["temCelula"] as! String
            let idUsuario = usuSnapshot.key
            
            let usuario = Usuario(nome: nomeUsuario, email: emailUsuario, uid: idUsuario, temCelula: temCelula)
            
            self.usuarios.append(usuario)
            self.tableView.reloadData()
            
            
        })

    }
    
    
//    func recuperarUsuariosFirebase () {
//       // let autenticacao = Auth.auth()
//
//       // autenticacao.addStateDidChangeListener { (autenticacao, usuario) in
//        //    let usuarioLogado = usuario?.uid
//
//            let database = Database.database().reference()
//            let usuarios = database.child("usuarios")
//
//            usuarios.observe(DataEventType.childAdded, with: { (usuSnapshot) in
//                print (usuSnapshot)
//                let dados = usuSnapshot.value as! NSDictionary
//
//                self.usuariosCelula = dados
//
//                self.tableView.reloadData()
//
//
//            })
//
//       // }
//
//    }
    
//    func recuperaUsuarios () {
//         let requisicao = NSFetchRequest <NSFetchRequestResult>(entityName: "Usuarios")
//
//        do {
//            let usuariosRecuperados = try context.fetch(requisicao)
//            self.usuarios = usuariosRecuperados as! [NSManagedObject]
//           // self.tableView.reloadData()
//
////            if usuarios.count > 0 {
////                for usuario in usuarios as! [NSManagedObject] {
////                    let nome = usuario.value(forKey: "nome")
////                    let login = usuario.value(forKey: "login")
////                    let senha = usuario.value(forKey: "senha")
////
////                }
////            }else {
////                print ("nenhum usuario encontrado")
////            }
//        } catch  {
//            print ("Erro ao recuperar dados")
//        }
//    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.usuarios.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celula = tableView.dequeueReusableCell(withIdentifier: "celulaUsuarios", for: indexPath)


        let usuario = self.usuarios[indexPath.row]
        
        celula.textLabel?.text = usuario.nome
        celula.detailTextLabel?.text = "Login: " + (usuario.email)
        
        return celula
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            self.tableView.deselectRow(at: indexPath, animated: true)
        
            let indice = indexPath.row
            let usuario = self.usuariosCelula[indice]
            self.performSegue(withIdentifier: "verUsuario", sender: usuario)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "verUsuario" {
            let viewDestino  = segue.destination as! CadastroUsuarioViewController
            
            //viewDestino.usuario = sender as? NSManagedObject
        }
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
