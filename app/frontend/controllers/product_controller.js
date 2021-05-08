import { Controller } from "stimulus"
import Rails from "@rails/ujs";

export default class extends Controller {
  static targets = ['quantity', 'sku', 'addToCartBtn']

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
          if(response.status == 'ok'){
            let item_count = response.items || 0;
            let event = new CustomEvent('addToCart', { 'detail': { item_count } });
            document.dispatchEvent(event);
          }
        },
        error: function(err){
          console.log(err);
        },
        complete: () => {
          this.addToCartBtnTarget.classList.remove('is-loading');
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