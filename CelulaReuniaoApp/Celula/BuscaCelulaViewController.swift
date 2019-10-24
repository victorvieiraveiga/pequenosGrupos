//
//  BuscaCelulaViewController.swift
//  CelulaReuniaoApp
//
//  Created by Victor Vieira on 09/08/19.
//  Copyright © 2019 Victor Vieira. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth


class BuscaCelulaViewController: UIViewController {

    @IBOutlet weak var emailLiderCelula: UITextField!
    var emailLogado = String()
    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.revealViewController() != nil {
            menuButton.target = self.revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        
        
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let ViewDestino: HomeCelulaViewController = segue.destination as! HomeCelulaViewController
        
        if let email = self.emailLiderCelula.text{
            ViewDestino.idCelula = email
        
            print ("##################")
            print (email)
      
        }
    }
    
    @IBAction func busca_celula(_ sender: Any) {
        
        if let idCelula = emailLiderCelula.text {
            
            let database  = Database.database().reference()
             let celula = database.child("celula").queryOrdered(byChild: "idCelula").queryEqual(toValue: idCelula)
            
            celula.observe(DataEventType.childAdded, with: {(celulaRecuperada) in
                let dados = celulaRecuperada.value as! NSDictionary
               // print (celula)
               // print (dados)
                
                if dados.value(forKey: "idCelula") != nil {
                    
                    self.emailLiderCelula.text = dados.value(forKey: "idCelula") as! String
                    self.performSegue(withIdentifier: "SalvarCelulaSegue", sender: nil)
                }
            })

        }else {
            exibeMensagemAlerta(titulo: "Erro.", mensagem: "Dados invalidos. Tente novamente.")
        }
    }

    func exibeMensagemAlerta (titulo: String, mensagem:String){
        let myAlert = UIAlertController(title: titulo, message: mensagem, preferredStyle: .alert)
        let oKAction = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil)
        myAlert.addAction(oKAction)
        self.present(myAlert, animated: true, completion: nil)
    }

}


