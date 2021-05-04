import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = [ 'quantity', 'sku', 'addToCartBtn' ]

  add_to_cart(e){
    e.preventDefault();

    let product_id = this.data.get('id');
    let quantity = this.quantityTarget.value;
    let sku = this.skuTarget.value;

    if(quantity > 0){
      this.addToCartBtnTarget.classList.add('is-loading');
      let data = new FormData();
      data.append('id', product_id);
      data.append('quantity', quantity);
      data.append('sku', sku);

      Rails.ajax({
        url: '/api/v1/cart',
        data,
        type: 'POST',
        dataType: 'json',
        success: (response) => {
          console.log(response);
        },
        error: function(err){
          console.log(err);
        }
      })
    }
  }

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