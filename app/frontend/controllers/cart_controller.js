import { Controller } from "stimulus"

export default class extends Controller {
  static targets = ['count']

  updateCart(env){
    let data = env.detail;
    this.countTarget.innerText = `(${data.item_count})`;
  }
}