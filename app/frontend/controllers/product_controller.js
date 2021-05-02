import { Controller } from "stimulus"

export default class extends Controller {
  static targets = [ 'quantity' ]

  quantity_minus(e){
    e.preventDefault();
    let q = Number(this.quantityTarget.value);
    if(q > 1) {
      this.quantityTarget.value = q - 1;
    }
  }

  quantity_plus(e){
    e.preventDefault();
    let q = Number(this.quantityTarget.value);
    this.quantityTarget.value = q + 1;
  }
}