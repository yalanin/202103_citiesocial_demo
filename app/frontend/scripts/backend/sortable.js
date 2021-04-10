import Sortable from 'sortablejs';
import Rails from "@rails/ujs";

document.addEventListener('turbolinks:load', ()=>{
  let element = document.querySelector('.sortable-items')
  if(element){
    Sortable.create(element, {
      onEnd: event => {
        let [model, id] = event.item.dataset.item.split('_');
        let data = new FormData();
        data.append("id", id);
        data.append("from", event.oldIndex);
        data.append("to", event.newIndex);

        Rails.ajax({
          url: '/admin/categories/sort',
          type: 'PUT',
          data,
          success: res => {
            console.log(res);
          },
          error: err => {
            console.log(err);
          }
        })
      }
    });
  }
})