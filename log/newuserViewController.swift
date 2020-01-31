import UIKit
import Alamofire
import SwiftyJSON

class newuserViewController: UIViewController {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBAction func regbutton(_ sender: Any) {
        print("register Pressed")
        guard let email = username.text, !email.isEmpty
            else {
            showAlert(alertTitle: "Null entry", alertMessage: "Please enter your email id", alertAction: "Ok")
            return
        }
        guard let pword = password.text, !pword.isEmpty
            else {
            showAlert(alertTitle: "Null entry", alertMessage: "Please enter your password", alertAction: "Ok")
            return
        }
        checkForValidUser(userEmail:email, userPword: pword)
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    func checkForValidUser(userEmail: String, userPword: String)
    {
        let parameters: Parameters = ["email": userEmail,"password": userPword, "fun": "reg"]
        let url  = "https://bgfexn4owb.execute-api.me-south-1.amazonaws.com/prod/myApp"
        Alamofire.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("LoginAPIJSON: \(json)")
                if (json["statusCode"] == 200) {
                    print("Registration Successfull")
                    UserDefaults.standard.set(userEmail, forKey: "userEmail")
                    self.showAlert(alertTitle: "Registeration Sucessfull", alertMessage: "", alertAction: "Ok")
//                    mself.performSegue(withIdentifier: "regsucess", sender: self)
                }
                else {
                    print("try again")
                    self.showAlert(alertTitle: "alreays exist", alertMessage: "try login", alertAction: "Ok")
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func showAlert(alertTitle: String, alertMessage: String, alertAction: String) {
        let alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: alertAction, style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
