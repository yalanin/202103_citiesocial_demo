import bulmaCarousel from 'bulma-carousel';

document.addEventListener('turbolinks:load', ()=>{
  let marquee = document.querySelector('#carousel');
  if(marquee) {
    bulmaCarousel.attach('#carousel', {
      slidesToScroll: 1,
      slidesToShow: 4,
      infinite: true,
      autoplay: true
    });
  }
});