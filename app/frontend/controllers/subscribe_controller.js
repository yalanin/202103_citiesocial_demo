import { Controller } from "stimulus";
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ["email"]

  add(event){
    event.preventDefault();

    let email = this.emailTarget.value.trim();
    let data = new FormData();
    data.append("subscribe[email]", email);

    Rails.ajax({
      url: 'api/v1/subscribe',
      type: 'POST',
      dataType: 'json',
      data: data,

      success: (response) => {
        switch(response.status){
          case 'ok':
            alert('電子報已訂閱');
            this.emailTarget.value = '';
            break;
          case 'failed':
            // let responseText = `${response.email}`;
            let responseText = ''
            let newLine = '\r\n';
            // responseText += ':';
            // responseText += newLine;
            response.messages.forEach(function(message){
              responseText += message;
              responseText += newLine;
              alert(responseText);
            })
            break;
        }
      },
      error: function(err){
        console.log(err);
      }
    });
  }
}